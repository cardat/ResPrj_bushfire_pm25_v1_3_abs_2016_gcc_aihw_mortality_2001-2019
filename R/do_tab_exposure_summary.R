do_tab_exposure_summary <- function(
    pm25
){

# Define a named vector with the city names for each gcc_code
city_names <- c("1GSYD" = "Sydney",
                "2GMEL" = "Melbourne",
                "3GBRI" = "Brisbane",
                "4GADE" = "Adelaide",
                "5GPER" = "Perth",
                "6GHOB" = "Hobart",
                "7GDAR" = "Darwin",
                "8ACTE" = "Canberra")

# Subset the data table for each gcc_code and calculate summary statistics
summary_stats_by_gcc <- pm25[, .(Mean = round(mean(pm25_pred), 2),
                                 Median = round(median(pm25_pred), 2),
                                 Min = round(min(pm25_pred), 2),
                                 Max = round(max(pm25_pred), 2)),
                             by = gcc_code16][order(gcc_code16)]

# Add the city names to the result
summary_stats_by_gcc[, City := city_names[as.character(gcc_code16)]]

# Delete the gcc_code16 column
summary_stats_by_gcc[, gcc_code16 := NULL]

# Reorder the columns
summary_stats_by_gcc <- summary_stats_by_gcc[, c("City", "Min", "Mean", "Median", "Max")]

# Print the result
return(summary_stats_by_gcc)
}
