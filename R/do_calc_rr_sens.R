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
    threshold = 0.95
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
  
  # Create empty data.table to store the results
  # For each gcc we will have 3 columns: rr, lb, and ub
  rr_sens <- data.table(date = as.Date(character()))
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
  
  # Assign NA above threshold
  exclusion_value <- quantile(mrg_dat$pm25_pred, threshold, na.rm = TRUE)
  # cols_to_na <- c("remainder", "seasonal", "trend", "cf", "delta", 
  #                 "threshold", "good", "moderate", "unhealthy_sensitive",
  #                 "unhealthy", "very_unhealthy", "hazardous", "extreme")

  mrg_dat[mrg_dat$pm25_pred > exclusion_value]
  
  # Set mrg_dat$delta to 0 if mrg_dat$pm25_pred is > exclusion_value
  # delta = 0 means pm25_pred = cf, because delta = pm25_pred-cf
  mrg_dat$delta[mrg_dat$pm25_pred > exclusion_value] <- 0
  
  
  # Iterate through unique dates
  for(date_val in unique(mrg_dat$date)) {
    
    # Initialize a list to store the data for this date
    date_data <- list(date = as.Date(date_val, origin = "1970-01-01"))
    
    # Iterate through gccs
    for (gcc_val in gccs) {
      # Filter the data for the current gcc and date
      dat <- mrg_dat[gcc == gcc_val & date == date_val]
      
      # If dat$delta is NA, rr, lb and ub should be NA as well
      if (is.na(dat$delta)) {
        rr <- lb <- ub <- NA
      } else {
        # Estimate rr, lb and ub using the formula
        rr <- exp(beta[1] * dat$delta)
        lb <- exp(beta[2] * dat$delta)
        ub <- exp(beta[3] * dat$delta)
      }
      
      # Add the data for this gcc to the date_data list
      date_data[[paste0(gcc_val,"_rr")]] <- rr
      date_data[[paste0(gcc_val,"_lb")]] <- lb
      date_data[[paste0(gcc_val,"_ub")]] <- ub
    }
    
    # Add the data for this date to the rr_sens data.table
    rr_sens <- rbind(rr_sens, date_data, fill = TRUE)
    
    # When rr < 1 assign 1 (RR can't be a protective factor in this case, as it 
    # wouldn't change mortality rates)
    rr_sens[!is.na(rr_sens) & rr_sens < 1] <- 1
  }
  return(rr_sens)
}

