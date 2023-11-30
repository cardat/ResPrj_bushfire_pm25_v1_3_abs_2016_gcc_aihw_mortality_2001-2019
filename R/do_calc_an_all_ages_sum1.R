do_calc_an_all_ages_sum1 <- function(
    an_all_ages_dt1
){
  # Create a copy of an_all_ages_dt1
  an_sum <- copy(an_all_ages_dt1)
  
  # Convert the date column to year
  an_sum[, year := format(as.Date(date), "%Y")]

  # Group by year and calculate sum for each column
  an <- an_sum[ , lapply(.SD, sum, na.rm = TRUE),
                .SDcols = -1,
                by = year]
  
  # Define the city names and corresponding column gcc
  cities <- c("Sydney", "Melbourne", "Brisbane", "Adelaide", "Perth", "Hobart", "Darwin", "Canberra", "All GCCs")
  gcc <- c("1GSYD", "2GMEL", "3GBRI", "4GADE", "5GPER", "6GHOB", "7GDAR", "8ACTE", "All GCCs")
  
  # Initialize the 'All GCCs' columns
  an[, c("All GCCs_rr", "All GCCs_lb", "All GCCs_ub") := list(0, 0, 0)]
  
  # For each suffix, create a new 'Australia' column that is the sum of all corresponding columns
  for (suffix in c("_rr", "_lb", "_ub")) {
    cols_to_sum <- paste0(gcc, suffix)
    
    # Sum the values, round to 2 decimal places, and assign to the new 'Australia' column
    an[, paste0("All GCCs", suffix) := round(rowSums(.SD, na.rm = TRUE), 2), .SDcols = cols_to_sum]
  }
  # Create the 'All years' row
  all_years_row <- an[, lapply(.SD, sum, na.rm = TRUE), .SDcols = -1]
  all_years_row[, year := "All years"]
  
  # Add the 'All years' row to the data.table
  an <- rbind(an, all_years_row)
  
  return(an)
}
