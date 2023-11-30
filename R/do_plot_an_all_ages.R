do_plot_an_all_ages <- function(
    an_all_ages_dt, 
    an_all_ages_sens,
    an_all_ages_dt1,
    mrg_dat
){
  # png("figures_and_tables/fig_an_100_sens.png", res = 250, height = 1080, width = 1920)

  # pdf("manuscript/01_figures/fig3_an.pdf", width = 11.7 , height = 8.3)
  # 
  # 
  # par(
  #   # family = "Arial Narrow",
  #   mar = c(2, 4, 1, 1),
  #   mgp = c(3, 1, 0),
  #   oma = c(0, 0, 0, 0),
  #   las = 1,
  #   cex.axis = 0.9,
  #   cex.lab = 1
  # )
  # 
 
  # 
  # # Existing plotting code
  # plot(an_all_ages_dt$year, an_all_ages_dt$rr, type = "l", col = "red", xlab = "Year", ylab = "Deaths", main = "",
  #      xlim = range(an_all_ages_dt$year, an_all_ages_dt1$year), 
  #      ylim = c(0, max(an_all_ages_dt$ub, an_all_ages_dt1$ub, an_all_ages_sens$ub, na.rm = TRUE)),
  #      xaxt = "n", yaxs = "i", xaxs = "r")
  # 
  # polygon(c(an_all_ages_dt$year, rev(an_all_ages_dt$year)), c(an_all_ages_dt$lb, rev(an_all_ages_dt$ub)), col = adjustcolor("red", alpha.f = 0.2), border = NA)
  # lines(an_all_ages_sens$year, an_all_ages_sens$rr, col = "blue")
  # polygon(c(an_all_ages_sens$year, rev(an_all_ages_sens$year)), c(an_all_ages_sens$lb, rev(an_all_ages_sens$ub)), col = adjustcolor("blue", alpha.f = 0.2), border = NA)
  # 
  # # New code for an_all_ages_dt1
  # lines(an_all_ages_dt1$year, an_all_ages_dt1$rr, col = "green") # Use a different color for an_all_ages_dt1
  # polygon(c(an_all_ages_dt1$year, rev(an_all_ages_dt1$year)), c(an_all_ages_dt1$lb, rev(an_all_ages_dt1$ub)), col = adjustcolor("green", alpha.f = 0.2), border = NA)
  # 
  # axis(1, at = an_all_ages_dt$year, labels = an_all_ages_dt$year)
  # 
  # # Update legend
  # legend("topleft",
  #        legend = c(expression("Estimated number of deaths associated with exceptional" ~ PM[2.5] ~ "exposure"),
  #                   expression("Deaths excluding most extreme days (" * 95^th * " percentile)"),
  #                   expression("All deaths associated with" ~ PM[2.5] ~ "exposure")
  #                   ),
  #        lty = c(1, 1, 1, 1, 1, 1),
  #        col = c("red", adjustcolor("red", alpha.f = 0.2), 
  #                "blue", adjustcolor("blue", alpha.f = 0.2), 
  #                "green", adjustcolor("green", alpha.f = 0.2)),
  #        lwd = c(1, 5, 1, 5, 1, 5),
  #        bty = "n")
  # 
  # dev.off()
  
  pdf("manuscript/01_figures/fig3_an.pdf", width = 11.7 , height = 8.3)
  
  par(
    # family = "Arial Narrow",
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
  
  # For an_all_ages_dt1
  an_all_ages_dt1[, date := as.IDate(date)]
  an_all_ages_dt1[, year := year(date)]
  an_all_ages_dt1[, date := NULL]
  an_all_ages_dt1 <- an_all_ages_dt1[, lapply(.SD, sum, na.rm = TRUE), by = year]
  an_all_ages_dt1[, rr := rowSums(.SD[, grepl("_rr", names(.SD)), with = FALSE], na.rm = TRUE)]
  an_all_ages_dt1[, lb := rowSums(.SD[, grepl("_lb", names(.SD)), with = FALSE], na.rm = TRUE)]
  an_all_ages_dt1[, ub := rowSums(.SD[, grepl("_ub", names(.SD)), with = FALSE], na.rm = TRUE)]
  
  # For an_all_ages_sens
  an_all_ages_sens[, date := as.IDate(date)]
  an_all_ages_sens[, year := year(date)]
  an_all_ages_sens[, date := NULL]
  an_all_ages_sens <- an_all_ages_sens[, lapply(.SD, sum, na.rm = TRUE), by = year]
  an_all_ages_sens[, rr := rowSums(.SD[, grepl("_rr", names(.SD)), with = FALSE], na.rm = TRUE)]
  an_all_ages_sens[, lb := rowSums(.SD[, grepl("_lb", names(.SD)), with = FALSE], na.rm = TRUE)]
  an_all_ages_sens[, ub := rowSums(.SD[, grepl("_ub", names(.SD)), with = FALSE], na.rm = TRUE)]
  
  # Plotting
  plot(an_all_ages_dt1$year, an_all_ages_dt1$rr, type = "l", col = "red", xlab = "Year", ylab = "Deaths", main = "",
       xlim = range(an_all_ages_dt$year, an_all_ages_dt1$year), 
       ylim = c(0, max(an_all_ages_dt$ub, an_all_ages_dt1$ub, an_all_ages_sens$ub, na.rm = TRUE)),
       xaxt = "n", yaxs = "i", xaxs = "r")
  
  # an_all_ages_dt1 (Red)
  polygon(c(an_all_ages_dt1$year, rev(an_all_ages_dt1$year)), c(an_all_ages_dt1$lb, rev(an_all_ages_dt1$ub)), col = adjustcolor("red", alpha.f = 0.2), border = NA)
  
  # an_all_ages_dt (Blue)
  lines(an_all_ages_dt$year, an_all_ages_dt$rr, col = "blue")
  polygon(c(an_all_ages_dt$year, rev(an_all_ages_dt$year)), c(an_all_ages_dt$lb, rev(an_all_ages_dt$ub)), col = adjustcolor("blue", alpha.f = 0.2), border = NA)
  
  # an_all_ages_sens (Green)
  lines(an_all_ages_sens$year, an_all_ages_sens$rr, col = "green")
  polygon(c(an_all_ages_sens$year, rev(an_all_ages_sens$year)), c(an_all_ages_sens$lb, rev(an_all_ages_sens$ub)), col = adjustcolor("green", alpha.f = 0.2), border = NA)
  
  axis(1, at = an_all_ages_dt$year, labels = an_all_ages_dt$year)
  
  # Updated legend
  legend("topleft",
         legend = c(expression("All deaths associated with" ~ PM[2.5] ~ "exposure"), "95% CI",
                    expression("Deaths associated with exceptional" ~ PM[2.5] ~ "exposure"), "95% CI",
                    expression("Deaths in a scenario with reductions in extreme days (top 5%)"), "95% CI"),
         lty = c(1, 1, 1, 1, 1, 1),
         col = c("red", adjustcolor("red", alpha.f = 0.2), 
                 "blue", adjustcolor("blue", alpha.f = 0.2), 
                 "green", adjustcolor("green", alpha.f = 0.2)),
         lwd = c(1, 5, 1, 5, 1, 5),
         bty = "n")
  
  dev.off()
  
}




