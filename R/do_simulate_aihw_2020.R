#' Simulated AIHW 2020 mortality daily averages by day of the year
#' 
#' This function simulates 2020 daily all cause mortality averages based on 2019 
#' values which are the daily means estimated from three year chunks - 2019, 
#' 2018 and 2017.
#' 
#' @param obs 
#'
#' @return sim_obs
#' @export
#'
#' @examples

do_simulate_aihw_2020 <- function(
    obs
){
  
# Define the list of "gcc" values
gcc_list <- c("1GSYD", 
              "2GMEL", 
              "3GBRI", 
              "4GADE", 
              "5GPER", 
              "6GHOB", 
              "7GDAR", 
              "8ACTE")

# Create an empty list to store the results for each "gcc"
merged_list <- list()

# Create a temporary column for the previous year's date
# prev_date <- function(year, month, day) {
#   if (month == 2 && day == 29) {
#     leap_year <- ifelse(year %% 4 == 0 && (year %% 100 != 0 || year %% 400 == 0), TRUE, FALSE)
#     if (leap_year) {
#       return(as.Date(paste(year - 1, "-02-28", sep = "")))
#     } else {
#       return(as.Date(paste(year - 1, "-02-29", sep = "")))
#     }
#   } else {
#     return(as.Date(paste(year - 1, month, day, sep = "-")))
#   }
# }

prev_date <- function(year, month, day) {
  date <- as.Date(paste(year, month, day, sep = "-"))
  return(date - years(1))
}

# Iterate over each "gcc" value
for (gcc_value in gcc_list) {
  # Subset the "obs" data for the current "gcc" value
  gcc_obs <- obs[gcc == gcc_value]
  
  # Create the date sequence from 2019-12-28 for each "gcc" value
  d <- seq(from = as.Date("2019-12-28"), 
           to = as.Date("2020-12-31"), 
           by = "day")
  
  # Create the new data table for the current "gcc" value
  new <- data.table(
    gcc = rep(gcc_value, length(d)),
    date = d,
    year = year(d),
    month = sprintf("%02d", month(d)),
    day = as.integer(format(d, "%d")),
    doy = yday(d),
    dow = format(d, "%a"),
    all = rep(NA_real_, length(d)),
    all_0_64 = rep(NA_real_, length(d)),
    all_65plus = rep(NA_real_, length(d)),
    avg_doy_all = rep(NA_real_, length(d)),
    avg_doy_all_0_64 = rep(NA_real_, length(d)),
    avg_doy_all_65plus = rep(NA_real_, length(d))
  )
  
  # Merge the "gcc" observations with the new data
  gcc_expanded <- rbind(gcc_obs, new, fill = TRUE)
  
  # Calculate the previous date values for the current "gcc" value
  gcc_expanded[, prev_date := prev_date(year, as.integer(month), as.integer(day))]
  gcc_expanded[, prev_value := gcc_expanded[match(prev_date, date), avg_doy_all, nomatch = NA]]
  gcc_expanded[, prev_value_0_64 := gcc_expanded[match(prev_date, date), avg_doy_all_0_64, nomatch = NA]]
  gcc_expanded[, prev_value_65plus := gcc_expanded[match(prev_date, date), avg_doy_all_65plus, nomatch = NA]]
  
  # Order the data by date
  gcc_expanded <- gcc_expanded[order(date)]
  
  # Remove duplicated dates (second ones)
  gcc_expanded <- gcc_expanded[!duplicated(date, fromLast = TRUE)]
  
  # Assign previous values
  gcc_expanded[is.na(avg_doy_all), avg_doy_all := prev_value]
  gcc_expanded[is.na(avg_doy_all_0_64), avg_doy_all_0_64 := prev_value_0_64]
  gcc_expanded[is.na(avg_doy_all_65plus), avg_doy_all_65plus := prev_value_65plus]
  
  # Remove temporary columns
  gcc_expanded[, c("prev_date", 
                   "prev_value", 
                   "prev_value_0_64", 
                   "prev_value_65plus") := NULL]
  
  # Add the merged data to the list
  merged_list[[gcc_value]] <- gcc_expanded
}

# Merge all the results into a single data table
sim_obs <- rbindlist(merged_list)

# Sort the merged data by date
sim_obs <- sim_obs[order(date)]

return(sim_obs)
}
