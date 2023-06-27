# Following HRAPIE project's recommendations for concentration–response 
# functions for cost–benefit analysis of particulate matter

# WHO Health risks of air pollution in Europe – HRAPIE project 2013
# PM, short-term exposure 
# Pollutant metric: PM2.5, daily mean
# Health outcome: Mortality, all-cause, all ages
# RR (95% CI) per 10 μg/m3: 1.0123 (1.0045–1.0201)

do_calc_rr <- function(
    mrg_dat
){
## Relative risk per 10 pm2.5 unit change (10 μg/m3)
hrapie <- 1.0123
unit_change <- 10
beta <- log(hrapie)/unit_change

gccs <- c("1GSYD", 
          "2GMEL", 
          "3GBRI", 
          "4GADE", 
          "5GPER", 
          "6GHOB", 
          "7GDAR", 
          "8ACTE")
years <- 2002:2020

# Compute the mean of "delta" per year per "gcc"
mean_delta_year <- mrg_dat[, mean(delta), by = .(year, gcc)]

# Create an empty data.table to store the results
rr_dt <- data.table(gcc = character(), year = integer(), rr = numeric())

# Iterate through gccs and years
for (gcc_val in gccs) {
  for (year_val in years) {
    # Filter the data for the current gcc and year
    dat <- mrg_dat[gcc == gcc_val & year == year_val]
    
    # Compute the mean of "delta" for the current gcc and year
    mean_delta_year <- mean(dat$delta)
    
    # Estimate rr using the formula
    rr <- exp(beta * mean_delta_year)
    
    # Add the result to the rr_dt data.table
    rr_dt <- rbind(rr_dt, data.table(gcc = gcc_val, year = year_val, rr = rr))
  }
}
rr_dt <- dcast(rr_dt, year ~ gcc, value.var = "rr")
return(rr_dt)
}
