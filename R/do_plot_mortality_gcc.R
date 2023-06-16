do_plot_mortality_gcc <- function(
    obs
){

# mar = c(bottom, left, top, right)
# Set up the plot layout
par(mfrow = c(4, 2), 
    mar = c(2, 4, 3, 1), 
    mgp = c(2.5, 1, 0), 
    las = 1, 
    cex.axis = 0.8, 
    cex.lab = 1)

# Subset the data for each gcc value
syd <- obs[gcc == "1GSYD"]
mel <- obs[gcc == "2GMEL"]
bri <- obs[gcc == "3GBRI"]
ade <- obs[gcc == "4GADE"]
per <- obs[gcc == "5GPER"]
hob <- obs[gcc == "6GHOB"]
dar <- obs[gcc == "7GDAR"]
act <- obs[gcc == "8ACTE"]

# Create a list of gcc names and titles
gccs <- c("act", "ade", "bri", "dar", "hob", "mel", "per", "syd")
titles <- c("Australian Capital Territory", "Adelaide", "Brisbane", "Darwin", "Hobart", "Melbourne", "Perth", "Sydney")

# Iterate over the gcc values and create the plots
for (i in 1:length(gccs)) {
  gcc <- gccs[i]
  title_text <- titles[i]
  
  # Subset the data for the current gcc value
  dat <- get(gcc)
  
  # Create the plot
  plot(all ~ doy, dat, pch = 19, col = grey(0.8), cex = 0.5,
       ylab = "Daily deaths", xlab = "Day of the year", main = title_text)
  
  # Add a line plot
  lines(1:366, tapply(dat$all, dat$doy, mean), lwd = 1.5, col = 4)
  
}
# Set the overall plot title
par(mfrow = c(1, 1)) # Reset the plot layout to one plot
title("Observed Mortality (2001-2019)", line = 1.5)
}