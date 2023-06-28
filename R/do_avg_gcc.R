# pm25_pred = seasonal + trend + remainder
# SEASONAL = recurring patterns of pollution
# TREND = tendency of the data over time
# REMAINDER (residual) = part of the data that cannot be explained by the 
## seasonal and trend components.  Day-to-day fluctuations that cannot be 
## attributed to seasonal or long-term trends

do_avg_gcc <- function (
    pm25_stl
){
  # Check for missing values
  #any(is.na(set_counterfactual$seasonal)) 
  #any(is.na(set_counterfactual$trend))
  #any(is.na(set_counterfactual$pm25_pred))
  
  ## population as numeric
  pm25_stl$pop <- as.numeric(pm25_stl$pop)
  
  ## averages by gccs and date and sum population (SA1s sum = GCC)
  pm25 <- pm25_stl[,.(
    pm25_pred = mean(pm25_pred, na.rm = T),
    remainder = mean(remainder, na.rm = T),
    seasonal = mean(seasonal, na.rm = T),
    trend = mean(trend, na.rm = T),
    pop = sum(pop, na.rm = T)
  ), 
  by = c("gcc_code16", "date")]
  return(pm25)
}