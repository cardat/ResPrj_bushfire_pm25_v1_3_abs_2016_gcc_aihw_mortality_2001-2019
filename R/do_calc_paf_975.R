# Define function to calculate cases based on concentration response function
do_calc_paf_975 <- function(
    rr_975
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
  paf_975 <- copy(rr_975)
  
  # Iterate over the columns starting from the 2nd column
  for (col in names(rr_975)[-1]) {
    # Apply the formula (rr - 1) / rr to each cell in the column
    paf_values <- (rr_975[[col]] - 1) / rr_975[[col]]
    
    # Convert the PAF values to character format without scientific notation
    paf_values <- format(paf_values, scientific = FALSE)
    
    # Convert the PAF values to numeric format and assign them to paf_975
    set(paf_975, j = col, value = as.numeric(paf_values))
  }
  return(paf_975)
}