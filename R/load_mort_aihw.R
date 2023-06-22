load_mort_aihw <- function(
    dir
){
  dly_gcc <- read.csv(file = file.path(config$indir_aihw, config$dly_all_gcc))
  
  dly_gcc <- as.data.table(dly_gcc)
  obs <- dly_gcc[, .(all = sum(deaths[age == "All ages"]),
                     all_0_64 = sum(deaths[age == "Under 65 years"]),
                     all_65plus = sum(deaths[age == "65+ years"])),
                 by = .(date, gcc)]
  
  # Remove prefix "GCC" from the gcc column - standardise with pm25 rds file
  obs[, gcc := gsub("^GCC", "", gcc)]
  
  # Convert date column to Date type
  obs[, date := as.Date(date)]
  
  # Create new columns year, month, and day
  obs[, c("year", "month", "day") := .(year(date), month(date), day(date))]
  
  # Create new column all_sum_gccs_dly
  obs[, all_sum_gccs_dly := sum(all), by = .(date)]
  
  # Create new column doy (day of the year)
  obs[, doy := yday(date)]
  
  # Create new column dow (day of the week)
  obs[, dow := substr(weekdays(date), 1, 3)]
  
  # Filter out rows with year equal to 2000 & 2001
  obs <- obs[year != 2000 & year != 2001]
  
  # Calculate the group number for every three-year period
  obs[, group := ((year - 2002) %/% 3) + 1]
  
  # Calculate the average of 'all' for each doy, group, and gcc combination
  obs[, avg_doy_all := round(mean(all), 3), by = .(doy, group, gcc)]
  
  obs[, avg_doy_all_0_64 := round(mean(all_0_64), 3), by = .(doy, group, gcc)]
  
  obs[, avg_doy_all_65plus := round(mean(all_65plus), 3), by = .(doy, group, gcc)]
  
  obs[, group := NULL]
  
  # Reorder the columns
  obs <- obs[, c(
    "gcc",
    "date", 
    "year", 
    "month", 
    "day", 
    "doy", 
    "dow", 
    "all", 
    "all_0_64", 
    "all_65plus",
    "avg_doy_all",
    "avg_doy_all_0_64",
    "avg_doy_all_65plus"), 
    with = FALSE]
  

  return(obs)
}