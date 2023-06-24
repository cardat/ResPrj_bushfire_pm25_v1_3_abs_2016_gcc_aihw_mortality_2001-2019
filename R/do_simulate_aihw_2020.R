# Convert the 'date' column to a Date object if it's not already in that format
obs$date <- as.Date(obs$date)

# Find the last date in the 'date' column
last_date <- max(obs$date)

# Generate a sequence of dates from December 28, 2019, to December 31, 2020
extended_dates <- seq(from = as.Date("2019-12-28"), to = as.Date("2020-12-31"), by = "day")

# Repeat each extended date eight times
extended_dates_rep <- rep(extended_dates, each = 8)

# Create a new data frame with extended dates
extended_obs <- data.frame(
  gcc = c(obs$gcc, rep(obs$gcc[(nrow(obs) - 7):nrow(obs)], length(extended_dates))),
  date = c(obs$date, extended_dates_rep)
)

# Extract year, month, day, doy, and dow from the 'date' column of extended_obs
extended_obs$year <- format(extended_obs$date, "%Y")
extended_obs$month <- format(extended_obs$date, "%m")
extended_obs$day <- format(extended_obs$date, "%d")
extended_obs$doy <- format(extended_obs$date, "%j")
extended_obs$dow <- format(extended_obs$date, "%a")

# Copy to extended_obs, and NA for extended dates
extended_obs$all <- c(obs$all, rep(NA, length(extended_dates_rep)))
extended_obs$all_0_64 <- c(obs$all_0_64, rep(NA, length(extended_dates_rep)))
extended_obs$all_65plus <- c(obs$all_65plus, rep(NA, length(extended_dates_rep)))

# Avg doy variables
# Merge the two data.tables based on the common columns 'gcc' and 'date'
extended_obs <- as.data.table(extended_obs)

extended_obs <- merge(extended_obs, 
                      obs[, c("gcc", 
                              "date", 
                              "avg_doy_all", 
                              "avg_doy_all_0_64", 
                              "avg_doy_all_65plus")],
                      by = c("date", "gcc"), all.x = TRUE)

# Sort the data by date in ascending order
setkey(extended_obs, date)

extended_obs[, c("year", 
                 "month", 
                 "day", 
                 "doy") := lapply(.SD, as.numeric), 
             .SDcols = c("year", 
                         "month", 
                         "day", 
                         "doy")]

# Create a separate data.table for the values from 2019
values_2019 <- extended_obs[year == 2019, .(gcc, doy, avg_doy_all, avg_doy_all_0_64, avg_doy_all_65plus)]

# Subset the rows of extended_obs for the year 2020
extended_obs_2020 <- extended_obs[year == 2020]

# Join the data.tables based on gcc, doy, and year conditions
extended_obs_2020[values_2019, on = .(gcc, doy), 
                  `:=` (avg_doy_all = i.avg_doy_all,
                        avg_doy_all_0_64 = i.avg_doy_all_0_64,
                        avg_doy_all_65plus = i.avg_doy_all_65plus)]

# Assign the modified rows back to extended_obs
extended_obs[year == 2020] <- extended_obs_2020


# qc
# Specify the target month and year
s <- "1GSYD"
m <- 12
y <- 2019:2020

# Filter the data to include only the rows matching the target GCC, month, and year range
filtered_obs <- extended_obs[gcc == s & month == m & year %in% y]

