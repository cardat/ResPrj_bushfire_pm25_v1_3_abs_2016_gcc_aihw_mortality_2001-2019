do_plot_an <- function(
    an_all_ages_dt,
    mrg_dat
){

# png("figures_and_tables/fig_an_100.png", res = 250, height = 1080, width = 1920)

pdf("figures_and_tables/fig_an_100.pdf", width = 16.889 , height = 9.5)

par(
  family = "Arial Narrow",
  mar = c(2, 4, 1, 1),
  mgp = c(3, 1, 0),
  oma = c(0, 0, 0, 0),
  las = 1,
  cex.axis = 0.9,
  cex.lab = 1
)

an_all_ages_dt[, year := year(date)]  # if date is of class Date, use lubridate package

# Initialize the sum_data data frame
sum_data <- data.frame(
  year = unique(an_all_ages_dt$year),
  rr = numeric(length(unique(an_all_ages_dt$year))),
  lb = numeric(length(unique(an_all_ages_dt$year))),
  ub = numeric(length(unique(an_all_ages_dt$year))))

gccs <- unique(mrg_dat$gcc)  # Obtain unique values from the gcc column

# Iterate over the dates
for (i in sum_data$year) {
  # Initialize the sum variables for each date
  rr_sum <- 0
  lb_sum <- 0
  ub_sum <- 0

  # Iterate over the GCCs
  for (gcc in gccs) {
    # Get the column names for the current GCC
    rr_col <- paste0(gcc, "_rr")
    lb_col <- paste0(gcc, "_lb")
    ub_col <- paste0(gcc, "_ub")

    # Add the values to the sum variables
    rr_sum <- rr_sum + sum(an_all_ages_dt[year == i, get(rr_col)], na.rm = TRUE)
    lb_sum <- lb_sum + sum(an_all_ages_dt[year == i, get(lb_col)], na.rm = TRUE)
    ub_sum <- ub_sum + sum(an_all_ages_dt[year == i, get(ub_col)], na.rm = TRUE)
  }

  # Assign the sum values to the corresponding row in sum_data
  sum_data$rr[sum_data$year == i] <- rr_sum
  sum_data$lb[sum_data$year == i] <- lb_sum
  sum_data$ub[sum_data$year == i] <- ub_sum
}

# Plotting
plot(sum_data$year, sum_data$rr, type = "l", col = "red",
     xlab = "Year", ylab = "Deaths", main = "",
     xlim = range(an_all_ages_dt$year), ylim = c(0, max(sum_data$ub, na.rm = TRUE)),
     xaxt = "n")

# Add shaded area for LB and UB
polygon(c(sum_data$year, rev(sum_data$year)), c(sum_data$lb, rev(sum_data$ub)),
        col = adjustcolor("red", alpha.f = 0.2),
        border = NA)

# Add yearly ticks on x-axis
axis(1, at = sum_data$year, labels = sum_data$year)

# Add legend
legend("topleft",
       legend = c("Estimated number of premature deaths associated with PM₂.₅ exposure ", "95% CI"),
       lty = c(1, 1),
       col = c("red", adjustcolor("red", alpha.f = 0.2)),
       lwd = c(1, 5),
       bty = "n")

dev.off()
}