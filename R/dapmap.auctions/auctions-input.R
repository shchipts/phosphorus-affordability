library(dapmap.parameters)
library(dplyr)

scenarios <- c("Business As Usual", "Stratified Societies")

sapply(
  scenarios,
  function(scenario) {
    
    if (!dir.exists(scenario))
      dir.create(scenario)
    
    write.csv(
      bootstrap.demand %>%
        filter(Scenario == scenario) %>%
        select(-Scenario),
      file = file.path(scenario, "demand.csv"),
      row.names = FALSE)
    
    write.csv(
      bootstrap.supply %>%
        filter(Scenario == scenario) %>%
        select(-Scenario),
      file = file.path(scenario, "supply.csv"),
      row.names = FALSE)
    
    sapply(
      unique(as.character(bootstrap.costs %>% pull (Region))),
      function(region) (
        write.csv(
          bootstrap.costs %>%
            filter(Region == region & 
                     Scenario == scenario) %>%
            select(-c(Region, Scenario, Simulation)) %>%
            select_if(~ !all(is.na(.))),
          file = file.path(scenario, paste(region, ".csv", sep = "")),
          row.names = FALSE)))
  })