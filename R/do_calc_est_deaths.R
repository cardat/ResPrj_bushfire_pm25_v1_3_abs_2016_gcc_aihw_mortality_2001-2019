# 
# # Create the scaling factor
# scaling_factor <- subset_pop_pivot[, lapply(.SD, function(x) sum(x) / 100000)]
# 
# # Add Est.Deaths to scaling factor
# scaling_factor <- cbind("Est.Deaths", scaling_factor)
# 
# total_row_numeric <- as.numeric(total_row[, -1])
# # Multiply the total row by the scaling factor to estimate deaths
# est_deaths_row <- round(total_row_numeric * scaling_factor[, -1], digits = 0)
# 
# # Add Est.Deaths to est_deaths_row
# est_deaths_row <- cbind("Est.Deaths", est_deaths_row)
# 
# # Calculate the sum of est_deaths_row excluding the first column
# total_est_deaths <- sum(est_deaths_row[, -1])
# 
# # total_est_deaths <- cbind("Total", total_est_deaths)