library(targets)
lapply(list.files("R", full.names = TRUE), source)
tar_source()
load_packages(T)
config <- yaml::read_yaml("config.yaml")
tar_visnetwork(targets_only = T,
               level_separation = 200)
tar_make()
