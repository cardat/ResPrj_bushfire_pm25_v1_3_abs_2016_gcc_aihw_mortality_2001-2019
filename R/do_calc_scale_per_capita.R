
do_calc_scale_per_capita <- function(
    an_all_ages_dt,
    mrg_dat
){
  subset_pop <- unique(mrg_dat[, .(pop), by = gcc])
  # Add a dummy variable for pivot
  subset_pop[, dummy := 1]
  
  # Pivot subset_pop to wide format
  subset_pop_pivot <- dcast(subset_pop, dummy ~ gcc, value.var = "pop")
  
  # Remove the dummy variable
  subset_pop_pivot[, dummy := NULL]
  
  # Create a copy of an_all_ages_dt
  scale_per_capita <- copy(an_all_ages_dt)  
  
  # Expand subset_pop_pivot to have rr, lb, and ub for each gcc
  subset_pop_pivot_expanded <- data.table(dummy = subset_pop_pivot$dummy)
 
  gccs <- unique(mrg_dat$gcc)  # Obtain unique values from the gcc column
  
  for (gcc_val in gccs) {
    dt <- data.table(
      rr = subset_pop_pivot[[gcc_val]], 
      lb = subset_pop_pivot[[gcc_val]], 
      ub = subset_pop_pivot[[gcc_val]])
    setnames(dt, 
             old = c("rr", "lb", "ub"), 
             new = c(paste0(gcc_val,"_rr"), 
                     paste0(gcc_val,"_lb"), 
                     paste0(gcc_val,"_ub")))
    subset_pop_pivot_expanded <- cbind(subset_pop_pivot_expanded, dt)
  }
  
  # Remove the dummy variable
  subset_pop_pivot_expanded[, dummy := NULL]
  
  # Divide each cell by pop and multiply by 100,000
  for (col in names(scale_per_capita)[-1]) {
    scale_per_capita[, (col) := get(col) / subset_pop_pivot_expanded[[col]] * 100000]
  }
  
  # Rename columns in subset_pop_pivot_expanded
  setnames(subset_pop_pivot_expanded, 
           c(
             paste0("1GSYD", c("_rr", "_lb", "_ub")), 
             paste0("2GMEL", c("_rr", "_lb", "_ub")), 
             paste0("3GBRI", c("_rr", "_lb", "_ub")), 
             paste0("4GADE", c("_rr", "_lb", "_ub")), 
             paste0("5GPER", c("_rr", "_lb", "_ub")), 
             paste0("6GHOB", c("_rr", "_lb", "_ub")), 
             paste0("7GDAR", c("_rr", "_lb", "_ub")), 
             paste0("8ACTE", c("_rr", "_lb", "_ub"))),
           c(
             paste0("Sydney", c("_rr", "_lb", "_ub")), 
             paste0("Melbourne", c("_rr", "_lb", "_ub")), 
             paste0("Brisbane", c("_rr", "_lb", "_ub")), 
             paste0("Adelaide", c("_rr", "_lb", "_ub")), 
             paste0("Perth", c("_rr", "_lb", "_ub")), 
             paste0("Hobart", c("_rr", "_lb", "_ub")), 
             paste0("Darwin", c("_rr", "_lb", "_ub")), 
             paste0("ACT", c("_rr", "_lb", "_ub"))))
  # Rename columns
  setnames(scale_per_capita,
           c("year",
             paste0("1GSYD", c("_rr", "_lb", "_ub")),
             paste0("2GMEL", c("_rr", "_lb", "_ub")),
             paste0("3GBRI", c("_rr", "_lb", "_ub")),
             paste0("4GADE", c("_rr", "_lb", "_ub")),
             paste0("5GPER", c("_rr", "_lb", "_ub")),
             paste0("6GHOB", c("_rr", "_lb", "_ub")),
             paste0("7GDAR", c("_rr", "_lb", "_ub")),
             paste0("8ACTE", c("_rr", "_lb", "_ub"))),
           c("Year",
             paste0("Sydney", c("_rr", "_lb", "_ub")),
             paste0("Melbourne", c("_rr", "_lb", "_ub")),
             paste0("Brisbane", c("_rr", "_lb", "_ub")),
             paste0("Adelaide", c("_rr", "_lb", "_ub")),
             paste0("Perth", c("_rr", "_lb", "_ub")),
             paste0("Hobart", c("_rr", "_lb", "_ub")),
             paste0("Darwin", c("_rr", "_lb", "_ub")),
             paste0("ACT", c("_rr", "_lb", "_ub"))))
  
  # Replace negative values with 0 in scale_per_capita_bind
  scale_per_capita <- pmax(scale_per_capita, 0)
  
  # Round values to 2 decimal places in scale_per_capita_bind, except for the first column
  cols_to_round <- names(scale_per_capita)[-1]
  scale_per_capita[, (cols_to_round) := lapply(
    .SD, function(x) round(x, digits = 2)), 
    .SDcols = cols_to_round, 
    with = FALSE]
  
  return(scale_per_capita)
}
