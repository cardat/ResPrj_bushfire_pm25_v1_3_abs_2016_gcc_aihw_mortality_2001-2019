do_calc_an_all_ages_sens_sum <- function(
    an_all_ages_sens
){
  # Create a copy of an_all_ages_dt
  an_sum <- copy(an_all_ages_sens)
  
  # Convert the date column to year
  an_sum[, year := format(as.Date(date), "%Y")]
  
  # Group by year and calculate sum for each column
  an_sens <- an_sum[ , lapply(.SD, sum, na.rm = TRUE),
                .SDcols = -1,
                by = year]
  
  # Define the city names and corresponding column gcc
  cities <- c("Sydney", "Melbourne", "Brisbane", "Adelaide", "Perth", "Hobart", "Darwin", "Canberra", "All GCCs")
  gcc <- c("1GSYD", "2GMEL", "3GBRI", "4GADE", "5GPER", "6GHOB", "7GDAR", "8ACTE", "All GCCs")
  
  # Initialize the 'All GCCs' columns
  an_sens[, c("All GCCs_rr", "All GCCs_lb", "All GCCs_ub") := list(0, 0, 0)]
  
  # For each suffix, create a new 'Australia' column that is the sum of all corresponding columns
  for (suffix in c("_rr", "_lb", "_ub")) {
    cols_to_sum <- paste0(gcc, suffix)
    
    # Sum the values, round to 2 decimal places, and assign to the new 'Australia' column
    an_sens[, paste0("All GCCs", suffix) := round(rowSums(.SD, na.rm = TRUE), 2), .SDcols = cols_to_sum]
  }
  
  # Create the 'All years' row
  all_years_row <- an_sens[, lapply(.SD, sum, na.rm = TRUE), .SDcols = -1]
  all_years_row[, year := "All years"]
  
  # Add the 'All years' row to the data.table
  an_sens <- rbind(an_sens, all_years_row)
  
  
  # For each city, create a new column that combines the '_rr', '_lb', and '_ub' columns
  for (i in 1:length(cities)) {
    city <- cities[i]
    prefix <- gcc[i]
    
    rr_col <- paste0(prefix, "_rr")
    lb_col <- paste0(prefix, "_lb")
    ub_col <- paste0(prefix, "_ub")
    
    # Round the values to 2 decimal places before pasting
    an_sens[, (city) := paste0(round(get(rr_col), 0), " (", round(get(lb_col), 0), " — ", round(get(ub_col), 0), ")")]
  }
  
  # Define the columns to remove
  columns_to_remove <- unlist(lapply(gcc, function(x) paste0(x, c("_rr", "_lb", "_ub"))))
  
  # Remove the original columns, except 'year'
  an_sens[, (columns_to_remove) := NULL]
  
  return(an_sens)
}
