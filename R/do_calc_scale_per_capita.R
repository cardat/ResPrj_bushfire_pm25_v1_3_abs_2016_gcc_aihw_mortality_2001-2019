
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
  total_row <- colSums(scale_per_capita[, -1], na.rm = TRUE)
  total_row <- data.table(t(total_row))
  # Add "Total" as the first column in total_row
  total_row <- cbind("Attr.Num.Scaled", total_row)
  # Rename the columns in total_row
  colnames(total_row) <- c("Year", "Sydney", "Melbourne", "Brisbane", "Adelaide", "Perth", "Hobart", "Darwin", "ACT")
  
  # Create the scaling factor
  scaling_factor <- subset_pop_pivot[, lapply(.SD, function(x) sum(x) / 100000)]
  
  # Add Est.Deaths to scaling factor
  scaling_factor <- cbind("Est.Deaths", scaling_factor)
  
  total_row_numeric <- as.numeric(total_row[, -1])
  # Multiply the total row by the scaling factor to estimate deaths
  est_deaths_row <- round(total_row_numeric * scaling_factor[, -1], digits = 0)
  
  # Add Est.Deaths to est_deaths_row
  est_deaths_row <- cbind("Est.Deaths", est_deaths_row)
  est_deaths_row_int <- as.integer(est_deaths_row)
  # # Calculate the sum of est_deaths_row
  # total_est_deaths <- rowSums(est_deaths_row)
  # 
  # total_est_deaths <- cbind("Total", total_est_deaths)
  
  # Add total row to scale_per_capita
  scale_per_capita_bind <- rbind(scale_per_capita, 
                                 total_row, 
                                 est_deaths_row,
                                 use.names=FALSE)
  
  return(scale_per_capita_bind)
}
