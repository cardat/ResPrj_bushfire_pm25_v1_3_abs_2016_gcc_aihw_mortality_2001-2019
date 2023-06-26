# Define function to calculate cases based on concentration response function
calculate_cases <- function(
    avg_doy_all, 
    rr, 
    x = "pm25_pred", 
    xb = "seasonal + trend", 
    pop,
    cf
){
  cases <- avg_doy_all * (rr * (x - xb) / 10)
  return(cases)


# Create data table with mortality and relative risks
avg_doy_all <- c("All-cause mortality")
rr <- c(1.0123, 1.0190, 1.0091)
mort_dat <- data.table(mortality = avg_doy_all, relative_risk = rr)

# Set input values
# Baseline mortality per 1000 population
avg_doy_all <- 1000  
# Observed pm25 level (μg/m3)
x <- 25  
# Expected exposure level (μg/m3)
xb <- 10  
# Population size
pop <- 100000  

# Calc death
mort_dat[, death := calculate_cases(avg_doy_all, RelativeRisk, x, xb, pop)]
mort_dat[, death := calculate_cases(avg_doy_all, RelativeRisk, xb, xb, pop)]

print(mort_dat[, .(mortality, death, cf)])
}




