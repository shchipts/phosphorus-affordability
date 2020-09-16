library(dplyr)
library(reshape2)

demand <- read.csv("data-raw/bootstrap-demand.csv", check.names = FALSE)
supply <- read.csv("data-raw/bootstrap-supply.csv", check.names = FALSE)

sapply(
  c("Business As Usual", "Stratified Societies"),
  function(scenario) {
    
    data1 <- demand %>% 
      filter(Scenario == scenario) %>%
      select(-Scenario) %>%
      melt(id = NULL) %>% 
      rename(simulation := value, Region = variable) %>%
      group_by(Region) %>%
      summarise_at(
        vars(simulation),
        list(
          mean = ~ mean(.),
          q05 = ~ quantile(., probs = .05),
          q10 = ~ quantile(., probs = .10),
          q25 = ~ quantile(., probs = .25),
          q50 = ~ quantile(., probs = .50),
          q75 = ~ quantile(., probs = .75),
          q90 = ~ quantile(., probs = .90),
          q95 = ~ quantile(., probs = .95))) %>%
      mutate(quartile_dispersion = (q75 - q25) / (q75 + q25)) %>%
      ungroup() %>%
      as.data.frame()
    
    write.csv(
      data1,
      file = paste("data-raw/stats/demand ", scenario, ".csv", sep = ""),
      row.names = FALSE)
    
    world_demand <- demand %>% 
      filter(Scenario == scenario) %>%
      select(-Scenario) %>%
      mutate(World = rowSums(.)) %>% 
      pull(World)
    
    data2 <- supply %>% 
      filter(Scenario == scenario) %>%
      select(-Scenario) %>%
      mutate_all( ~ . / world_demand) %>%
      melt(id = NULL) %>% 
      rename(Producer = variable) %>%
      group_by(Producer) %>%
      summarise_all(list(mean = mean, sd = sd)) %>%
      ungroup() %>%
      as.data.frame()
    
    write.csv(
      data2,
      file = paste("data-raw/stats/supply ", scenario, ".csv", sep = ""),
      row.names = FALSE)
    
    data3 <- read.csv("data-raw/bootstrap-costs.csv", check.names = FALSE) %>%
      filter(Scenario == scenario) %>%
      select(-c(Scenario, Simulation)) %>%
      melt(id = "Region") %>%
      rename(Producer = variable) %>%
      filter(!is.na(value)) %>%
      group_by(Producer, Region) %>%
      summarise_all(
        list(
          mean = mean,
          sd = sd,
          q05 = ~ quantile(., probs = .05),
          q10 = ~ quantile(., probs = .10),
          q25 = ~ quantile(., probs = .25),
          q50 = ~ quantile(., probs = .50),
          q75 = ~ quantile(., probs = .75),
          q90 = ~ quantile(., probs = .90),
          q95 = ~ quantile(., probs = .95))) %>%
      mutate(quartile_dispersion = (q75 - q25) / (q75 + q25)) %>%
      ungroup() %>%
      arrange(Producer, Region) %>%
      as.data.frame()
    
    write.csv(
      data3, 
      file = paste("data-raw/stats/costs ", scenario, ".csv", sep = ""), 
      row.names = FALSE)
  })