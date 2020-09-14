library(dplyr)
library(reshape2)

ifa_data <- read.csv(
  "data-raw/classifications/IFA crops classification.csv", 
  check.names = FALSE) %>%
  left_join(
    read.csv(
      "data-raw/classifications/FAO GAPS crops classification.csv", 
      check.names = FALSE), 
    "FAO GAPS") %>%
  select(-`FAO GAPS`)

regions_data <- read.csv(
  "data-raw/classifications/FAOSTAT countries classification.csv", 
  check.names = FALSE)

# FAOSTAT: Crops production 2007-2018
# From http://www.fao.org/faostat/en/#data/QC
data <- Reduce(
  function(seed, year) {
    
    input <- paste(
      "data-raw/faostat crops data/FAOSTAT Crops Production", 
      " ", 
      year, 
      ".csv", 
      sep = "")
    
    d <- read.csv(input, check.names = FALSE) %>%
      select(Area, Item, Value) %>%
      filter(Area != "China") %>%
      left_join(ifa_data, by = c("Item" = "FAOSTAT Crops")) %>%
      left_join(regions_data, by = c("Area" = "FAOSTAT")) %>%
      select(-c(Area, Item)) %>%
      group_by(`Area Unit`, `Area Group`, `Crop Group`) %>%
      group_modify(~ .x %>% summarise(Value = sum(Value, na.rm = TRUE))) %>%
      ungroup() %>%
      dcast(`Area Unit` + `Area Group` ~ `Crop Group`, value.var = "Value") %>%
      mutate_all(~ replace(., is.na(.), 0)) %>%
      mutate(Year = year) %>%
      select(
        c(
          Year,
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
    
    return (rbind(seed, d))
  },
  2007 : 2018,
  init = NULL)

write.csv(data, file = "data-raw/crops-observations.csv", row.names = FALSE)
