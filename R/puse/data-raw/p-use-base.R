library(dplyr)
library(reshape2)

# IFASTAT Consumption database: P2O5 consumption 2014 by country
# From https://www.ifastat.org/databases/plant-nutrition
consumption <- read.csv(
  "data-raw/ifa data/IFADATA Consumption.csv", 
  check.names = FALSE) %>%
  left_join(
    read.csv(
      "data-raw/classifications/IFASTAT countries classification.csv", 
      check.names = FALSE), 
    by = c("Country" = "IFASTAT")) %>%
  filter(Year == 2014) %>%
  select(-c(Country, Year)) %>%
  group_by(Area, Region) %>%
  group_modify(~ .x %>% summarise_all(sum)) %>%
  ungroup() %>%
  mutate(Consumption = Consumption * 10^3) %>%
  as.data.frame()

# IFA & IPNI assessment of fertilizer use by crop and country 
# scaled to replicate country/region P use from IFASTAT Consumption Database
# IFA, & IPNI. (2017). Assessment of Fertilizer Use by Crop at the Global Level 2014-2014/15. 
# Downloaded from https://www.ifastat.org/plant-nutrition
ifa_p_use_data <- read.csv(
  "data-raw/ifa data/P fertilizer use by crop 2014-15.csv", 
  check.names = FALSE)
ifa_p_use_corrected <- ifa_p_use_data %>%
  melt(id = "Area") %>%
  left_join(
    cbind(
      ifa_p_use_data %>% select(Area), 
      Total = rowSums(ifa_p_use_data %>% select(-Area))), 
    by = c("Area")) %>%
  left_join(consumption, by = c("Area")) %>%
  mutate(`Scaled value` = value * Consumption / Total) %>%
  dcast(Area + Region ~ variable, value.var = "Scaled value") %>%
  select(-c(Grass, Residual)) %>%
  melt(id = c("Area", "Region")) %>%
  rename(`Crop Group` = variable, `P Use` = value)

crops_base <- read.csv(
  "data-raw/crops-observations.csv", 
  check.names = FALSE) %>%
  filter(Year == 2014) %>%
  select(-Year)
p_use <-  crops_base %>%
  left_join(
    read.csv(
      "data-raw/classifications/area unit classification.csv", 
      check.names = FALSE), 
    by = c("Area Unit", "Area Group")) %>%
  melt(id = c("Area Unit", "Area Group", "IFA Unit", "Region")) %>%
  rename(`Crop Group` = variable, Production = value) %>%
  left_join(
    ifa_p_use_corrected %>% filter(Area != "RoW"),
    by = c("IFA Unit" = "Area", "Crop Group", "Region")) %>%
  group_by(`Crop Group`, `IFA Unit`) %>%
  group_modify(~{
    if ((as.character(.y$`IFA Unit`) == "EU-28") &
        !isTRUE(all.equal(sum(pull(.x, Production)), 0)))
      .x %>% mutate(`P Use` = `P Use` * Production / sum(Production))
    else .x
  }) %>%
  ungroup() %>%
  group_by(`Crop Group`, `IFA Unit`, Region) %>%
  group_modify(~{
    if ((as.character(.y$`IFA Unit`) == "RoW") &
        !isTRUE(all.equal(sum(pull(.x, Production)), 0))) {
      
      # P uses by crops in the rest of a region preserve proportions from RoW 
      # in the IFA-IPNI report
      p_use <- ifa_p_use_corrected %>%
        filter(
          Area == "RoW" &
            `Crop Group` == as.character(.y$`Crop Group`) &
            Region == as.character(.y$Region)) %>%
        pull(`P Use`)

      if (identical(p_use, numeric(0)))
        .x %>% mutate(`P Use` = NA)
      else
        .x %>%
        mutate(
          `P Use` = ifa_p_use_corrected %>%
            filter(Area == "RoW" &
                     `Crop Group` == as.character(.y$`Crop Group`) &
                     Region == as.character(.y$Region)) %>%
            pull(`P Use`) * Production / sum(Production))
    }
    else .x
  }) %>%
  ungroup() %>%
  mutate(`P Use` = case_when(Production == 0 ~ NA_real_, TRUE ~ `P Use`)) %>%
  select(-c(`IFA Unit`)) %>%
  as.data.frame()

# minimum p application rate in a region as regional default value  
default_rates <- p_use %>%
  mutate(`P Rate` = `P Use` / Production) %>%
  select(c(Region, `Crop Group`, `P Rate`)) %>%
  group_by(Region, `Crop Group`) %>%
  group_modify(~ {
    if (all(is.na(.x$`P Rate`)))
      data.frame("P Rate" = NA_real_, check.names = FALSE)
    else .x %>% summarise_all(min, na.rm = TRUE)
  }) %>%
  ungroup() %>%
  as.data.frame()

write.csv(
  dcast(
    p_use,
    `Area Unit` + `Area Group` ~ `Crop Group`, 
    value.var = "P Use"), 
  file = "data-raw/base year 2014/p use.csv", 
  row.names = FALSE)

write.csv(
  crops_base,
  file = "data-raw/base year 2014/crop production.csv",
  row.names = FALSE)

write.csv(
  default_rates,
  file = "data-raw/base year 2014/p application rate default.csv",
  row.names = FALSE)