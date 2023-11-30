do_plot_mortality_gcc <- function(
    sim_obs
){
  # png("figures_and_tables/fig_mortality.png", res = 250, height = 3840, width = 2160)
  pdf("figures_and_tables/figS2_mortality.pdf", width = 8.3, height = 11.7)
  
  # sim_obs=dat_mort_aihw_simulated_2020
  
  # Remove data for December 2019
  sim_obs <- sim_obs[!(format(sim_obs$date, "%Y-%m") == "2019-12")]
  
  # par(family = "Arial Narrow")
  
  syd <- sim_obs[gcc == "1GSYD"]
  mel <- sim_obs[gcc == "2GMEL"]
  bri <- sim_obs[gcc == "3GBRI"]
  ade <- sim_obs[gcc == "4GADE"]
  per <- sim_obs[gcc == "5GPER"]
  hob <- sim_obs[gcc == "6GHOB"]
  dar <- sim_obs[gcc == "7GDAR"]
  act <- sim_obs[gcc == "8ACTE"]
  
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
  
  
  par(mfrow = c(length(gccs), 1),
      mar = c(0.4, 2, 0.4, 0.2), # c(bottom, left, top, right)
      mgp = c(2.5, 1, 0),
      oma = c(4, 4, 0, 0),
      las = 1,
      cex.axis = 0.8,
      cex.lab = 1)
  
  
  ## iterate through gccs ##
  for (i in 1:length(gccs)) {
    gcc <- gccs[i]
    title_text <- titles[i]
    
    dat <- get(gcc)
    
    if (i == 1) 
      {
      ## first plot ##
      plot(avg_doy_all ~ doy, dat, pch = 20, col = grey(0.8), cex = 0.5,
           ylab = "", xlab = "", main = "",
           yaxs = "i", xaxs = "i", yaxt = "n", xaxt = "n",
           ylim = c(0, max(dat$avg_doy_all, na.rm = TRUE)))
      axis(2, at = c(0, seq(20, max(dat$avg_doy_all, na.rm = TRUE), by = 20)), 
           las = 1)
    }
    else if
    (i == length(gccs)) 
      {
      ## last plot ##   
      plot(avg_doy_all ~ doy, dat, pch = 20, col = grey(0.8), cex = 0.5,
           ylab = "Daily deaths", xlab = "Day of the year", main = "",
           yaxs = "i", xaxs = "i")
      } 
    else 
      {
      plot(avg_doy_all ~ doy, dat, xaxt = "n", pch = 20, col = grey(0.8), 
           cex = 0.5, yaxs = "i", xaxs = "i")
      }

    # Add horizontal and vertical grid lines
    grid(nx = NULL, ny = NULL, lty = "dashed", col = "grey")
    
    # Add title over grid lines
    title(title_text, adj = 0.99, line = -1.5)
    
    # Add lines
    lines(1:366, tapply(dat$avg_doy_all, dat$doy, mean), lwd = 1.5, col = 4)
    
    # Add a box around the plot
    box(col = "black", lwd = 1)
    
    ## add x legend
    mtext("Day of the Year", side = 1, line = 2, outer = TRUE)
    
    ## add y legend
    if (i == 4) {
      ## Calculate the mean point
      mean_point <- mean(par("usr")[3:4]) 
      ## Insert text
      text(par("usr")[1] - 20, mean_point, labels = "Daily deaths", xpd = NA, srt = 90, cex = 1.8)  
    }
  }
  dev.off()
 }