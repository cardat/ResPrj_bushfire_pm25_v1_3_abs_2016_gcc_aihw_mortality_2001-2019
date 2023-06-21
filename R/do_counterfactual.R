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
  return(pm25_stl)
}