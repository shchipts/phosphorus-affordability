library(dplyr)
library(reshape2)

concentration <- read.csv(
  "data-raw/concentration-simulated.csv", 
  check.names = FALSE)
diversification <- read.csv(
  "data-raw/diversification-simulated.csv", 
  check.names = FALSE)

sapply(
  c("Business As Usual", "Stratified Societies"),
  function(scenario) {
    
    data1 <- concentration %>% 
      filter(Scenario == scenario) %>%
      select(-c(Scenario, simulation)) %>%
      melt(id = NULL) %>% 
      rename(Region = variable) %>%
      group_by(Region) %>%
      summarise_at(
        vars(value),
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
      file = paste("data-raw/stats/concentration ", scenario, ".csv", sep = ""),
      row.names = FALSE)
    
    data2 <- diversification %>% 
      filter(Scenario == scenario) %>%
      select(-c(Scenario, simulation)) %>%
      melt(id = NULL) %>% 
      rename(Producer = variable) %>%
      group_by(Producer) %>%
      summarise_at(
        vars(value),
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
      data2,
      file = paste("data-raw/stats/diversification ", scenario, ".csv", sep = ""),
      row.names = FALSE)
  })