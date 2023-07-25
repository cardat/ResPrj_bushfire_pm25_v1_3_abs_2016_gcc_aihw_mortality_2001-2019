#' # Attributable number out of deaths observed given exposure - all ages
#'
#' @param paf_sens 
#' @param mrg_dat 
#'
#' @return
#' @export
#'
#' @examples

do_calc_an_all_ages_sens <- function(
    paf_sens,
    mrg_dat
){
  # Create an empty data table to store the result
  an_all_ages_sens <- copy(paf_sens)
  
  # Obtain unique gccs from the column names
  gccs <- gsub("_.*", "", names(paf_sens)[-1])
  
  # Iterate over each gcc
  for (gcc_val in gccs) {
    # Extract data for the current gcc
    rr_gcc <- paf_sens[, .(date, rr = get(paste0(gcc_val, "_rr")), 
                         lb = get(paste0(gcc_val, "_lb")), 
                         ub = get(paste0(gcc_val, "_ub")))]
    
    # Extract corresponding avg_doy_all data
    avg_doy_all <- mrg_dat[mrg_dat$gcc == gcc_val, 
                           .(date, avg_doy_all)]
    
    # Convert date column from numeric to date format
    avg_doy_all$date <- as.Date(avg_doy_all$date, origin = "1970-01-01")
    rr_gcc$date <- as.Date(rr_gcc$date, origin = "1970-01-01")
    
    # Merge the rr and avg_doy_all data
    merged_dt <- merge(rr_gcc, avg_doy_all, by = "date")
    
    # Compute the product
    merged_dt[, `:=` (rr = rr * avg_doy_all, 
                      lb = lb * avg_doy_all, 
                      ub = ub * avg_doy_all)]
    
    # Replace the values in the original data table
    for (col in c("rr", "lb", "ub")) {
      set(an_all_ages_sens, which(an_all_ages_sens$date == merged_dt$date), 
          paste0(gcc_val, "_", col), merged_dt[[col]])
    }
  }
  return(an_all_ages_sens)
}
