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
      "Hmisc",
      "extrafont"
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
  #### dat_avg_gcc ####
  tar_target(
    dat_avg_gcc,
    do_avg_gcc(
      dat_bushfire_pm25
    )
  )
  ,
  #### dat_cf ####
  tar_target(
    dat_cf,
    do_cf(
      dat_avg_gcc
    )
  )
  ,
  ### MERGE OUTCOME AND EXPOSURE ####
  #### mrg_mort_pm25 ####
  tar_target(
    mrg_mort_pm25,
    do_mrg_mort_pm25(
      dat_mort_aihw_simulated_2020,
      dat_cf
    )
  )
  ,
  ### ANALYSIS ####
  #### calc_rr ####
  tar_target(
    calc_rr,
    do_calc_rr(
      mrg_mort_pm25,
      ## Define the percentile. 1.00 = whole sample
      threshold = 1.00
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
  #### calc_an_all_ages_sum ####
  tar_target(
    calc_an_all_ages_sum,
    do_calc_an_all_ages_sum(
      calc_an_all_ages
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
  
  ### POLICY SCENARIOS ####
  #### calc_rr_975 ####
  tar_target(
    calc_rr_975,
    do_calc_rr_975(
      mrg_mort_pm25,
      ## Define the percentile. 1.00 = whole sample
      threshold = 0.975
    )
  )
  ,
  #### calc_paf_975 ####
  tar_target(
    calc_paf_975,
    do_calc_paf_975(
      calc_rr_975
    )
  )
  ,
  #### calc_an_all_ages_975 ####
  tar_target(
    calc_an_all_ages_975,
    do_calc_an_all_ages_975(
      calc_paf_975,
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
  ,
  #### plot_extreme_days ####
  tar_target(
    plot_extreme_days,
    do_plot_extreme_days(
      dat_cf
    )
  )
  ,
  #### plot_pm25_gccs ####
  tar_target(
    plot_pm25_gccs,
    do_plot_pm25_gccs(
      dat_cf,
      plot_extreme_days
    )
  )
  ,
  #### plot_an_all_ages ####
  tar_target(
    plot_an_all_ages,
    do_plot_an_all_ages(
      calc_an_all_ages,
      # calc_an_all_ages_975,
      mrg_mort_pm25
    )
  )
  ,
  ### QUALITY CHECK ####
  #### an_all_ages_sum_qc ####
  tar_target(
    an_all_ages_sum_qc,
    do_an_all_ages_sum_qc(
      calc_an_all_ages_sum  
    )
  )
)