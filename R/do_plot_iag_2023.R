do_plot_iag_2023 <- function(
    sim_obs,
    pm25
){
  
  mel_mort <- dat_mort_aihw_simulated_2020[date >= as.Date("2008-11-01") & date <= as.Date("2009-04-30") & gcc == "2GMEL"]
  
  par(
    mfrow = c(1, 1),
    mar = c(0.2, 2, 0.2, 0.2),
    mgp = c(2.5, 1, 0),
    oma = c(4, 4, 0, 0),
    las = 1,
    cex.axis = 0.8,
    cex.lab = 1
  )
  
  plot(
    avg_doy_all ~ doy, mel_mort,
    pch = 19, col = grey(0.8), cex = 0.5,
    ylab = "Daily deaths", xlab = "Day of the year", main = ""
  )
  
  lines(
    1:180, tapply(mel_mort$avg_doy_all, mel_mort$doy, mean),
    lwd = 1.5, col = 4
  )
  
  # Add horizontal and vertical grid lines
  grid(nx = NULL, ny = NULL, lty = "dashed", col = "grey")
  
  # Add x-axis label
  mtext("Day of the Year", side = 1, line = 2, outer = TRUE)
  
  # Calculate the mean point
  mean_point <- mean(par("usr")[3:4])
  # Insert y-axis label
  text(
    par("usr")[1] - 20, mean_point, labels = "Daily deaths",
    xpd = NA, srt = 90, cex = 1.8
  )
  
  


## qc one month one gcc

## subset black saturday bushfire events - 6 months


## gcc and date
qc4 <- dat_cf[date >= as.Date("2002-11-01") & date <= as.Date("2003-04-30") & gcc_code16 == "5GPER"]
  
## set a treshold 2 standard deviations from the remainder days
threshold <- sd(qc$remainder) * 2

# Create the "avoidable" variable and assign pm25_pred values
qc4[, avoidable := ifelse(
  pm25_pred > (seasonal + trend) & 
    pm25_pred < threshold,
  pm25_pred, NA)]

## set a binary variable, yes or no extreme smoke day based on cf + treshold
qc4$extreme_smoke_day <- ifelse(
  qc4$pm25_pred >= (qc4$seasonal + qc4$trend + threshold), 1, 0)

qc4$extreme_smoke <- ifelse(
  qc4$extreme_smoke_day == 1, qc4$remainder, NA)


## start the plot
with(qc4, plot(
  date,
  pm25_pred,
  type = 'b',
  ylim = c(0,100),
  main = "Perth - Nov 2002 to Apr 2003"
  )
  )
## Plot the avoidable variable in green
with(qc4, points(
  date,
  avoidable,
  pch = 20,
  col = 'green')
)

## cf line
with(qc4, lines(
  date,
  seasonal + trend,
  lwd = 2)
  )

## extreme smoke days treshold
lines(qc$date,
      qc$seasonal + qc$trend + threshold,
      col = 'blue')

## extreme smoke events line
with(qc[
  qc$extreme_smoke_day == 1,],
  segments(
    date,
    seasonal + trend + remainder,
    date,
    seasonal + trend,
    col = 'red')
  )

}
