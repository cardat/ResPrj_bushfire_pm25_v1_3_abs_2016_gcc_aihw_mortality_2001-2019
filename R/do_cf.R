do_cf <- function(
    pm25
){
  # Calculate counterfactual cf = seasonal + trend
  pm25[, cf := seasonal + trend]
  
  ## Assign cf values to pm25_pred negative numbers
  pm25$pm25_pred[pm25$pm25_pred < 0] <- pm25$cf[pm25$pm25_pred < 0]
  
  ## Calculate Δ = (predicted pm2.5) - (counterfactual)
  pm25[, delta := pm25_pred - cf]
  # ## set a treshold 2 standard deviations from the remainder days
  pm25[, threshold := sd(remainder) * 2]
  
  # ## set a binary variable, yes or no extreme smoke day based on cf + treshold
  # pm25$extreme_smoke_day <- ifelse(
  #   pm25$pm25_pred >= (pm25$cf + pm25$threshold), 1, 0)
  # 
  # pm25$extreme_smoke <- ifelse(
  #   pm25$extreme_smoke_day == 1,
  #   # assign whichever is higher, remainder of pm25_pred
  #   pmax(pm25$remainder, pm25$pm25_pred),
  #   # if extreme_smoke_day not equal to 1, assign NA
  #   NA)
  
  # # Create the "good" variable and assign pm25_pred values
  pm25[, good := ifelse(
    pm25_pred < 5,
    pm25_pred, NA)]
  
  # For the 'moderate' category
  pm25[, moderate := ifelse(
    pm25_pred >= 5 & pm25_pred < 15,
    pm25_pred, NA)]
  
  # For the 'unhealthy_sensitive' category
  pm25[, unhealthy_sensitive := ifelse(
    pm25_pred >= 15 & pm25_pred < 25,
    pm25_pred, NA)]
  
  # For the 'unhealthy' category
  pm25[, unhealthy := ifelse(
    pm25_pred >= 25 & pm25_pred < 50,
    pm25_pred, NA)]
  
  # For the 'very_unhealthy' category
  pm25[, very_unhealthy := ifelse(
    pm25_pred >= 50 & pm25_pred < 100,
    pm25_pred, NA)]
  
  # For the 'hazardous' category
  pm25[, hazardous := ifelse(
    pm25_pred >= 100 & pm25_pred < 300,
    pm25_pred, NA)]
  
  # For the 'extreme' category
  pm25[, extreme := ifelse(
    pm25_pred >= 300,
    pm25_pred, NA)]
  
  return(pm25)
}