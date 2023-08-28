do_tab_mort <- function(
    mrg_dat
){
  
  # Create a named vector to map the codes to the actual city names
  city_names <- c("1GSYD" = "Sydney", 
                  "2GMEL" = "Melbourne", 
                  "3GBRI" = "Brisbane", 
                  "4GADE" = "Adelaide", 
                  "5GPER" = "Perth", 
                  "6GHOB" = "Hobart",
                  "7GDAR" = "Darwin", 
                  "8ACTE" = "Canberra")
  
  # Create the new data table without the gcc column
  tab_mortality <- mrg_dat[, .(
    City = city_names[gcc],
    `Population (2016)` = format(unique(pop), big.mark = ","),
    Deaths = format(round(sum(avg_doy_all, na.rm = TRUE)), big.mark = ","),
    Min = round(min(avg_doy_all, na.rm = TRUE), 2),
    `25th percentile` = round(quantile(avg_doy_all, 0.25, na.rm = TRUE), 2),
    Median = round(median(avg_doy_all, na.rm = TRUE), 2),
    Mean = round(mean(avg_doy_all, na.rm = TRUE), 2),
    `75th percentile` = round(quantile(avg_doy_all, 0.75, na.rm = TRUE), 2),
    `95th percentile` = round(quantile(avg_doy_all, 0.95, na.rm = TRUE), 2),
    Max = round(max(avg_doy_all, na.rm = TRUE), 2)
  ),
  by = gcc][, gcc := NULL]
  
  return(tab_mortality)
}