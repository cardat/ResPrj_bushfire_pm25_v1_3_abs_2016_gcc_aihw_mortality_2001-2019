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
    `Population (2016)` = format(
      unique(pop),
      big.mark = ","),
    Deaths = format(
      round(
        sum(
          avg_doy_all, 
          na.rm = TRUE)
      ), 
      big.mark = ","
    )
  ),
  by = gcc][, gcc := NULL]
  
  return(tab_mortality)
}