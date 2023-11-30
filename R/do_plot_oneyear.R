do_plot_oneyear <- function(
    mrg_dat
){

#### hack by ivan and modified by lucas ####
foo=mrg_dat

png("figures_and_tables/fig_exceptional_explain.png", res = 250, height = 4500, width = 3000)
par(mfrow = c(1,1), mar = c(5, 5, 4, 2) + 0.1)

myPlot <- function(
    foo2 = foo[gcc == "7GDAR"],
    idx = as.Date("2002-01-01"): as.Date("2002-12-31"),
    pctile = quantile(foo2$pm25_pred, 0.95)
){
  with(foo2[date %in% idx], {
    plot(date, pm25_pred, pch = 16, cex = 0.6, 
         ylab = expression("PM"[2.5] * " μg/m" ^ 3)) # Y-axis label
    lines(date, trend + seasonal, col = 'green')
    with(subset(foo2, pm25_pred > pctile), segments(date, trend + seasonal, date, 
                                                    trend + seasonal + remainder,
                                                    col = 'red'))
  })
}
# par(mfrow = c(4,1), mar = c(5, 5, 4, 2) + 0.1)
idx = as.Date("2002-01-01"): as.Date("2002-12-31")
foo2 = foo[gcc == "7GDAR"]

pm <- foo2$pm25_pred
top_5pct_threshold <- quantile(pm, 0.95)

myPlot(
  foo2 = foo2,
  idx = idx,
  pctile = quantile(foo2$pm25_pred, 0.95)
)
abline(top_5pct_threshold, 0, col = "blue")
abline(1.9993976, 0, col = "purple")
title(main = expression("Estimated PM"[2.5] * " Concentrations in Darwin 2002"))

with(foo2[pm25_pred > top_5pct_threshold], 
     segments(date, trend + seasonal, date, pm25_pred, col = 'red'))

with(foo2[pm25_pred <= top_5pct_threshold & pm25_pred > trend + seasonal], 
     segments(date, trend + seasonal, date, pm25_pred, col = 'darkgrey'))

legend("topleft", 
       legend = c(expression("Most Extreme Exceptional PM"[2.5] * " (top 5%)"), 
                  expression("Exceptional PM"[2.5] * " (excluding top 5%)"), 
                  "Expected Concentrations (seasonal + trend)", 
                  "Top 5% threshold",
                  expression("Minimum PM"[2.5] * " in this GCCSA (historical series)"),
                  expression("Estimated PM"[2.5])
       ), # Add the label for the red line
       col = c("red", "darkgrey", "green", "blue", "purple", "black"), # Add the color for the new label
       lty = c(1, 1, 1, 1, 1, NA), # Line types (1 for the new label, NA for points)
       pch = c(NA, NA, -1, NA, NA, 16), # Point types (-1 for lines, 16 for points, NA for the new label)
       bty = "o", # Box type around the legend
       text.col = "black")

dev.off()
}