#' Load and merge the rds files into a single list (2001-2019)
#'
#' @param dir 
#'
#' @return pm25_stl
#' @export
#'
#' @examples

load_bushfire_pm25 <- function(
    dir
  ){

  # list all rds files
  rds_list <- list.files(config$indir_pm25, 
                         pattern = "\\.rds$", 
                         full.names = TRUE)
  
  # Create an empty data.table to store the merged data
  pm25_stl <- data.table()  
  
  # Loop through each file
  for (file in rds_list) {
    # Load the .rds file
    dat <- readRDS(file)
    
    # Filter the data based on the "gcc_code16" variable
    gcc <- dat[gcc_code16 %in% c(
      "1GSYD", 
      "2GMEL", 
      "3GBRI", 
      "4GADE", 
      "5GPER", 
      "6GHOB", 
      "7GDAR", 
      "8ACTE"
    )]
      # Bind the gcc to the pm25_stl table
      pm25_stl <- rbind(pm25_stl, gcc)
    }
  saveRDS(pm25_stl, file = file.path(config$outdir_pm25, config$outdat_pm25))
  return(pm25_stl)
}