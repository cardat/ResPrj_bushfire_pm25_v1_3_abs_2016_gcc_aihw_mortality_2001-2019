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
  ### SENSITIVITY ANALYSIS ####
  #### calc_rr_sens ####
  tar_target(
    calc_rr_sens,
    do_calc_rr_sens(
      mrg_mort_pm25,
      ## Define the percentile. 1.00 = whole sample
      threshold = 0.95
    )
  )
  ,
  #### calc_paf_sens ####
  tar_target(
    calc_paf_sens,
    do_calc_paf_sens(
      calc_rr_sens
    )
  )
  ,
  #### calc_an_all_ages_sens ####
  tar_target(
    calc_an_all_ages_sens,
    do_calc_an_all_ages_sens(
      calc_paf_sens,
      mrg_mort_pm25
    )
  )
  ,
  #### calc_an_all_ages_sens_sum ####
  tar_target(
    calc_an_all_ages_sens_sum,
    do_calc_an_all_ages_sens_sum(
      calc_an_all_ages_sens
    )
  )
  ,
  ### NON-EXCEPTIONAL DAYS DEATHS ####
  #### calc_rr ####
  tar_target(
    calc_rr1,
    do_calc_rr1(
      mrg_mort_pm25,
      ## Define the percentile. 1.00 = whole sample
      threshold = 1.00
    )
  )
  ,
  #### calc_paf1 ####
  tar_target(
    calc_paf1,
    do_calc_paf1(
      calc_rr1
    )
  )
  ,
  #### calc_an_all_ages1 ####
  tar_target(
    calc_an_all_ages1,
    do_calc_an_all_ages1(
      calc_paf1,
      mrg_mort_pm25
    )
  )
  ,
  #### calc_an_all_ages_sum1 ####
  tar_target(
    calc_an_all_ages_sum1,
    do_calc_an_all_ages_sum1(
      calc_an_all_ages1
    )
  )
  ,
  ### OUTPUTS ####
  ### TABLES ####
  #### tab_mortality ####
  tar_target(
    tab_mortality,
    do_tab_mort(
      mrg_mort_pm25
    )
  )
  ,
  #### tab_exposure ####
  tar_target(
    tab_exposure,
    do_tab_exposure(
      dat_cf
    )
  )
  ,
  #### tab_exposure_summary ####
  tar_target(
    tab_exposure_summary,
    do_tab_exposure_summary(
      dat_cf
    )
  )
  ,
  #### tab_an ####
  tar_target(
    tab_an,
    do_tab_an(
      calc_an_all_ages_sum
    )
  )
  ,
  #### tab_an_sens ####
  tar_target(
    tab_an_sens,
    do_tab_an_sens(
      calc_an_all_ages_sens_sum
    )
  )
  ,
  #### tab_an1 ####
  tar_target(
    tab_an1,
    do_tab_an1(
      calc_an_all_ages_sum1
    )
  )
  ,
  #### tab_scale ####
  tar_target(
    tab_scale,
    do_tab_scale(
      calc_an_all_ages_sum,
      mrg_mort_pm25
    )
  )
  ,
  #### tab_scale_sens ####
  tar_target(
    tab_scale_sens,
    do_tab_scale_sens(
      calc_an_all_ages_sens_sum,
      mrg_mort_pm25
    )
  )
  ,
  #### tab_scale1 ####
  tar_target(
    tab_scale1,
    do_tab_scale1(
      calc_an_all_ages_sum1,
      mrg_mort_pm25
    )
  )
  ,
  #### tab_rr ####
  tar_target(
    tab_rr,
    do_tab_rr(
      calc_rr
    )
  )
  ,
  #### tab_rr_sens ####
  tar_target(
    tab_rr_sens,
    do_tab_rr_sens(
      calc_rr_sens
    )
  )
  ,
  #### tab_rr1 ####
  tar_target(
    tab_rr1,
    do_tab_rr1(
      calc_rr1
    )
  )
  ,
  ### FIGURES ####
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
  #### plot_pm25_nepm ####
  tar_target(
    plot_pm25_nepm,
    do_plot_pm25_nepm(
      mrg_mort_pm25
    )
  )
  ,
  #### plot_5th ####
  tar_target(
    plot_5th,
    do_plot_5th(
      mrg_mort_pm25
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
  #### plot_an ####
  tar_target(
    plot_an,
    do_plot_an(
      calc_an_all_ages,
      mrg_mort_pm25
    )
  )
  ,
  #### plot_an_all_ages ####
  # plot with sensitivity analysis #
  tar_target(
    plot_an_all_ages,
    do_plot_an_all_ages(
      calc_an_all_ages,
      calc_an_all_ages_sens,
      calc_an_all_ages1,
      mrg_mort_pm25
    )
  )
  ,
  #### plot_oneyear ####
  tar_target(
    plot_oneyear,
    do_plot_oneyear(
      mrg_mort_pm25,
      idx = as.Date("2002-01-01"): as.Date("2002-12-31"),
      pct = 0.95,
      city = "7GDAR",
      city_name = "Darwin", #for the plot's title
      year = "(2002)" #for the plot's title
    )
  )
  # ,
  # ### QUALITY CHECK ####
  # #### an_all_ages_sum_qc ####
  # tar_target(
  #   an_all_ages_sum_qc,
  #   do_an_all_ages_sum_qc(
  #     calc_an_all_ages_sum  
  #   )
  # )
)
