do_tab_rr1 <- function(
    rr_dt
){
  # Convert the date column to year
  rr_dt[, year := format(as.Date(date), "%Y")]
  
  # Group by year and calculate sum for each column
  rr <- rr_dt[ , lapply(.SD, sum, na.rm = TRUE),
                .SDcols = -1,
                by = year]
  
  # Function to determine if a year is a leap year
  is_leap_year <- function(year) {
    return((year %% 4 == 0 & year %% 100 != 0) | (year %% 400 == 0))
  }
  
  # Create a 'leap' variable, 1 if leap year, 0 otherwise
  rr[, leap := ifelse(is_leap_year(as.integer(year)), 1, 0)]
  
  # Divide each sum by the number of days in the year based on 'leap' variable
  rr <- rr[, lapply(.SD, function(x) ifelse(leap == 1, x / 366, x / 365)), 
           .SDcols = -c("year", "leap"), 
           by = year]
  
  
  # Define the city names and corresponding column gcc
  cities <- c("Sydney", "Melbourne", "Brisbane", "Adelaide", "Perth", "Hobart", "Darwin", "Canberra")
  gcc <- c("1GSYD", "2GMEL", "3GBRI", "4GADE", "5GPER", "6GHOB", "7GDAR", "8ACTE")
  
  # For each city, create a new column that combines the '_rr', '_lb', and '_ub' columns
  for (i in 1:length(cities)) {
    city <- cities[i]
    prefix <- gcc[i]
    
    rr_col <- paste0(prefix, "_rr")
    lb_col <- paste0(prefix, "_lb")
    ub_col <- paste0(prefix, "_ub")
    
    # Round the values to 4 decimal places before pasting
    rr[, (city) := paste0(round(get(rr_col), 4), " (", round(get(lb_col), 4), ", ", round(get(ub_col), 4), ")")]
  }
  
  # Define the columns to remove
  columns_to_remove <- unlist(lapply(gcc, function(x) paste0(x, c("_rr", "_lb", "_ub"))))
  
  # Remove the original columns, except 'year'
  rr[, (columns_to_remove) := NULL]
  
  return(rr)
}