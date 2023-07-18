do_an_all_ages_sum_qc <- function(
    an_sum
){
  # Convert 'year' column from character to numeric
  an_sum[, year := as.numeric(year)]
  
  # Get column names with "_rr"
  rr_cols <- grep("_rr", names(an_sum), value = TRUE)
  
  # Order the data table by 'year' in ascending order
  setorder(an_sum, year)
  
  # Initialize a data table to store the results
  qc <- data.table(year_range = character(), total_sum = numeric())
  
  # Loop over each two-year combination (row by row)
  for(i in 1:(nrow(an_sum) - 1)){
    # Get sum for each two-year combination
    sum_2years <- sum(an_sum[i, ..rr_cols], na.rm = TRUE) +
      sum(an_sum[i+1, ..rr_cols], na.rm = TRUE)
    
    # Combine start and end years into one column
    year_range <- paste(an_sum[i]$year, an_sum[i+1]$year, sep = "-")
    
    # Store the qc
    qc <- rbind(qc, list(year_range = year_range, total_sum = sum_2years))
  }
  
  # Remove the first row from qc (which corresponds to the year 2000-2001)
  qc <- qc[-1]
  
  return(qc)
}