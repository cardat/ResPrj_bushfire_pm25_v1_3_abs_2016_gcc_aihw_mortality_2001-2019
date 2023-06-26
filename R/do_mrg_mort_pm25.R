do_mrg_mort_pm25 <- function(
    sim_obs,
    pm25
){
# Rename the "gcc_code16" column in pm25 to "gcc"
setnames(
  pm25, 
  old = "gcc_code16", 
  new = "gcc"
  )

# Perform the merge
mrg_dat <- merge(
  sim_obs, pm25, 
  by = c("gcc", "date"), 
  all = TRUE
  )

return(mrg_dat)
}
