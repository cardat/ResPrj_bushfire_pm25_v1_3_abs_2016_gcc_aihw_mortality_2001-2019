do_tab_an_sens <- function(
    an_sens
){
# Define the city names and corresponding column gcc
cities <- c("Sydney", "Melbourne", "Brisbane", "Adelaide", "Perth", "Hobart", "Darwin", "Canberra", "All GCCs")
gcc <- c("1GSYD", "2GMEL", "3GBRI", "4GADE", "5GPER", "6GHOB", "7GDAR", "8ACTE", "All GCCs")

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