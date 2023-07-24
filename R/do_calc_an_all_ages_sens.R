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
  
  # Compute sum of deaths all cause, all ages, by year by gcc
  sum_all_ages <- mrg_dat[, .(sum_year_all = sum(
    avg_doy_all, na.rm = TRUE)), 
    by = .(year, gcc)]
  
  # Pivot
  pivoted <- dcast(sum_all_ages, year ~ gcc, value.var = "sum_year_all")
  
  # Create a new pivoted table with duplicated columns
  pivoted_expanded <- data.table(year = pivoted$year)
  
  gccs <- unique(mrg_dat$gcc)  # Obtain unique values from the gcc column
  
  for (gcc_val in gccs) {
    dt <- data.table(rr = pivoted[[gcc_val]], 
                     lb = pivoted[[gcc_val]], 
                     ub = pivoted[[gcc_val]])
    setnames(dt, 
             old = c("rr", "lb", "ub"), 
             new = c(paste0(gcc_val,"_rr"), 
                     paste0(gcc_val,"_lb"), 
                     paste0(gcc_val,"_ub")
             )
    )
    pivoted_expanded <- cbind(pivoted_expanded, dt)
  }
  
  # multiply columns
  for (col in names(an_all_ages_sens)[-1]) {
    an_all_ages_sens[[col]] <- an_all_ages_sens[[col]] * pivoted_expanded[[col]]
  }
  return(an_all_ages_sens)
}

