do_plot_mortality_all <- function(
  sim_obs
){
par(mar = c(5, 4, 3, 1), mgp = c(2.5, 1, 0), las = 1, cex.axis = 0.8, cex.lab = 1)

# Create the plot for the whole sample (sim_obs)
plot(all_sum_gccs_dly ~ doy, sim_obs, pch = 19, col = grey(0.8), cex = 0.5,
     ylab = "Daily deaths", xlab = "Day of the year", main = "Observed Mortality all GCCs (2001-2019)")

# Add a line plot for the whole sample
lines(1:366, tapply(sim_obs$all_sum_gccs_dly, sim_obs$doy, mean), lwd = 1.5, col = 4)

}