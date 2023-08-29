do_plot_pm25_nepm <- function(
    pm25,
    yarea = c(0,100),
    gcc_title = "Sydney",
    gcc = "1GSYD"
    
){
  # png("figures_and_tables/fig_pm25_nepm.png", res = 250, height = 3840, width = 2160)
  
  pdf("figures_and_tables/fig_pm25_nepm.pdf", width = 9.5, height = 16.889)
  
  # Set the font to Cambria
  par(family = "Cambria")
  
  # Sample data preparation
  # pm25 = mrg_mort_pm25
  
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
      mar = c(0.2, 6, 0.2, 0.2), # c(bottom, left, top, right)
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
    
    if (i == length(gccs)) {
      plot(0, type = "n", xlim = range(as.numeric(pm25$date)), ylim = c(0, max(pm25$pm25_pred, na.rm = TRUE)), 
           ylab = "", xlab = "", xaxt = "n", main = "")
      axis(1, at = as.numeric(seq(from = min(pm25$date), to = max(pm25$date), by = "year")), 
           labels = format(seq(from = min(pm25$date), to = max(pm25$date), by = "year"), "%Y"))
    } else {
      plot(0, type = "n", xlim = range(as.numeric(pm25$date)), ylim = c(0, max(pm25$pm25_pred, na.rm = TRUE)), 
           xaxt = "n", ylab = "", xlab = "", main = "")
    }
    
    # First, draw the #CCCC99 segments
    segments(as.numeric(pm25$date[pm25$pm25_pred <= 25]), 
             0, 
             as.numeric(pm25$date[pm25$pm25_pred <= 25]), 
             pm25$pm25_pred[pm25$pm25_pred <= 25], 
             col = "#CCCC99", 
             lwd = 1)
    
    lines(as.numeric(pm25$date), pm25$cf, col = "#3399FF", lwd = 1.5)
    
    # Second, draw the red segments
    segments(as.numeric(pm25$date[pm25$pm25_pred > 25]), 
             0, 
             as.numeric(pm25$date[pm25$pm25_pred > 25]), 
             pm25$pm25_pred[pm25$pm25_pred > 25], 
             col = "red", 
             lwd = 1)
    
    title(title_text, adj = 0.99, line = -1.5)
    
    # NEPM lines
    # For the forestgreen line with solid line type
    abline(h = 20, col = "forestgreen", lty = 2, lwd = 1.5)
    
    # For the black line with dashed line type
    abline(h = 25, col = "black", lty = 2, lwd = 1.5)
    
    # Add vertical grid lines for each year
    years <- seq(from = min(pm25$date), to = max(pm25$date), by = "year")
    abline(v = as.numeric(years), col = "lightgray", lty = "dotted")
    
    if (i == 4) {
      mean_point <- mean(par("usr")[3:4])
      text(par("usr")[1]-500, mean_point, labels = "PM₂.₅ (µg/m³)", xpd = TRUE, srt = 90, cex = 1.8)  
    }
  }
  # Legend plot
  plot(0, 0, type = 'n', xaxt = 'n', yaxt = 'n', xlab = '', ylab = '', bty = 'n', frame.plot=FALSE)
  legend(x = -1.1, y = 0.8, 
         legend = c("PM₂.₅", "Background PM₂.₅", "PM₂.₅ > NEPM 2023", "NEPM 2023", "NEPM 2025"), 
         col = c("#CCCC99", "#3399FF", "red", "black", "forestgreen"), 
         lty = c(1, 1, 1, 2, 2),
         lwd = 1.5, 
         cex = 1.2, 
         bty = 'n', 
         horiz = TRUE)
  
  
  dev.off()
}

