
library(targets)
library(data.table)
## QC BushfireSmoke 1.3v vs DEEPER pm2.5
tar_load(mrg_mort_pm25)
#### hack by ivan ####
foo=mrg_mort_pm25

foo2 <- foo[gcc == "7GDAR"]
names(foo2)


png("figures_and_tables/fig_exceptional_explain.png", res = 250, height = 3000, width = 3840)
par(mfrow = c(4,1), mar = c(5, 5, 4, 2) + 0.1)

myPlot <- function(
    foo2 = foo[gcc == "7GDAR"],
    idx = as.Date("2002-01-01"): as.Date("2002-12-31"),
    pctile = quantile(foo2$pm25_pred, 0.95)
){
  with(foo2[date %in% idx], {
    plot(date, pm25_pred, pch = 16, cex = 0.6, 
         ylab = expression("PM"[2.5] * " μg/m" ^ 3)) # Y-axis label
    lines(date, trend + seasonal, col = 'green')
    with(subset(foo2, pm25_pred > pctile), segments(date, trend + seasonal, date, 
                                                    trend + seasonal + remainder,
                                                    col = 'red'))
  })
}

#### build up three panels ####
par(mfrow = c(1,1), mar = c(5, 5, 4, 2) + 0.1)
idx = as.Date("2002-01-01"): as.Date("2002-12-31")
foo2 = foo[gcc == "7GDAR"]

pm <- foo2$pm25_pred
top_5pct_threshold <- quantile(pm, 0.95)

myPlot(
  foo2 = foo2,
  idx = idx,
       pctile = quantile(foo2$pm25_pred, 0.95)
  )
abline(top_5pct_threshold, 0)
title(main = expression("PM"[2.5] * " Concentrations in Darwin 2002"))

with(foo2[pm25_pred > top_5pct_threshold], 
     segments(date, trend + seasonal, date, pm25_pred, col = 'red'))

with(foo2[pm25_pred <= top_5pct_threshold & pm25_pred > trend + seasonal], 
     segments(date, trend + seasonal, date, pm25_pred, col = 'darkgrey'))
# Adding a legend
legend("topright", # Position of the legend
       legend = c("Most Extreme Days (top 5%)", 
                  expression("Exceptional PM"[2.5]), 
                  "Expected Concentrations (seasonal + trend)", 
                  expression("Estimated PM"[2.5])),
       col = c("red", "darkgrey", "green", "black"),
       lty = c(1, 1, 1, NA), # Line types (NA for points)
       pch = c(NA, NA, -1, 16), # Point types (-1 for lines, 16 for points)
       bty = "o", # No box around the legend
       text.col = "black")


dev.off()










with(foo2[date %in% idx & pm25_pred < top_5pct_threshold], 
     plot(date, pm25_pred, ylim = c(0,27), pch = 16, cex = 0.6))
title("Sensitivity analysis")
abline(top_5pct_threshold, 0)
with(foo2[date %in% idx], lines(date, trend + seasonal, col = 'green'))
# with(foo2[date %in% idx & pm25_pred > top_5pct_threshold], segments(date, trend + seasonal, date, 
#                                                         trend + seasonal + remainder,
#                                                         col = 'red'))
with(foo2[date %in% idx & (pm25_pred < top_5pct_threshold 
                           & pm25_pred > trend + seasonal)],
     segments(date, trend + seasonal, date, 
              trend + seasonal + remainder,
              col = 'darkgrey'))


# 
# plot(density(exceptional_pm),xlim = c(0,50))
# 0.05 * length(foo2$date)
# 
# foo2[1,]
dev.off()
#### old work ####
# load deeper
pm25_dp <- readRDS("C:/Users/291828H/OneDrive - Curtin/projects/SURE_STANDARD_STAGING/Project_Exposures_Staging/heat_parkland_ozone/data_derived_by_geo/yearly_pm25_pm10_no2_by_ppn.rds")

# load pts_geoprocess from parkland pipeline

# check if we can use as spatial object

# merge spatial with pm25_dp


decline <- subset(sim_obs, gcc == "3GBRI" & avg_doy_all < 20)

sum(an_all_ages_dt[an_all_ages_dt$date >= as.Date("2016-05-01") & an_all_ages_dt$date <= as.Date("2016-05-31"), "1GSYD_rr"], na.rm = TRUE)
sum(an_all_ages_dt[an_all_ages_dt$date >= as.Date("2016-05-01") & an_all_ages_dt$date <= as.Date("2016-05-31"), "1GSYD_lb"], na.rm = TRUE)
sum(an_all_ages_dt[an_all_ages_dt$date >= as.Date("2016-05-01") & an_all_ages_dt$date <= as.Date("2016-05-31"), "1GSYD_ub"], na.rm = TRUE)

summary(calc_rr$`1GSYD_rr`)
mean(calc_rr[, "1GSYD_rr"], na.rm = TRUE)
sum(an_all_ages_dt[, "2GMEL_rr"], na.rm = TRUE)


sum(calc_an_all_ages[, "1GSYD_rr"], na.rm = TRUE)


perth <- mrg_mort_pm25[gcc == "5GPER" & !is.na(good)]






# Required package
library(ggplot2)

# Filter data
filtered_data <- mrg_mort_pm25[mrg_mort_pm25$gcc == "1GSYD" & 
                                 mrg_mort_pm25$date >= as.Date("2016-05-01") & 
                                 mrg_mort_pm25$date <= as.Date("2016-05-31"),]


# Plot
plot(x = filtered_data$date, 
     y = filtered_data$pm25_pred, 
     type = "l", 
     main = "PM2.5 Prediction for 1GSYD in May 2016",
     xlab = "Date", 
     ylab = "PM2.5 Prediction")


## sum the attributable number to check the total number of deaths
# get column names with "_rr"
rr_cols <- grep("_rr", names(calc_an_all_ages_sum), value = TRUE)
# Exclude the last row from the calculation
sum_2001_2020 <- calc_an_all_ages_sum[-nrow(calc_an_all_ages_sum), lapply(.SD, sum), .SDcols = rr_cols]
# Sum all values in all columns
total_sum <- sum(sum_2001_2020, na.rm = TRUE)


# get column names with "_lb"
lb_cols <- grep("_lb", names(calc_an_all_ages_sum), value = TRUE)

# sum the columns for years 2019 and 2020
# Exclude the last row from the calculation
sum_2001_2020_lb <- calc_an_all_ages_sum[-nrow(calc_an_all_ages_sum), lapply(.SD, sum), .SDcols = lb_cols]

# Sum all values in all columns
total_sum_lb <- sum(sum_2001_2020_lb, na.rm = TRUE)


# get column names with "_lb"
ub_cols <- grep("_ub", names(calc_an_all_ages_sum), value = TRUE)

# sum the columns for years 2019 and 2020
# Exclude the last row from the calculation
sum_2001_2020_ub <- calc_an_all_ages_sum[-nrow(calc_an_all_ages_sum), lapply(.SD, sum), .SDcols = ub_cols]

# Sum all values in all columns
total_sum_ub <- sum(sum_2001_2020_ub, na.rm = TRUE)



par(
  mfrow = c(1, 1),
  mar = c(0.2, 2, 0.2, 0.2),
  mgp = c(2.5, 1, 0),
  oma = c(4, 2, 2, 2),
  las = 1,
  cex.axis = 0.8,
  cex.lab = 1
)

# tar_load(dat_mort_aihw_simulated_2020)
syd_mort <- dat_mort_aihw_simulated_2020[
  date >= as.Date("2008-11-01") & 
    date <= as.Date("2009-04-30") & 
    gcc == "1GSYD"]

# Create the variable doy_half
syd_mort$doy_half <- as.numeric(syd_mort$date - as.Date("2008-11-01")) + 1

# Subset the avg_doy_all values for the specified period
syd_mort$avg_doy_all_half <- syd_mort$avg_doy_all[syd_mort$doy_half >= 1 & syd_mort$doy_half <= 181]

# Plot using doy_half
plot(
  avg_doy_all ~ doy_half, syd_mort,
  pch = 19, col = grey(0.8), cex = 0.5, xaxt = "n",
  ylab = "Daily deaths", xlab = "", main = "",
  type = "h"
)

lines(
  1:181, tapply(syd_mort$avg_doy_all_half, syd_mort$doy_half, mean),
  lwd = 1.5, col = 4
)

# Add horizontal and vertical grid lines
grid(nx = NULL, ny = NULL, lty = "dashed", col = "grey")

# Add x-axis label
mtext("Sydney - Nov 2002 to Apr 2003", side = 3, line = 0.2, outer = TRUE)
mtext("Day of the Year", side = 1, line = 2, outer = TRUE)

# Calculate the mean point
mean_point <- mean(par("usr")[3:4])
# Insert y-axis label
# text(
#   par("usr")[1] - 20, mean_point, labels = "Daily deaths",
#   xpd = NA, srt = 90, cex = 1.8
# )

# tar_load(dat_cf)








# qc negative an
# Brisbane 2020
hrapie <- 1.0123
unit_change <- 10
beta <- log(hrapie)/unit_change

mean_delta_year = -0.232327181
rr <- exp(beta * mean_delta_year)

rr = 0.9997160
paf = 0.9997160-1/0.9997160
#paf = -0.0005680807
#deaths in brisbane 2020= 15696.99
an = -0.0005680807 * 15696.99
# [1] -8.917157






# qc
# Specify the target month and year
m <- 12
y <- 2019:2020

# Filter the data to include only the rows matching the target GCC, month, and year range
qc <- merged_data[month == m & year %in% y]


## EDA

# cf on qc3
qc3[!is.na(seasonal) & !is.na(trend), cf := seasonal + trend]
# negatives to cf
qc3$pm25_pred[qc3$pm25_pred < 0] <- qc3$cf[qc3$pm25_pred < 0]

set_counterfactual$pop <- as.numeric(set_counterfactual$pop)

# avg gcc
  qc3 <- set_counterfactual[,.(
    pm25_pred = mean(pm25_pred, na.rm = T),
    remainder = mean(remainder, na.rm = T),
    seasonal = mean(seasonal, na.rm = T),
    trend = mean(trend, na.rm = T),
    pop = mean(pop, na.rm = T),
    cf = mean(cf, na.rm = T),
    delta = mean(delta, na.rm = T)
    ), 
    by = c("gcc_code16", "date")]


set_counterfactual[is.na(pm25_pred), .N]


do_eda <- FALSE
if(do_eda){
  tar_load(dat_convert_and_extract_rasters)
  dat_convert_and_extract_rasters
  dat <- readRDS("data_derived/2009.rds")
  dat
  
  tar_load(dat_sa1_shp)
  qc2 <- merge(dat_sa1_shp, qc, by = c("sa1_7dig16", "gcc_code16"))
  unique(qc2$gcc_code16)
  qc2 <- qc2[qc2$gcc_code16 == "1GSYD",]
  ## NB this takes a long time to draw all the polygons
  plot(qc2["pm25_pred"], border =  T)# NA)
  
  # TODO make a good looking plot From top to bottom: seasonal, trend, remainder, full PM2.5.
  plot(qc2[c("seasonal", "trend", "remainder", "pm25_pred")], border = NA)
  # legend is missing?
  plot(qc2["seasonal"], border = NA)
  plot(qc2["trend"], border = NA)
  plot(qc2["remainder"], border = NA)
  
  qc3 <- set_counterfactual[,.(
    pm25_pred = mean(pm25_pred, na.rm = T),
    remainder = mean(remainder, na.rm = T),
    seasonal = mean(seasonal, na.rm = T),
    trend = mean(trend, na.rm = T)
    ), 
    by = c("gcc_code16", "date")]
  
  threshold <- sd(qc3$remainder) * 2
  qc3$extreme_smoke_day <- ifelse(qc3$pm25_pred >= (qc3$seasonal + qc3$trend + threshold), 1, 0)
  # setDF(qc3)
  qc3$extreme_smoke <- ifelse(qc3$extreme_smoke_day == 1, qc3$remainder, NA)
  
  with(qc3, plot(date, pm25_pred, type = 'b', ylim = c(0,100)))
  with(qc3, lines(date, seasonal + trend, lwd = 2))
  lines(qc3$date, qc3$seasonal + qc3$trend + threshold, col = 'blue')
  with(qc3[qc3$extreme_smoke_day == 1,], segments(date, seasonal + trend + remainder, date, seasonal + trend, col = 'red'))
  dev.off()
  
}



## qc one month one gcc
qc4 <- set_counterfactual[date >= as.Date("2020-12-01") & date <= as.Date("2020-12-31") & gcc_code16 == "5GPER"]

qc <- qc4[,.(
  pm25_pred = mean(pm25_pred, na.rm = T),
  remainder = mean(remainder, na.rm = T),
  seasonal = mean(seasonal, na.rm = T),
  trend = mean(trend, na.rm = T)
), 
by = c("gcc_code16", "date")]
qc$day <- format(qc$date, "%d")
qc$day <- as.numeric(qc$day)

threshold <- sd(qc$remainder) * 2
qc$extreme_smoke_day <- ifelse(qc$pm25_pred >= (qc$seasonal + qc$trend + threshold), 1, 0)
qc$extreme_smoke <- ifelse(qc$extreme_smoke_day == 1, qc$remainder, NA)

with(qc, plot(day, pm25_pred, type = 'b', ylim = c(0,15)))
with(qc, lines(day, seasonal + trend, lwd = 2))
lines(qc$day, qc$seasonal + qc$trend + threshold, col = 'blue')

with(qc[qc$extreme_smoke_day == 1,], segments(day, seasonal + trend + remainder, day, seasonal + trend, col = 'red'))
dev.off()
