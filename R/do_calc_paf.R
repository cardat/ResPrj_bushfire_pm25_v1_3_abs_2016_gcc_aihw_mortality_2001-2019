# Define function to calculate cases based on concentration response function
do_calc_paf <- function(
    rr_dt
){
  ## Population Attributable Fraction
  # “the fraction of all cases (exposed and unexposed) that would not have 
  # occurred if exposure had not occurred.” 
  # Rothman KJ, Greenland S. Modern epidemiology. 1998
  # paf <- (rr-1)/rr
  
  # Set the scipen option to a high value (this option in case there are
  # problems with printing numbers with scientific notation)
  # options(scipen = 999)
  
  # Create an empty data table to store the PAF values
  paf_dt <- copy(rr_dt)
  
  # Iterate over the columns starting from the 2nd column
  for (col in names(rr_dt)[-1]) {
    # Apply the formula (rr - 1) / rr to each cell in the column
    paf_values <- (rr_dt[[col]] - 1) / rr_dt[[col]]
    
    # Convert the PAF values to character format without scientific notation
    paf_values <- format(paf_values, scientific = FALSE)
    
    # Convert the PAF values to numeric format and assign them to paf_dt
    set(paf_dt, j = col, value = as.numeric(paf_values))
  }
  return(paf_dt)
}