do_plot_an_all_ages <- function(
    an_all_ages_dt, 
    an_all_ages_sens, 
    mrg_dat
){
  # png("figures_and_tables/fig_an_100_sens.png", res = 250, height = 1080, width = 1920)

  pdf("figures_and_tables/fig_an_95_sens.pdf", width = 16.889 , height = 9.5)
  
  
  par(
    family = "Calibri",
    mar = c(2, 4, 1, 1),
    mgp = c(3, 1, 0),
    oma = c(0, 0, 0, 0),
    las = 1,
    cex.axis = 0.9,
    cex.lab = 1
  )
  
  # For an_all_ages_dt
  an_all_ages_dt[, date := as.IDate(date)]
  an_all_ages_dt[, year := year(date)]
  an_all_ages_dt[, date := NULL]
  an_all_ages_dt <- an_all_ages_dt[, lapply(.SD, sum, na.rm = TRUE), by = year]
  an_all_ages_dt[, rr := rowSums(.SD[, grepl("_rr", names(.SD)), with = FALSE], na.rm = TRUE)]
  an_all_ages_dt[, lb := rowSums(.SD[, grepl("_lb", names(.SD)), with = FALSE], na.rm = TRUE)]
  an_all_ages_dt[, ub := rowSums(.SD[, grepl("_ub", names(.SD)), with = FALSE], na.rm = TRUE)]
  
  # For an_all_ages_sens
  an_all_ages_sens[, date := as.IDate(date)]
  an_all_ages_sens[, year := year(date)]
  an_all_ages_sens[, date := NULL]
  an_all_ages_sens <- an_all_ages_sens[, lapply(.SD, sum, na.rm = TRUE), by = year]
  an_all_ages_sens[, rr := rowSums(.SD[, grepl("_rr", names(.SD)), with = FALSE], na.rm = TRUE)]
  an_all_ages_sens[, lb := rowSums(.SD[, grepl("_lb", names(.SD)), with = FALSE], na.rm = TRUE)]
  an_all_ages_sens[, ub := rowSums(.SD[, grepl("_ub", names(.SD)), with = FALSE], na.rm = TRUE)]
  
  # Plotting
  plot(an_all_ages_dt$year, an_all_ages_dt$rr, type = "l", col = "red",
       xlab = "Year", ylab = "Deaths", main = "",
       xlim = range(an_all_ages_dt$year), ylim = c(0, max(an_all_ages_dt$ub, an_all_ages_sens$ub, na.rm = TRUE)),
       xaxt = "n")
  
  # Add shaded area for LB and UB for an_all_ages_dt
  polygon(c(an_all_ages_dt$year, rev(an_all_ages_dt$year)), c(an_all_ages_dt$lb, rev(an_all_ages_dt$ub)),
          col = adjustcolor("red", alpha.f = 0.2),
          border = NA)
  
  # Add second line and polygon for an_all_ages_sens
  lines(an_all_ages_sens$year, an_all_ages_sens$rr, col = "blue")
  polygon(c(an_all_ages_sens$year, rev(an_all_ages_sens$year)), c(an_all_ages_sens$lb, rev(an_all_ages_sens$ub)),
          col = adjustcolor("blue", alpha.f = 0.2),
          border = NA)
  
  # Add yearly ticks on x-axis
  axis(1, at = an_all_ages_dt$year, labels = an_all_ages_dt$year)
  
  # Add legend
  legend("topleft",
         legend = c("Estimated number of premature deaths associated with PM₂.₅ exposure ", 
                    "95% CI",
                    "Sensitivity Analysis (95th percentile)",
                    "95% CI"),
         lty = c(1, 1, 1, 1),
         col = c("red", adjustcolor("red", alpha.f = 0.2), "blue", adjustcolor("blue", alpha.f = 0.2)),
         lwd = c(1, 5, 1, 5),
         bty = "n")
  dev.off()
}




