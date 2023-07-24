# Following HRAPIE project's recommendations for concentration–response 
# functions for cost–benefit analysis of particulate matter

# WHO Health risks of air pollution in Europe – HRAPIE project 2013
# PM, short-term exposure 
# Pollutant metric: PM2.5, daily mean
# Health outcome: Mortality, all-cause, all ages
# RR (95% CI) per 10 μg/m3: 1.0123 (1.0045–1.0201)

do_calc_rr_sens <- function(
    mrg_dat,
    # Define the percentile. 0.90 will exclude the upper 10th percent
    threshold = 0.99
){
  ## Relative risk per 10 pm2.5 unit change (10 μg/m3)
  hrapie = c(1.0123, 1.0045, 1.0201)  # RR, LB, UP respectively
  unit_change <- 10
  
  # Calculate the beta values for each component of hrapie
  beta <- log(hrapie)/unit_change
  
  gccs <- c("1GSYD", 
            "2GMEL", 
            "3GBRI", 
            "4GADE", 
            "5GPER", 
            "6GHOB", 
            "7GDAR", 
            "8ACTE")
  years <- 2001:2020
  
  # Create empty data.table to store the results
  # For each gcc we will have 3 columns: rr, lb, and ub
  rr_sens <- data.table(year = integer())
  for (gcc_val in gccs) {
    dt <- data.table(
      rr = numeric(), 
      lb = numeric(), 
      ub = numeric()
    )
    setnames(dt, 
             old = c("rr", "lb", "ub"), 
             new = c(
               paste0(gcc_val,"_rr"), 
               paste0(gcc_val,"_lb"), 
               paste0(gcc_val,"_ub")
             )
    )
    rr_sens <- cbind(rr_sens, dt)
  }
  
  # Exclude values above the percentile defined by the threshold
  exclusion_value <- quantile(mrg_dat$pm25_pred, threshold, na.rm = TRUE)
  mrg_dat <- mrg_dat[mrg_dat$pm25_pred <= exclusion_value,]
  
  # Iterate through years
  for (year_val in years) {
    # Initialize a list to store the data for this year
    year_data <- list(year = year_val)
    
    # Iterate through gccs
    for (gcc_val in gccs) {
      # Filter the data for the current gcc and year
      dat <- mrg_dat[gcc == gcc_val & year == year_val]
      
      # Compute the mean of "delta" for the current gcc and year
      mean_delta_year <- mean(dat$delta)
      
      # Estimate rr, lb and ub using the formula
      rr <- exp(beta[1] * mean_delta_year)
      lb <- exp(beta[2] * mean_delta_year)
      ub <- exp(beta[3] * mean_delta_year)
      
      # Add the data for this gcc to the year_data list
      year_data[[paste0(gcc_val,"_rr")]] <- rr
      year_data[[paste0(gcc_val,"_lb")]] <- lb
      year_data[[paste0(gcc_val,"_ub")]] <- ub
    }
    
    # Add the data for this year to the rr_sens data.table
    rr_sens <- rbind(rr_sens, year_data, fill = TRUE)
  }
  return(rr_sens)
}
