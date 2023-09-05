do_plot_5th <- function(
    mrg_dat,
    yarea = c(0,100),
    gcc_title = "Sydney",
    gcc = "1GSYD"
    
){
  # png("figures_and_tables/fig_pm25_nepm.png", res = 250, height = 3840, width = 2160)
  
  pdf("manuscript/01_figures/fig_pm25_5th.pdf", width = 8.3, height = 11.7)
  
  # Set the font to Cambria
  par(family = "Arial Narrow")
  
  # Sample data preparation
  pm25 = mrg_dat
  
  # Filtering based on gcc values
  syd <- pm25[gcc == "1GSYD"]
  mel <- pm25[gcc == "2GMEL"]
  bri <- pm25[gcc == "3GBRI"]
  ade <- pm25[gcc == "4GADE"]
  per <- pm25[gcc == "5GPER"]
  hob <- pm25[gcc == "6GHOB"]
  dar <- pm25[gcc == "7GDAR"]
  act <- pm25[gcc == "8ACTE"]
  
  # GCC and title arrays
  gccs <- c("syd",
            "mel",
            "bri",
            "ade",
            "per",
            "hob",
            "dar",
            "act")
  titles <- c("Sydney",
              "Melbourne",
              "Brisbane",
              "Adelaide",
              "Perth",
              "Hobart",
              "Darwin",
              "Australian Capital Territory")
  
  # Set up the plotting area
  par(mfrow = c(length(gccs) + 1, 1),
      mar = c(0.4, 5, 0.4, 0.4), # c(bottom, left, top, right)
      mgp = c(2.5, 1, 0), # c(axis_title, axis_labels, axis_line)
      las = 1,
      cex.axis = 0.8,
      cex.lab = 1)
  
  # Add vertical grid lines manually for each year
  years <- seq(from = as.Date("2001-01-01"), to = as.Date("2020-12-31"), by = "year")
  
  # Iterate through GCCs
  for (i in 1:length(gccs)) {
    gcc <- gccs[i]
    title_text <- titles[i]
    
    pm25 <- get(gcc)
    
    # Calculate year range
    year_range <- range(as.Date(pm25$date, format="%Y-%m-%d"))
    
    # Remove rows with NA or infinite values
    pm25 <- pm25[!is.na(pm25$date) & !is.na(pm25$pm25_pred),]
    
    # Define xlim and ylim
    xlim_range <- c(as.numeric(as.Date("2001-01-01")), as.numeric(as.Date("2020-12-31")))
    ylim_range <- c(0, max(pm25$pm25_pred, na.rm = TRUE))
    
    plot(0, type = "n", xlim = xlim_range, ylim = ylim_range, 
         xaxt = "n", ylab = "", xlab = "", main = "", yaxs = "i", xaxs = "i")
    
    # Manually set the plotting region to remove extra space
    usr <- par("usr")
    par(usr = c(as.numeric(as.Date("2001-01-01")), as.numeric(as.Date("2020-12-31")), usr[3], usr[4]))
    
    if (i == length(gccs)) {
      axis(1, at = as.numeric(seq(from = as.Date("2001-01-01"), to = as.Date("2020-12-31"), by = "year")), 
           labels = format(seq(from = as.Date("2001-01-01"), to = as.Date("2020-12-31"), by = "year"), "%Y"))
    }
    
    # Add vertical grid lines for each year
    years <- seq(from = min(pm25$date), to = max(pm25$date), by = "year")
    abline(v = as.numeric(years), col = "lightgray", lty = "dotted")
    
    # First, draw the #CCCC99 segments
    segments(as.numeric(pm25$date[pm25$pm25_pred <= 25]), 
             0, 
             as.numeric(pm25$date[pm25$pm25_pred <= 25]), 
             pm25$pm25_pred[pm25$pm25_pred <= 25], 
             col = "#CCCC99", 
             lwd = 1)
    
    # lines(as.numeric(pm25$date), pm25$cf, col = "#3399FF", lwd = 1.5)
    
    # Second, draw the red segments only for days with pm25_pred > 13.77264
    segments(as.numeric(pm25$date[pm25$pm25_pred > 13.77264]), 
             13.77264,  # Start the segment at this threshold
             as.numeric(pm25$date[pm25$pm25_pred > 13.77264]), 
             pm25$pm25_pred[pm25$pm25_pred > 13.77264], 
             col = "red", 
             lwd = 1)
    
    # Add a forestgreen segment from pm25$cf to 13.77264 only for days where pm25$pm25_pred > 13.77264
    segments(as.numeric(pm25$date[pm25$pm25_pred > 13.77264]), 
             pm25$cf[pm25$pm25_pred > 13.77264],  # Start the segment at pm25$cf
             as.numeric(pm25$date[pm25$pm25_pred > 13.77264]), 
             rep(13.77264, length(pm25$date[pm25$pm25_pred > 13.77264])),  # End the segment at 13.77264
             col = "#3399FF", 
             lwd = 1)
    
    
    title(title_text, adj = 0.99, line = -1.5)
    
    # Add a box around the plot
    box(col = "black", lwd = 1)
    
    if (i == 4) {
      mean_point <- mean(par("usr")[3:4])
      text(par("usr")[1]-400, mean_point, labels = "PM₂.₅ (µg/m³)", xpd = TRUE, srt = 90, cex = 1.8)  
    }
  }
  # Legend plot
  plot(0, 0, type = 'n', xaxt = 'n', yaxt = 'n', xlab = '', ylab = '', bty = 'n', frame.plot=FALSE)
  legend(x = -1.1, y = 0.8, 
         legend = c("Estimated daily PM₂.₅ concentration", "5th percentile of highest predicted PM₂.₅ daily concentration", "Difference between 5th percentile and counterfactual concentrations (seasonal plus trend)"), 
         col = c("#CCCC99", "red", "#3399FF"), 
         lty = c(1, 1, 1, 2, 2),
         lwd = 1.5, 
         cex = 1.2, 
         bty = 'n')
  
  
  dev.off()
}

