do_plot_extreme_days <- function(
    pm25,
    yarea = c(0,100),
    gcc_title = "Sydney",
    gcc = "1GSYD"
    
){
  
  ### Sydney 21st century ####
  ## gcc and date
  qc4 <- pm25[gcc_code16 == gcc]
  
  # ## set a treshold 2 standard deviations from the remainder days
  qc4[, threshold := sd(remainder) * 2]
  
  # # # Create the "avoidable" variable and assign pm25_pred values
  # qc4[, avoidable := ifelse(
  #   pm25_pred > (cf) &
  #     pm25_pred < (cf + threshold),
  #   pm25_pred, NA)]
  
  ## set a binary variable, yes or no extreme smoke day based on cf + treshold
  qc4$extreme_smoke_day <- ifelse(
    qc4$pm25_pred >= (qc4$cf + qc4$threshold), 1, 0)
  
  qc4$extreme_smoke <- ifelse(
    qc4$extreme_smoke_day == 1,
    # assign whichever is higher, remainder of pm25_pred
    pmax(qc4$remainder, qc4$pm25_pred),
    # if extreme_smoke_day not equal to 1, assign NA
    NA)
  
  # # Create the "good" variable and assign pm25_pred values
  qc4[, good := ifelse(
    pm25_pred < 5,
    pm25_pred, NA)]
  
  # For the 'moderate' category
  qc4[, moderate := ifelse(
    pm25_pred >= 5 & pm25_pred < 15,
    pm25_pred, NA)]
  
  # For the 'unhealthy_sensitive' category
  qc4[, unhealthy_sensitive := ifelse(
    pm25_pred >= 15 & pm25_pred < 25,
    pm25_pred, NA)]
  
  # For the 'unhealthy' category
  qc4[, unhealthy := ifelse(
    pm25_pred >= 25 & pm25_pred < 50,
    pm25_pred, NA)]
  
  # For the 'very_unhealthy' category
  qc4[, very_unhealthy := ifelse(
    pm25_pred >= 50 & pm25_pred < 100,
    pm25_pred, NA)]
  
  # For the 'hazardous' category
  qc4[, hazardous := ifelse(
    pm25_pred >= 100 & pm25_pred < 300,
    pm25_pred, NA)]
  
  # For the 'extreme' category
  qc4[, extreme := ifelse(
    pm25_pred >= 300,
    pm25_pred, NA)]
  
  # # Identify start and end of each summer
  # summer_start_dates <- seq(as.Date("2001-12-01"), as.Date("2020-12-01"), by="year")
  # summer_end_dates <- seq(as.Date("2002-02-28"), as.Date("2021-02-28"), by="year")
  # summer_periods <- data.frame(start = summer_start_dates, end = summer_end_dates)
  
  # Calculate range of years to include in axis
  year_range <- range(as.numeric(format(qc4$date, "%Y")))
  
  # # margins
  # par(
  #   family = "Cambria",
  #   # mar = b,l,t,r
  #   mar=c(4, 4, 2, 2),
  #   mgp=c(3,1,0),
  #   oma = c(0, 0, 0, 0),
  #   las=1,
  #   cex.axis=0.9,
  #   cex.lab=1)
  
  # Define the plot window with enough space for the polygons and the data
  p <- plot(x = range(qc4$date), 
       y = c(0,100), 
       type = "n", 
       xlab = "", 
       ylab = "PM₂.₅ (µg/m³)", 
       xaxt = "n",
       ylim = yarea
  )
  
  # colours
  good <- do.call(rgb, c(as.list(col2rgb("#5BC5FF")), alpha=255/3, max=255))
  moderate <- do.call(rgb, c(as.list(col2rgb("#3A9F35")), alpha=255/3, max=255))
  unhealthy_sensitive <- do.call(rgb, c(as.list(col2rgb("#E2F38D")), alpha=255/4, max=255))
  unhealthy <- do.call(rgb, c(as.list(col2rgb("#EBC200")), alpha=255/3, max=255))
  very_unhealthy <- do.call(rgb, c(as.list(col2rgb("#E06900")), alpha=255/3, max=255))
  hazardous <- do.call(rgb, c(as.list(col2rgb("#B10025")), alpha=255/4, max=255))
  extreme <- do.call(rgb, c(as.list(col2rgb("#4F0018")), alpha=255/3, max=255))
  
  # Create horizontal polygons
  rect(par("usr")[1], 0, par("usr")[2], 5, col = good, border = NA)
  rect(par("usr")[1], 5, par("usr")[2], 15, col = moderate, border = NA)
  rect(par("usr")[1], 15, par("usr")[2], 25, col = unhealthy_sensitive, border = NA)
  rect(par("usr")[1], 25, par("usr")[2], 50, col = unhealthy, border = NA)
  rect(par("usr")[1], 50, par("usr")[2], 100, col = very_unhealthy, border = NA)
  rect(par("usr")[1], 100, par("usr")[2], 300, col = hazardous, border = NA)
  rect(par("usr")[1], 300, par("usr")[2], 600, col = extreme, border = NA)
  
  # Add vertical grid lines manually for each year
  years <- seq(from = as.Date("2001-01-01"), to = as.Date("2020-12-31"), by = "year")
  abline(v = years, col = "lightgray", lty = "dotted")
  
  # Add horizontal grid lines
  abline(h = seq(0, 100, by = 10), col = "lightgray", lty = "dotted")
  
  # # Add a polygon for each summer
  # for(i in 1:nrow(summer_periods)) {
  #   with(summer_periods[i, ], {
  #     polygon(c(start, end, end, start), c(0, 0, 100, 100), col="#E6E38E", border=NA)
  #   })
  # }
  
  # Add x-axis with yearly increments
  axis(1, at = seq(from = as.Date("2001-01-01"), 
                   to = as.Date("2020-12-31"), 
                   by = "year"), 
       format(seq(from = as.Date("2001-01-01"), 
                  to = as.Date("2020-12-31"), 
                  by = "year"), "%Y"))
  
  # # WHO 24h avg.
  # abline(h=15, lty="dashed", col = "deepskyblue")
  
  # # WHO annual
  # abline(h=5, lty="dashed", col = "blue")
  
  # Plot the good variable
  with(qc4, points(date, good, pch = 3, cex = 0.6, col = "#5BC5FF"))
  
  # Plot the 'moderate' variable
  with(qc4, points(date, moderate, pch = 20, cex = 0.5, col = "#3A9F35"))
  
  # Plot the 'unhealthy_sensitive' variable
  with(qc4, points(date, unhealthy_sensitive, pch = 19, cex = 1, col = "#CFEB41"))
  
  # Plot the 'unhealthy' variable
  with(qc4, points(date, unhealthy, pch = 17, cex = 0.8, col = "#EBC200"))
  
  # Plot the 'very_unhealthy' variable
  with(qc4, points(date, very_unhealthy, pch = 18, cex = 1, col = "#E06900"))
  
  # Plot the 'hazardous' variable
  with(qc4, points(date, hazardous, pch = 15, cex = 1, col = "#B10025"))
  
  # Plot the 'extreme' variable
  with(qc4, points(date, extreme, pch = 8, cex = 1, col = "#4F0018"))
  
  
  # Add x-axis label
  mtext(gcc_title, side = 3, line = -2, outer = FALSE)
  box()
  
  return(p)
}
