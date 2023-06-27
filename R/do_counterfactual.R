# pm25_pred = seasonal + trend + remainder
# SEASONAL = recurring patterns of pollution
# TREND = tendency of the data over time
# REMAINDER (residual) = part of the data that cannot be explained by the 
## seasonal and trend components.  Day-to-day fluctuations that cannot be 
## attributed to seasonal or long-term trends

do_counterfactual <- function (
    pm25_stl
){
  # Check for missing values
  #any(is.na(set_counterfactual$seasonal)) 
  #any(is.na(set_counterfactual$trend))
  #any(is.na(set_counterfactual$pm25_pred))
  
  # Calculate counterfactual cf = seasonal + trend
  pm25_stl[!is.na(seasonal) & !is.na(trend), cf := seasonal + trend]
  
  ## Calculate Δ = (predicted pm2.5) - (counterfactual)
  pm25_stl[!is.na(pm25_pred) & !is.na(cf), delta := pm25_pred - cf]
  
  ## population as numeric
  pm25_stl$pop <- as.numeric(pm25_stl$pop)
  
  ## averages by gccs and date and sum population (SA1s sum = GCC)
  pm25 <- pm25_stl[,.(
    pm25_pred = mean(pm25_pred, na.rm = T),
    remainder = mean(remainder, na.rm = T),
    seasonal = mean(seasonal, na.rm = T),
    trend = mean(trend, na.rm = T),
    pop = sum(pop, na.rm = T),
    cf = mean(cf, na.rm = T),
    delta = mean(delta, na.rm = T)
  ), 
  by = c("gcc_code16", "date")]
  
  ## Assign cf values to pm25_pred negative numbers
  pm25$pm25_pred[pm25$pm25_pred < 0] <- pm25$cf[pm25$pm25_pred < 0]
  
  return(pm25)
}