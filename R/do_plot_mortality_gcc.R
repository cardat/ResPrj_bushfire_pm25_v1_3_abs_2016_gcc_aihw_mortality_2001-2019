do_plot_mortality_gcc <- function(
    obs
){
  syd <- obs[gcc == "1GSYD"]
  mel <- obs[gcc == "2GMEL"]
  bri <- obs[gcc == "3GBRI"]
  ade <- obs[gcc == "4GADE"]
  per <- obs[gcc == "5GPER"]
  hob <- obs[gcc == "6GHOB"]
  dar <- obs[gcc == "7GDAR"]
  act <- obs[gcc == "8ACTE"]
  
  gccs <- c("act", "ade", "bri", "dar", "hob", "mel", "per", "syd")
  titles <- c("Australian Capital Territory", "Adelaide", "Brisbane", "Darwin", "Hobart", "Melbourne", "Perth", "Sydney")
  
  par(mfrow = c(length(gccs), 1),
      mar = c(0.2, 4, 0.2, 0.2),
      mgp = c(2.5, 1, 0),
      las = 1,
      cex.axis = 0.8,
      cex.lab = 1)
  
  for (i in 1:length(gccs)) {
    gcc <- gccs[i]
    title_text <- titles[i]
    
    dat <- get(gcc)
    
    if (i == length(gccs)) {
      par(mar = c(3.5, 4, 0.2, 0.2))  # Increase bottom margin for x-axis label
      
      plot(avg_doy_all ~ doy, dat, pch = 19, col = grey(0.8), cex = 0.5,
           ylab = "Daily deaths", xlab = "Day of the year", main = "")
      
      title(title_text, adj = 0.99, line = -1.5)
      
      lines(1:366, tapply(dat$avg_doy_all, dat$doy, mean), lwd = 1.5, col = 4)
    } else {
      plot(avg_doy_all ~ doy, dat, xaxt = "n", pch = 19, col = grey(0.8), cex = 0.5,
           ylab = "Daily deaths", main = "")
      
      title(title_text, adj = 0.99, line = -1.5)
      
      lines(1:366, tapply(dat$avg_doy_all, dat$doy, mean), lwd = 1.5, col = 4)
    }
    # Add horizontal and vertical grid lines
    grid(nx = NULL, ny = NULL, lty = "dashed", col = "grey")
  }
}