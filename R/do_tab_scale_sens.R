do_tab_scale_sens <- function(
    an_sens,
    mrg_dat
){
  subset_pop <- unique(mrg_dat[, .(pop), by = gcc])
  # Add a dummy variable for pivot
  subset_pop[, dummy := 1]
  
  # Pivot subset_pop to wide format
  subset_pop_pivot <- dcast(subset_pop, dummy ~ gcc, value.var = "pop")
  
  # Remove the dummy variable
  subset_pop_pivot[, dummy := NULL]
  
  subset_pop_pivot[, `All GCCs` := rowSums(.SD, na.rm = TRUE)]
  
  # Copy the 'an' dataframe to 'scaled'
  scaled_sens <- copy(an_sens)
  
  # Get the city codes
  city_codes <- c("1GSYD", "2GMEL", "3GBRI", "4GADE", "5GPER", "6GHOB", "7GDAR", "8ACTE", "All GCCs")
  
  # Loop through the city codes and divide appropriate columns from 'scaled_sens' by population from 'subset_pop_pivot'
  for (city in city_codes) {
    suffixes <- c("_rr", "_lb", "_ub")  # define the suffixes
    for (suffix in suffixes) {
      column_name <- paste0(city, suffix)  # create the column name
      if (column_name %in% names(scaled_sens)) {  # check if the column exists in 'scaled_sens'
        # divide by population and multiply by 100000
        scaled_sens[[column_name]] <- (scaled_sens[[column_name]] / subset_pop_pivot[[city]]) * 100000
      }
    }
  }
  
  
  cities <- c("Sydney", "Melbourne", "Brisbane", "Adelaide", "Perth", "Hobart", "Darwin", "Canberra", "All GCCs")
  
  # For each city, create a new column that combines the '_rr', '_lb', and '_ub' columns
  for (i in 1:length(cities)) {
    city <- cities[i]
    prefix <- city_codes[i]
    
    rr_col <- paste0(prefix, "_rr")
    lb_col <- paste0(prefix, "_lb")
    ub_col <- paste0(prefix, "_ub")
    
    # Round the values to 2 decimal places before pasting
    scaled_sens[, (city) := paste0(round(get(rr_col), 2), " (", round(get(lb_col), 2), ", ", round(get(ub_col), 2), ")")]
  }
  
  # Define the columns to remove
  columns_to_remove <- unlist(lapply(city_codes, function(x) paste0(x, c("_rr", "_lb", "_ub"))))
  
  # Remove the original columns, except 'year'
  scaled_sens[, (columns_to_remove) := NULL]
  
  return(scaled_sens)
}
