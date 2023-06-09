#' Load and merge the rds files into a single list (2001-2019)
#'
#' @param dir 
#'
#' @return merged_list
#' @export
#'
#' @examples

load_bushfire_pm25 <- function(
    dir
  ){

  # list all rds files
  rds_list <- list.files(config$indir_pm25, pattern = "\\.rds$", full.names = TRUE)
  
  # Create an empty list 
  stl_ <- list()  
  
  for (file in rds_list) {
    year <- sub(".rds$", "", basename(file))  # Extract object name from file name
    stl_[[year]] <- readRDS(file)  # Read the RDS file and assign it to the object
  }
  
  # Load the sp package for spatial operations
  library(sp)
  
  # Initialize empty lists for seasonal, trend, and remainder
  seasonal_list <- list()
  trend_list <- list()
  remainder_list <- list()
  
  # Iterate over each year from 2001 to 2019
  for (year in 2001:2019) {
    # Extract the sublist for the current year
    current_year_list <- stl_[[as.character(year)]]
    
    # Extract the seasonal, trend, and remainder spatial objects from the current sublist
    current_seasonal <- current_year_list$seasonal
    current_trend <- current_year_list$trend
    current_remainder <- current_year_list$remainder
    
    # Append the spatial objects to their respective lists
    seasonal_list <- c(seasonal_list, current_seasonal)
    trend_list <- c(trend_list, current_trend)
    remainder_list <- c(remainder_list, current_remainder)
  }
  
  # Create a merged list with the combined spatial objects
  merged_list <- list(
    seasonal = do.call(rbind, seasonal_list),
    trend = do.call(rbind, trend_list),
    remainder = do.call(rbind, remainder_list)
  )
  
    # Save the merged data into a single file
    saveRDS(merged_list, file = file.path(config$outdat_pm25, "bushfire_pm25_2001-2019.rds"))

    # Return the merged file object
    return(merged_list)
  }
  