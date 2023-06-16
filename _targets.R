library(targets)

list(
  ### Load data ####
  #### dat_mort_aihw ####
  tar_target(
    dat_mort_aihw,
    load_mort_aihw(
      dir,
      dat
    )
  )
  ,
  #### dat_bushfire_pm25 ####
  tar_target(
    dat_bushfire_pm25,
    load_bushfire_pm25(
      dir,
      dat
    )
  )
  ,
  ### Analysis ####
  
  #### counterfactual - min pm25 ####
  tar_target(
    counterfactual,
    do_counterfactual(
      dat_bushfire_pm25,
      "min"
    )
  )
  ,
  #### pop weighting pm25 and counter ####
  tar_target(
    pop_weighted_exp,
    do_pop_weighted_exp(
      dat_mort_aihw,
      counterfactual
    )
  )
  ,
  #### Relative Risks and Theoretical Minimum Risk Exposure Level ####
  tar_target(
    health_impact,
    do_health_impact(
      case_definition = "",
      rr = c(),
      tmrel = 0
    )
  )
  ,
  #### Attributable number of deaths ####
  tar_target(
    att_number,
    do_att_number(
      health_impact,
      pop_weighted_exp
    )
  )
  ,
  ### Figures, maps, and tables ####
  #### plot_mortality_gcc ####
  tar_target(
    plot_mortality_gcc,
    do_plot_mortality_gcc(
      dat_mort_aihw
    )
  )
  ,
  #### plot_mortality_gcc ####
  tar_target(
    plot_mortality_all,
    do_plot_mortality_all(
      dat_mort_aihw
    )
  )
)