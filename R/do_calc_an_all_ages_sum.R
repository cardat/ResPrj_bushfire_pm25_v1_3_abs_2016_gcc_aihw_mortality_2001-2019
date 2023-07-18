do_calc_an_all_ages_sum <- function(
    an_all_ages_dt
){
  # Create a copy of an_all_ages_dt
  an_sum <- copy(an_all_ages_dt)
  
  # Attribute 0 to negative values
  an_sum[an_sum < 0] <- 0
  
  # Round values to 0 decimal places, except for the first column (Year)
  cols_to_round <- names(an_sum)[-1]
  an_sum[, (cols_to_round) := lapply(.SD, function(x) round(x, digits = 0)), .SDcols = cols_to_round, with = FALSE]
  
  # Calculate the sum row
  sum_row <- an_sum[, lapply(.SD, sum, na.rm = TRUE), .SDcols = cols_to_round]
  sum_row <- data.table(Year = "Sum", sum_row)
  
  # Set the order of columns in sum_row
  setcolorder(sum_row, c("Year", names(an_sum)[-1]))
  
  # Append the sum row to an_sum
  an_sum <- rbind(an_sum, sum_row, use.names = FALSE)
return(an_sum)
}
