do_cf <- function(
    pm25
){
  # Calculate counterfactual cf = seasonal + trend
  mean(pm25[!is.na(seasonal) & !is.na(trend), cf := seasonal + trend], na.rm = T)
  
  ## Assign cf values to pm25_pred negative numbers
  pm25$pm25_pred[pm25$pm25_pred < 0] <- pm25$cf[pm25$pm25_pred < 0]
  
  # Assign cf values to pm25_pred missing values
  pm25$pm25_pred[is.na(pm25$pm25_pred)] <- pm25$cf[is.na(pm25$pm25_pred)]
  
  ## Calculate Δ = (predicted pm2.5) - (counterfactual)
  mean(pm25[, delta := pm25_pred - cf], na.rm = T)
  
  return(pm25)
}