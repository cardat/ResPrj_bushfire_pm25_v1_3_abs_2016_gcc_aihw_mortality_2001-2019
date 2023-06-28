
do_calc_scale_per_capita <- function(
    an_all_ages_dt,
    mrg_dat
){
  subset_pop <- unique(mrg_dat[, .(pop), by = gcc])
  # Add a dummy variable for pivot
  subset_pop[, dummy := 1]
  
  # Pivot subset_pop to wide format
  subset_pop_pivot <- dcast(subset_pop, dummy ~ gcc, value.var = "pop")
  
  # Remove the dummy variable
  subset_pop_pivot[, dummy := NULL]
  
  # Create a copy of an_all_ages_dt
  scale_per_capita <- copy(an_all_ages_dt)  
  
  # Divide each cell by pop and multiply by 100,000
  for (col in names(scale_per_capita)[-1]) {
    scale_per_capita[, (col) := get(col) / subset_pop_pivot[[col]] * 100000]
  }
  
  # Rename columns
  setnames(scale_per_capita, 
           c("year", "1GSYD", "2GMEL", "3GBRI", "4GADE", "5GPER", "6GHOB", 
             "7GDAR", "8ACTE"),
           c("Year", "Sydney", "Melbourne", "Brisbane", "Adelaide", 
             "Perth", "Hobart", "Darwin", "ACT"))
  # Calculate total row
  sum_row <- colSums(scale_per_capita[, -1], na.rm = TRUE)
  sum_row <- data.table(t(sum_row))
  # Add "Total" as the first column in sum_row
  sum_row <- cbind("Sum", sum_row)
  # Rename the columns in sum_row
  colnames(sum_row) <- c("Year", "Sydney", "Melbourne", "Brisbane", 
                           "Adelaide", "Perth", "Hobart", "Darwin", "ACT")
  
  # Add total row to scale_per_capita
  scale_per_capita_bind <- rbind(scale_per_capita, 
                                 sum_row,
                                 use.names=FALSE)
  
  # Replace negative values with 0 in scale_per_capita_bind
  scale_per_capita_bind <- pmax(scale_per_capita_bind, 0)
  
  # Round values to 2 decimal places in scale_per_capita_bind, except for the first column
  cols_to_round <- names(scale_per_capita_bind)[-1]
  scale_per_capita_bind[, (cols_to_round) := lapply(
    .SD, function(x) round(x, digits = 2)), 
    .SDcols = cols_to_round, 
    with = FALSE]
  
  return(scale_per_capita_bind)
}
