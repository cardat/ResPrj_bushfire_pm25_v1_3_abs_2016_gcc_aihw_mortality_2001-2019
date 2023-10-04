do_plot_pm25_nepm <- function(
    pm25,
    yarea = c(0,100),
    gcc_title = "Sydney",
    gcc = "1GSYD"
    
){
  # png("figures_and_tables/fig_pm25_nepm.png", res = 250, height = 3840, width = 2160)
  # Sample data preparation
  # pm25 = mrg_mort_pm25
  
  # Define font mappings
  pdf("manuscript/01_figures/fig_pm25.pdf", width = 8.3, height = 11.7)

  par(family = "Arial Narrow")
  
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
    ylim_range <- c(0, 100)
    
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
    segments(as.numeric(pm25$date[pm25$pm25_pred <= 15]), 
             0, 
             as.numeric(pm25$date[pm25$pm25_pred <= 15]), 
             pm25$pm25_pred[pm25$pm25_pred <= 15], 
             col = "grey", 
             lwd = 1)
    
    lines(as.numeric(pm25$date), pm25$cf, col = "dimgrey", lwd = 1.5)
    
    # Second, draw the red segments
    segments(as.numeric(pm25$date[pm25$pm25_pred > 15]), 
             0, 
             as.numeric(pm25$date[pm25$pm25_pred > 15]), 
             pm25$pm25_pred[pm25$pm25_pred > 15], 
             col = "red", 
             lwd = 1)
    
    title(title_text, adj = 0.99, line = -1.5)
    
    # Add text for pm25_pred values > 100
    high_pm25 <- pm25[pm25$pm25_pred > 100, ]
    
    # Sort the data frame by date
    high_pm25 <- high_pm25[order(as.Date(high_pm25$date)), ]
    
    high_pm25$group <- cumsum(c(1, diff(as.Date(high_pm25$date)) > 7))
    
    # Get the highest pm25_pred value within each group for gcc == "8ACTE"
    highest_8ACTE <- high_pm25[gcc == "8ACTE", .SD[which.max(pm25_pred)], by = group][, group := NULL]
    
    # Update the original high_pm25 data table
    high_pm25 <- high_pm25[!gcc == "8ACTE"][, group := NULL]
    
    high <- rbind(highest_8ACTE, high_pm25)
    
    if (nrow(high) > 0) {
      # Calculate the width of the text
      widths <- strwidth(sprintf("%.1f", high$pm25_pred)) * 0.7
      
      # Draw semi-transparent rectangles behind the text
      rect(xleft = as.numeric(high$date) - widths / 2, 
           ybottom = rep(70, nrow(high)) - 4, 
           xright = as.numeric(high$date) + widths / 2, 
           ytop = rep(70, nrow(high)) + 4, 
           col = adjustcolor("black", alpha.f = 0.5), 
           border = NA)
      
      # Draw text on top of the rectangles
      text(x = as.numeric(high$date), 
           y = rep(70, nrow(high)), 
           labels = as.character(round(high$pm25_pred)), 
           cex = 0.7, 
           col = "white")
    }
    
    
    # NEPM WHO lines
    abline(h = 20, col = "darkorange", lty = 2, lwd = 1)
    
    # For the black line with dashed line type
    abline(h = 25, col = "black", lty = 2, lwd = 1)
    
    # For the black line with dashed line type
    abline(h = 15, col = "#3399FF", lty = 2, lwd = 1)
    
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
         legend = c("Estimated Daily PM₂.₅ Average Concentration ", 
                    "Background PM₂.₅", 
                    "Days where PM₂.₅ estimations are higher than WHO AQG target",
                    "2021 World Health Organization (WHO) Global air quality guidelines (AQG)",
                    "2015 Australian National Environment Protection (Ambient Air Quality) Measure (NEPM)", 
                    "2025 Australian National Environment Protection (Ambient Air Quality) Measure (NEPM)" 
                    ), 
         col = c("grey", 
                 "dimgrey", 
                 "red",
                 "#3399FF",
                 "black",
                 "darkorange" 
                 ), 
         lty = c(1, 1, 1, 2, 2, 2),
         lwd = 1.5, 
         cex = 1.2, 
         bty = 'n')
  dev.off()
}

