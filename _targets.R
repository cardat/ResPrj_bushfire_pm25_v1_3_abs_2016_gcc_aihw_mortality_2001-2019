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
  ### ANALYSIS ####
  #### set_counterfactual ####
  tar_target(
    set_counterfactual,
    do_counterfactual(
      dat_bushfire_pm25
    )
  )
  ,
  # #### pop_weighted_avg_exp ####
  # tar_target(
  #   pop_weighted_avg_exp,
  #   do_pop_weighted_avg_exp(
  #     set_counterfactual,
  #     dat_mort_aihw
  #   )
  # )
  # ,
  # #### Relative Risks and Theoretical Minimum Risk Exposure Level ####
  # tar_target(
  #   health_impact,
  #   do_health_impact(
  #     case_definition = "",
  #     rr = c(),
  #     tmrel = 0
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
      dat_mort_aihw
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