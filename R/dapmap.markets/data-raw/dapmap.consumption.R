
# IFA Supply Database: DAP/MAP apparent consumption 2017-2018
# From https://www.ifastat.org/supply/Phosphate%20Products/Processed%20Phosphates
dapmap.consumption <- read.csv(
  "data-raw/ifa supply db regional consumption.csv", 
  check.names = FALSE)

write.csv(
  dapmap.consumption, 
  file = "data-raw/dapmap-consumption.csv", 
  row.names = FALSE)
usethis::use_data(dapmap.consumption, overwrite = TRUE)