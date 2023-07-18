do_plot_pm25_gccs <- function(
    pm25,
    p
){
  png("figures_and_tables/fig_pm25_ts_gcc.png", res = 250, height = 3840, width = 3840)
  
  layout(matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9), nrow = 3, byrow = TRUE))
  
  par(
    family = "Cambria",
    mar = c(2, 4, 1, 1),
    mgp = c(3, 1, 0),
    oma = c(0, 0, 0, 8),
    las = 1,
    cex.axis = 0.9,
    cex.lab = 1
  )
  
  do_plot_extreme_days(
    pm25, gcc_title = "Sydney", gcc = "1GSYD", yarea = c(0, 90))
  do_plot_extreme_days(
    pm25,gcc_title = "Melbourne", gcc = "2GMEL", yarea = c(0, 80))
  do_plot_extreme_days(
    pm25,gcc_title = "Brisbane", gcc = "3GBRI", yarea = c(0, 80))
  do_plot_extreme_days(
    pm25,gcc_title = "Adelaide", gcc = "4GADE", yarea = c(0, 40))
  do_plot_extreme_days(
    pm25,gcc_title = "Perth", gcc = "5GPER", yarea = c(0, 50))
  do_plot_extreme_days(
    pm25,gcc_title = "Hobart", gcc = "6GHOB", yarea = c(0, 60))
  do_plot_extreme_days(
    pm25,gcc_title = "Darwin", gcc = "7GDAR", yarea = c(0, 50))
  do_plot_extreme_days(
    pm25,gcc_title = "Canberra", gcc = "8ACTE", yarea = c(0, 500))
  
  # Dummy plot for the legend
  plot(0, type = "n", axes = FALSE, xlab = "", ylab = "")

  # Manually define the position of the legend
  legend("center",
         legend = c("Good", "Moderate", "Unhealthy(sensitive groups)", 
                    "Unhealthy", "Very Unhealthy", "Hazardous", "Extreme"), 
         pch = c(3, 20, 19, 17, 18, 15, 8), 
         col = c("#5BC5FF", "#3A9F35", "#CFEB41", 
                 "#EBC200", "#E06900", "#B10025", "#4F0018"), 
         pt.bg = "white",
         bty = "n",
         bg = "white",
         cex = 2.5
  )
  dev.off()
}

