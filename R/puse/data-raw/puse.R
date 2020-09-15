library(dplyr)
library(reshape2)

get_data <- function(path, col)(
  read.csv(path, check.names = FALSE) %>%
    melt(id = c("Area Unit", "Area Group")) %>%
    rename(`Crop Group` = variable, !!col := value))

base_data <- get_data("data-raw/base year 2014/p use.csv", "Base P Use") %>%
  left_join(
    get_data("data-raw/base year 2014/crop production.csv", "Base Production"),
    by = c("Area Unit", "Area Group", "Crop Group")) %>%
  left_join(
    read.csv(
      "data-raw/classifications/area unit classification.csv", 
      check.names = FALSE) %>% select(-`IFA Unit`), 
    by = c("Area Unit", "Area Group"))

init_rates <- read.csv(
  "data-raw/base year 2014/p application rate default.csv", 
  check.names = FALSE)

crops <- read.csv("data-raw/crops-projections.csv", check.names = FALSE) %>%
  rename(id = Scenario) %>%
  rbind(
    read.csv("data-raw/crops-observations.csv", check.names = FALSE) %>%
      mutate(id = as.character(Year)) %>%
      select(-Year)) %>%
  melt(id = c("Area Unit", "Area Group", "id")) %>%
  rename(`Crop Group` = variable, Production = value)

puse <- Reduce(
  function(seed, id) {

    d <- base_data %>%
      inner_join(
        crops %>% 
          filter(id == !!id),
        by = c("Area Unit", "Area Group", "Crop Group"))
  
    base_p_use <- pull(d, `Base P Use`)
    base_production <- pull(d, `Base Production`)
    production <- pull(d, Production)
    crop <- pull(d, `Crop Group`)
    region <- pull(d, Region)
  
    # P use is estimaated based on the assumption that I/O relationship between 
    # p use and crop production by country-region present in 2014 remains 
    # constant as in baseline scenario in Daberkow, S., Poulisse, J., & 
    # Vroomen, H, (2000).
    # If crop was not produced in 2014, then default p application rate is used.
    # Daberkow, S., Poulisse, J., & Vroomen, H, (2000). Fertlizer Requirements in 2015 and 2030. FAO.
    p_use <- sapply(
      1 : length(base_p_use),
      function(i)(
        case_when(
          production[i] == 0 ~ 0,
          is.na(base_p_use[i]) ~ init_rates %>%
            filter(`Crop Group` == crop[i] & Region == region[i]) %>%
            pull(`P Rate`) * production[i],
          TRUE ~ base_p_use[i] *
            (1 + (production[i] - base_production[i]) / base_production[i]))))
  
    cols <- d %>%
      mutate(`P Use` = p_use) %>%
      select(c(Region, `P Use`)) %>%
      group_by(Region) %>%
      group_modify(~ .x %>% summarise_all(sum)) %>%
      ungroup() %>%
      rename(!!id := `P Use`) %>%
      as.data.frame() %>%
      melt(id = "Region") %>%
      dcast(variable ~ Region, value.var = "value") %>%
      rename(Id = variable)
  
    rbind(seed, cols)
  },
  unique(as.character(pull(crops, id))),
  init = NULL)

write.csv(puse, file = "data-raw/puse.csv", row.names = FALSE)
usethis::use_data(puse, overwrite = TRUE)
