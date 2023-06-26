library(targets)

lapply(list.files("R", full.names = TRUE), source)

config <- yaml::read_yaml("config.yaml")

tar_option_set(
  packages =
    c("targets",
      "yaml",
      "data.table",
      "dplyr",
      "sf",
      "sp",
      "lubridate",
      "Hmisc"
    )
)

list(
  ### LOAD DATA ####
  #### dat_mort_aihw ####
  tar_target(
    dat_mort_aihw,
    load_mort_aihw(
      dir
    )
  )
  ,
  #### dat_bushfire_pm25 ####
  tar_target(
    dat_bushfire_pm25,
    load_bushfire_pm25(
      dir
    )
  )
  ,
  ### DERIVE/ADJUST ####
  #### dat_mort_aihw_simulated_2020 ####
  tar_target(
    dat_mort_aihw_simulated_2020,
    do_simulate_aihw_2020(
      dat_mort_aihw
    )
  )
  ,
  #### set_counterfactual ####
  tar_target(
    set_counterfactual,
    do_counterfactual(
      dat_bushfire_pm25
    )
  )
  ,
  ### MERGE OUTCOME AND EXPOSURE ####
  #### mrg_mort_pm25 ####
  tar_target(
    mrg_mort_pm25,
    do_mrg_mort_pm25(
      dat_mort_aihw_simulated_2020,
      set_counterfactual
    )
  )
  ,
  ### ANALYSIS ####
  # #### pop_weighted_avg_exp ####
  # tar_target(
  #   pop_weighted_avg_exp,
  #   do_pop_weighted_avg_exp(
  #     set_counterfactual,
  #     dat_mort_aihw
  #   )
  # )
  # ,
  #### Relative Risks and Theoretical Minimum Risk Exposure Level ####
  # tar_target(
  #   exposure_to_pm25_response,
  #   do_exposure_to_pm25_response(
  #     
  #   )
  # )
  # ,
  # #### Attributable number of deaths ####
  # tar_target(
  #   att_number,
  #   do_att_number(
  #     health_impact,
  #     pop_weighted_exp
  #   )
  # )
  # ,
  ### OUTPUTS ####
  #### plot_mortality_gcc ####
  tar_target(
    plot_mortality_gcc,
    do_plot_mortality_gcc(
      dat_mort_aihw_simulated_2020
    )
  )
  # ,
  # #### plot_mortality_all ####
  # tar_target(
  #   plot_mortality_all,
  #   do_plot_mortality_all(
  #     dat_mort_aihw
  #   )
  # )
)