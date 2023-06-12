#' Load and merge the rds files into a single list (2001-2019)
#'
#' @param dir 
#'
#' @return merged_list
#' @export bushfire_pm25_2001-2019_stl.rds
#'
#' @examples

load_bushfire_pm25 <- function(
    dir
  ){

  # list all rds files
  rds_list <- list.files(config$indir_pm25, 
                         pattern = "\\.rds$", 
                         full.names = TRUE)
  
  # Create an empty list 
  stl <- list()  
  
  for (file in rds_list) {
    # Extract object name from file name
    year <- sub(".rds$", "", basename(file)) 
    # Read the RDS file and assign it to the object
    stl[[year]] <- readRDS(file)  
  }
  
  # Create empty lists for seasonal, trend, and remainder
  seasonal_list <- list()
  trend_list <- list()
  remainder_list <- list()
  
  # Vector with GCCs
  gcc_codes <- c("1GSYD", 
                 "2GMEL", 
                 "3GBRI", 
                 "4GADE", 
                 "5GPER", 
                 "6GHOB", 
                 "7GDAR", 
                 "8ACTE")
  
  # Iterate over each year
  for (year in 2001:2002) {
    # Extract the sublist for the current year
    current_year_list <- stl[[as.character(year)]]
    
    current_seasonal <- current_year_list$seasonal
    current_trend <- current_year_list$trend
    current_remainder <- current_year_list$remainder
    
    # Filter by gcc_code16
    filtered_seasonal <- current_seasonal[current_seasonal$gcc_code16 %in% gcc_codes, ]
    filtered_trend <- current_trend[current_trend$gcc_code16 %in% gcc_codes, ]
    filtered_remainder <- current_remainder[current_remainder$gcc_code16 %in% gcc_codes, ]
    
    # Append the spatial objects to their respective lists
    seasonal_list <- c(seasonal_list, filtered_seasonal)
    trend_list <- c(trend_list, filtered_trend)
    remainder_list <- c(remainder_list, filtered_remainder)
  }
  
  # Create a merged list with the combined spatial objects
  merged_list <- list(
    seasonal = do.call(rbind, seasonal_list),
    trend = do.call(rbind, trend_list),
    remainder = do.call(rbind, remainder_list)
  )
  
    # Save the merged data into a single file
    saveRDS(merged_list, file = file.path(config$outdir_pm25, 
                                          config$outdat_pm25))
    # Return the merged file object
    return(merged_list)
  }
  