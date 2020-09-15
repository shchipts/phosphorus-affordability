library(dplyr)
library(reshape2)

demand <- read.csv("data-raw/bootstrap-demand.csv", check.names = FALSE)

sapply(
  c("Business As Usual", "Stratified Societies"),
  function(scenario) {
    
    data <- demand %>% 
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
      data,
      file = paste("data-raw/stats/demand ", scenario, ".csv", sep = ""),
      row.names = FALSE)
  })