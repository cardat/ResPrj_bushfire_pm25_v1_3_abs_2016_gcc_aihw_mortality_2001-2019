do_tab_exposure <- function(
    pm25
){
  # Define city names
  city_names <- c(
    "1GSYD" = "Sydney", 
    "2GMEL" = "Melbourne", 
    "3GBRI" = "Brisbane", 
    "4GADE" = "Adelaide", 
    "5GPER" = "Perth", 
    "6GHOB" = "Hobart",
    "7GDAR" = "Darwin", 
    "8ACTE" = "Canberra")
  
  # Define exposure categories
  exposure_categories <- c(
    "good", 
    "moderate", 
    "unhealthy_sensitive",
    "unhealthy", 
    "very_unhealthy", 
    "hazardous", 
    "extreme"
    )
  
  # Create a function to count non-NA values for each exposure category in a vector
  count_non_na <- function(x) sum(!is.na(x))
  
  # Create a data table to store the final results
  tab_exposure <- data.table()
  
  # Loop through each city
  for (city_code in names(city_names)) {
    # Subset the data for the current city
    city_data <- pm25[
      gcc_code16 == city_code,
      .SD,
      .SDcols = exposure_categories]
    
    # Calculate the counts for each exposure category in the city
    exposure_counts <- lapply(
      city_data, 
      count_non_na)
    
    # Create a data table with the counts for the current city
    tab_city <- data.table(
      Categories = exposure_categories, 
      exposure_counts)
    
    # Pivot the data table
    tab_exposure_pivoted <- dcast(
      tab_city, . ~ Categories, 
      value.var = "exposure_counts")
    
    # Delete the column "."
    set(tab_exposure_pivoted, 
        j = ".", 
        value = NULL)
    
    # Create a new variable "City" and set the value to the current city name
    tab_exposure_pivoted[, City := city_names[city_code]]
    
    # Reorder columns to desired order
    desired_order <- c(
      "City", 
      "good", 
      "moderate",
      "unhealthy_sensitive",
      "unhealthy", 
      "very_unhealthy", 
      "hazardous", 
      "extreme"
      )
    setcolorder(tab_exposure_pivoted, desired_order)
    
    # Append the data for the current city to the final data table
    tab_exposure <- rbindlist(list(tab_exposure, tab_exposure_pivoted))
  }
  
  # Convert list columns to numeric
  tab_exposure[, c(
    "good", 
    "moderate", 
    "unhealthy_sensitive", 
    "unhealthy", 
    "very_unhealthy", 
    "hazardous", 
    "extreme"
    ) := 
      lapply(
        .SD, function(x) as.numeric(unlist(x))), 
    .SDcols = c(
      "good", 
      "moderate", 
      "unhealthy_sensitive", 
      "unhealthy", 
      "very_unhealthy", 
      "hazardous", 
      "extreme"
      )]
  
  # Now add the Sum column
  tab_exposure[, Sum := rowSums(.SD), .SDcols = -c("City", "good")]
  
  # Add a column that contains the ratio of the Sum and "good" column values
  tab_exposure[, Ratio := Sum / good]
  
  # Delete the "Sum" column
  tab_exposure[, Sum := NULL]
  
  # Sort by "Ratio" column in ascending order
  setorder(tab_exposure, Ratio)
  
  return(tab_exposure)
}