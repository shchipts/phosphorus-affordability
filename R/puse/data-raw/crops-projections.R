library(dplyr)
library(reshape2)

regions_data <- read.csv(
  "data-raw/classifications/FAO GAPS countries classification.csv", 
  check.names = FALSE) %>% 
  arrange(`Area Unit`)
crops_data <- read.csv(
  "data-raw/classifications/IFA crops classification.csv", 
  check.names = FALSE)


scenarios <- c("Business As Usual", "Stratified Societies")

# Food and agriculture projections to 2050: Crop production 2030
# From http://www.fao.org/fileadmin/user_upload/global-perspective/csv/FOFA2050CountryData_Crop-production.csv.zip
# FAO. 2018. The future of food and agriculture - Alternative pathways to 2050. Rome.
data <- read.csv("data-raw/FOFA2050CountryData_Crop-production.csv") %>%
  select(-c(Domain, CountryCode, Region, Units)) %>%
  filter(Year == 2030) %>%
  filter(Scenario %in% scenarios) %>%
  filter(Indicator %in% c("Crop yield", "Harvested area")) %>%
  group_by(Scenario, Year, CountryName, Item) %>%
  group_modify(~{
    
    get_value <- function(k){
      
      d <- .x %>% filter(Element == k)
      
      case_when(
        nrow(d) == 0 ~ 0,
        nrow(d) == 2 ~ d %>% pull(Value) %>% prod)
    }
    
    data.frame(
      Production = (get_value("Rainfed") + get_value("Irrigated")) * 10 ^3)
  }) %>%
  ungroup() %>%
  left_join(regions_data, by = c("CountryName" = "FAO GAPS")) %>%
  left_join(crops_data, by = c("Item" = "FAO GAPS")) %>%
  group_by(`Crop Group`, `Area Unit`, `Area Group`, Scenario) %>%
  group_modify(~{
    .x %>% summarise(Production = sum(Production, na.rm = TRUE)) }) %>%
  ungroup() %>%
  dcast(
    `Area Unit` + `Area Group` + Scenario ~ `Crop Group`, 
    value.var = "Production") %>%
  mutate_all(~ replace(., is.na(.), 0)) %>%
  select(
    c(
      Scenario,
      `Area Unit`, 
      `Area Group`,
      Wheat, 
      Rice, 
      Maize, 
      `Other Cereals`,
      Soybean,
      `Oil Palm`,
      `Other Oilseeds`,
      `Fibre Crops`,
      `Sugar Crops`,
      `Roots and Tubers`,
      Fruits,
      Vegetables)) %>%
  as.data.frame()

write.csv(data, file = "data-raw/crops-projections.csv", row.names = FALSE)
