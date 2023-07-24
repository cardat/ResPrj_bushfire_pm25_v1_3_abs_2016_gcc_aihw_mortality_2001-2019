# Define function to calculate cases based on concentration response function
do_calc_paf_sens <- function(
    rr_sens
){
  ## Population Attributable Fraction
  # “the fraction of all cases (exposed and unexposed) that would not have 
  # occurred if exposure had not occurred.” 
  # Rothman KJ, Greenland S. Modern epidemiology. 1998
  # paf <- (rr-1)/rr
  
  # Set the scipen option to a high value (this option in case there are
  # problems with printing numbers with scientific notation)
  # options(scipen = 999)
  
  # Copy rr data table to store the PAF values
  paf_sens <- copy(rr_sens)
  
  # Iterate over the columns starting from the 2nd column
  for (col in names(rr_sens)[-1]) {
    # Apply the formula (rr - 1) / rr to each cell in the column
    paf_values <- (rr_sens[[col]] - 1) / rr_sens[[col]]
    
    # Convert the PAF values to character format without scientific notation
    paf_values <- format(paf_values, scientific = FALSE)
    
    # Convert the PAF values to numeric format and assign them to paf_sens
    set(paf_sens, j = col, value = as.numeric(paf_values))
  }
  return(paf_sens)
}