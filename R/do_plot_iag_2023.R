do_plot_iag_2023 <- function(
    sim_obs,
    pm25
){
## gcc and date
qc4 <- dat_cf[date >= as.Date("2002-11-01") & date <= as.Date("2003-04-30") & gcc_code16 == "1GSYD"]
  
## set a treshold 2 standard deviations from the remainder days
qc4[, threshold := sd(remainder) * 2]

# # Create the "avoidable" variable and assign pm25_pred values
qc4[, avoidable := ifelse(
  pm25_pred > (cf) &
    pm25_pred < (cf + threshold),
  pm25_pred, NA)]

## set a binary variable, yes or no extreme smoke day based on cf + treshold
qc4$extreme_smoke_day <- ifelse(
  qc4$pm25_pred >= (qc4$cf + qc4$threshold), 1, 0)

qc4$extreme_smoke <- ifelse(
  qc4$extreme_smoke_day == 1, qc4$remainder, NA)

# # Create the "avoidable" variable and assign pm25_pred values
qc4[, good := ifelse(
  pm25_pred < (cf),
  pm25_pred, NA)]

## terrible days
qc4[, terrible := ifelse(
  pm25_pred >= (cf + threshold),
  pm25_pred, NA)]

# colours
col1 <- do.call(rgb,c(as.list(col2rgb("forestgreen")),alpha=255/2.5,max=255))
col2 <- do.call(rgb,c(as.list(col2rgb("red")),alpha=255/2.5,max=255))

# margins
par(
  mar=c(2, 4, 3, 2),
  mgp=c(3,1,0),
  oma = c(0, 0, 0, 4),
  las=1,
  cex.axis=0.9,
  cex.lab=1,
  family ="Cambria")

## start the plot
with(qc4, plot(
  date,
  pm25_pred,
  type = "p",
  bty = "l",
  pch = 20,
  ylim = c(0,50),
  ylab = "PM₂.₅ (µg/m³)",
  xlab = ""
  )
  )
# Add x-axis label
mtext("Sydney - Nov 2002 to Apr 2003", side = 3, line = -3, outer = TRUE)

# Create treshold polygon
polygon_x <- c(qc4$date, rev(qc4$date))
polygon_y <- c(qc4$cf, rev(qc4$cf + qc4$threshold))

polygon(polygon_x, polygon_y, col = col2, border = NA)

# Create cf polygon 
polygon_x <- c(qc4$date, rev(qc4$date))
polygon_y <- c(qc4$cf, rep(0, length(qc4$cf)))

polygon(polygon_x, polygon_y, col = col1, border = NA)


## Plot the avoidable variable
with(qc4, points(
  date,
  avoidable,
  pch = 20,
  col = col3)
)

## Plot the good variable
with(qc4, points(
  date,
  good,
  pch = 20,
  col = "forestgreen")
)

## Plot the extreme
with(qc4, points(
  date,
  terrible,
  pch = 20,
  col = "red")
)

# ## cf line
# with(qc4, lines(
#   date,
#   cf,
#   lwd = 1,
#   col = col2)
#   )
# 
# ## extreme smoke days treshold
# lines(qc4$date,
#       qc4$cf + qc4$threshold,
#       lwd = 1,
#       col = col2)

## extreme smoke events line
with(qc4[
  qc4$extreme_smoke_day == 1,],
  segments(
    date,
    cf + remainder,
    date,
    cf,
    lwd = 2,
    col = 'red')
  )

## Adding the legend
legend(par("usr")[2]-20, par("usr")[4], bty = "n", xpd = NA,
       c("Extreme", "Avoidable", "CF"),
       col = c("red", "darkred", "forestgreen"),
       pch = 20)

}
