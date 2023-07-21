do_tab_mort <- function(
    sim_obs
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
  tab_mortality <- sim_obs[, .(
    City = city_names[gcc], 
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