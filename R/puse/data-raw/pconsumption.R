library(dplyr)
library(reshape2)

# IFASTAT Consumption database: P2O5 consumption 2007-2017 by country
# From https://www.ifastat.org/databases/plant-nutrition
pconsumption <- read.csv(
  "data-raw/ifa data/IFADATA Consumption.csv", 
  check.names = FALSE) %>%
  left_join(
    read.csv(
      "data-raw/classifications/IFASTAT countries classification.csv", 
      check.names = FALSE), 
    by = c("Country" = "IFASTAT")) %>%
  select(-c(Country, Area)) %>%
  group_by(Year, Region) %>%
  group_modify(~ .x %>% summarise_all(sum)) %>%
  ungroup() %>%
  mutate(Consumption = Consumption * 10^3) %>%
  dcast(Year ~ Region, value.var = "Consumption") %>%
  as.data.frame()

write.csv(pconsumption, file = "data-raw/pconsumption.csv", row.names = FALSE)
usethis::use_data(pconsumption, overwrite = TRUE)