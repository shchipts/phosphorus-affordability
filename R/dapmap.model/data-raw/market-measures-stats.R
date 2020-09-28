library(dplyr)
library(reshape2)

n_boot <- 200

readf <- function(path, measure) (
  read.csv(path, check.names = FALSE) %>%
    melt(id.vars = c("Scenario", "simulation")) %>%
    rename(Node = variable) %>%
    mutate(Measure = measure))

measures_stats.simulated <- 
  readf("data-raw/concentration-simulated.csv", "concentration") %>%
  rbind(readf("data-raw/diversification-simulated.csv", "diversification")) %>%
  rbind(readf("data-raw/self_sufficiency-simulated.csv", "self-sufficiency")) %>%
  select(-simulation) %>%
  group_by(Scenario, Measure, Node) %>%
  group_modify(~ {
    
    values <- pull(.x, value)
    k <- length(values)
    
    se <- function(f){
      
      x <- replicate(n_boot, f(sample(values, k, replace = TRUE)))
      
      return (sqrt(sum((x - sum(x) / n_boot) ^ 2) / (n_boot - 1)))
    }
    
    quantilef <- function(z, p)(unname(quantile(z, probs = c(p))))
    
    return (data.frame(
      Mean = mean(values), 
      Mean_SE = se(mean),
      Q_1 = quantilef(values, 0.25),
      Q_1_SE = se(function(y)(quantilef(y, 0.25))),
      Q_2 = quantilef(values, 0.5),
      Q_2_SE = se(function(y)(quantilef(y, 0.5))),
      Q_3 = quantilef(values, 0.75),
      Q_3_SE = se(function(y)(quantilef(y, 0.75))),
      SD = sd(values),
      SD_SE = se(function(y)(sd(y)))))
  }) %>%
  ungroup() %>%
  relocate(Scenario, Node, Measure) %>%
  as.data.frame()

write.csv(
  measures_stats.simulated,
  file = "data-raw/measures_stats-simulated.csv",
  row.names = FALSE)
usethis::use_data(measures_stats.simulated, overwrite = TRUE)