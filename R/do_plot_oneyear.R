# #### hack by ivan and modified by lucas ####

do_plot_oneyear <- function(
    mrg_dat,
    idx = as.Date("2002-01-01"): as.Date("2002-12-31"),
    pct = 0.95,
    city = "7GDAR",
    city_name = "Darwin", #for the plot's title
    year = "(2002)" #for the plot's title
){
  # Set the plot parameters
  png("figures_and_tables/fig_exceptional_explain.png", res = 250, height = 4500, width = 3000)
  par(mfrow = c(1,1), mar = c(5, 5, 4, 2) + 0.1)

  # Define the subset of data and the time index
  
  foo2 = mrg_dat[gcc == city]
  pctile = quantile(foo2$pm25_pred, pct)

  # Create the plot
  with(foo2[date %in% idx], {
    plot(date, pm25_pred, pch = 16, cex = 0.6,
         ylab = expression("PM"[2.5] * " μg/m" ^ 3)) # Y-axis label
    lines(date, trend + seasonal, col = 'green')
    with(subset(foo2, pm25_pred > pctile), segments(date, trend + seasonal, date,
                                                    trend + seasonal + remainder,
                                                    col = 'red'))
  })

  # Additional plot elements
  abline(quantile(foo2$pm25_pred, 0.95), 0, col = "blue")
  abline(1.9993976, 0, col = "purple")
  
  # Dynamic title based on idx (date) and city
  title(main = bquote("Estimated PM"[2.5] * " Concentrations in" ~ .(city_name) ~ .(year)))
  
  with(foo2[pm25_pred > pctile],
       segments(date, trend + seasonal, date, pm25_pred, col = 'red'))

  with(foo2[pm25_pred <= pctile & pm25_pred > trend + seasonal],
       segments(date, trend + seasonal, date, pm25_pred, col = 'darkgrey'))

  # Add the legend
  legend("topleft",
         legend = c(expression("Most Extreme Exceptional PM"[2.5] * " (top 5%)"),
                    expression("Exceptional PM"[2.5] * " (excluding top 5%)"),
                    "Expected Concentrations (seasonal + trend)",
                    "Top 5% threshold",
                    expression("Minimum PM"[2.5] * " in this GCCSA (historical series)"),
                    expression("Estimated PM"[2.5])
         ),
         col = c("red", "darkgrey", "green", "blue", "purple", "black"),
         lty = c(1, 1, 1, 1, 1, NA),
         pch = c(NA, NA, -1, NA, NA, 16),
         bty = "o",
         text.col = "black")

  dev.off()

}