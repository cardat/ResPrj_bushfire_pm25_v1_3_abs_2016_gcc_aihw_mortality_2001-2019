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
  #### calc_rr ####
  tar_target(
    calc_rr,
    do_calc_rr(
      mrg_mort_pm25
    )
  )
  ,
  #### calc_paf ####
  tar_target(
    calc_paf,
    do_calc_paf(
      calc_rr
    )
  )
  ,
  #### calc_an_all_ages ####
  tar_target(
    calc_an_all_ages,
    do_calc_an_all_ages(
      calc_paf,
      mrg_mort_pm25
    )
  )
  ,
  #### calc_scale_per_capita ####
  tar_target(
    calc_scale_per_capita,
    do_calc_scale_per_capita(
      calc_an_all_ages,
      mrg_mort_pm25
    )
  )
  ,
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
  #### table_an_per_capita ####
  # tar_target(
  #   table_an_per_capita,
  #   do_table_an_per_capita(
  #     calc_scale_per_capita
  #   )
)