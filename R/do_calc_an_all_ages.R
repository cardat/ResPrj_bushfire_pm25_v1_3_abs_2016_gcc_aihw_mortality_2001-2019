#' # Attributable number out of deaths observed given exposure - all ages
#'
#' @param paf_dt 
#' @param mrg_dat 
#'
#' @return
#' @export
#'
#' @examples

do_calc_an_all_ages <- function(
    paf_dt,
    mrg_dat
){
  # Create an empty data table to store the result
  an_all_ages_dt <- copy(paf_dt)
  
  # Compute sum of deaths all cause, all ages, by year by gcc
  sum_all_ages <- mrg_dat[, .(sum_year_all = sum(
    avg_doy_all, na.rm = TRUE)), 
    by = .(year, gcc)]
  
  # Pivot
  pivoted <- dcast(sum_all_ages, year ~ gcc, value.var = "sum_year_all")
  
  # Iterate over columns starting from the 2nd column
  for (col in names(an_all_ages_dt)[-1]) {
    # attributable_number <- paf * deaths
    # Multiply each value in the column by the corresponding values in the pivoted table
    an_all_ages_dt[[col]] <- an_all_ages_dt[[col]] * pivoted[[col]]
  }
  return(an_all_ages_dt)
}

