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

summary_stats_by_gcc <- pm25[, .(Min = round(min(pm25_pred), 2),
                                 `25th percentile` = round(quantile(pm25_pred, 0.25), 2),
                                 Median = round(median(pm25_pred), 2),
                                 Mean = round(mean(pm25_pred), 2),
                                 `75th percentile` = round(quantile(pm25_pred, 0.75), 2),
                                 `95th percentile` = round(quantile(pm25_pred, 0.95), 2),
                                 Max = round(max(pm25_pred), 2),
                                 `Days > 25μg/m3` = sum(pm25_pred > 25),
                                 `Days > 20μg/m3` = sum(pm25_pred > 20),
                                 `Days > 15μg/m3` = sum(pm25_pred > 15)),
                             by = gcc_code16][order(gcc_code16)]

# Add the city names to the result
summary_stats_by_gcc[, City := city_names[as.character(gcc_code16)]]

# Delete the gcc_code16 column
summary_stats_by_gcc[, gcc_code16 := NULL]

# Reorder the columns
summary_stats_by_gcc <- summary_stats_by_gcc[, c(
  "City",
  "Min",
  "25th percentile",
  "Median",
  "Mean", 
  "75th percentile",
  "95th percentile",
  "Max",
  "Days > 25μg/m3",
  "Days > 20μg/m3",
  "Days > 15μg/m3"
  )]

# Print the result
return(summary_stats_by_gcc)
}
