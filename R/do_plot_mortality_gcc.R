do_plot_mortality_gcc <- function(
    sim_obs
){
  png("figures_and_tables/fig_mortality.png", res = 250, height = 3840, width = 2160)
  
  syd <- sim_obs[gcc == "1GSYD"]
  mel <- sim_obs[gcc == "2GMEL"]
  bri <- sim_obs[gcc == "3GBRI"]
  ade <- sim_obs[gcc == "4GADE"]
  per <- sim_obs[gcc == "5GPER"]
  hob <- sim_obs[gcc == "6GHOB"]
  dar <- sim_obs[gcc == "7GDAR"]
  act <- sim_obs[gcc == "8ACTE"]
  
  gccs <- c("act", "ade", "bri", "dar", "hob", "mel", "per", "syd")
  titles <- c("Australian Capital Territory", "Adelaide", "Brisbane", 
              "Darwin", "Hobart", "Melbourne", "Perth", "Sydney")
  
  par(mfrow = c(length(gccs), 1),
      mar = c(0.2, 2, 0.2, 0.2),
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
    
    if (i == length(gccs)) {
      ## last plot ##   
      plot(avg_doy_all ~ doy, dat, pch = 19, col = grey(0.8), cex = 0.5,
           ylab = "Daily deaths", xlab = "Day of the year", main = "")
      
      title(title_text, adj = 0.99, line = -1.5)
      
      lines(1:366, tapply(dat$avg_doy_all, dat$doy, mean), lwd = 1.5, col = 4)
    } else {
      plot(avg_doy_all ~ doy, dat, xaxt = "n", pch = 19, col = grey(0.8), cex = 0.5)
      
      title(title_text, adj = 0.99, line = -1.5)
      
      lines(1:366, tapply(dat$avg_doy_all, dat$doy, mean), lwd = 1.5, col = 4)
    }
    # Add horizontal and vertical grid lines
    grid(nx = NULL, ny = NULL, lty = "dashed", col = "grey")
    
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