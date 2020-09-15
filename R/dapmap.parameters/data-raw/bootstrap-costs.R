library(dplyr)
library(reshape2)

base <- read.csv(
  "data-raw/market entry sample/base market.csv", 
  check.names = FALSE)
reference_points <- read.csv(
  "data-raw/market entry sample/market entry reference point.csv", 
  check.names = FALSE) %>% 
  select(-Year)
sample_diff <- read.csv(
  "data-raw/market entry sample/market entry response.csv", 
  check.names = FALSE) %>%
  select(c(Diff_Tau, Diff_Real_Market_Share))

demand <- read.csv("data-raw/bootstrap-demand.csv", check.names = FALSE)
n_boot <- nrow(demand)

# unrestricted wild residual bootstrap
k <- nrow(reference_points)
model <- lm(Diff_Real_Market_Share ~ Diff_Tau + 0, data = sample_diff)
r <- model$residuals - mean(model$residuals)
bootstrap_r <- replicate(
  n_boot, 
  sample(
    r * replicate(length(r), sample(c(-1, 1), size = 1)), 
    size = k, 
    replace = TRUE))

bootstrap.costs <- Reduce(
  function(seed, row) {
    
    data_demand <- demand %>%
      slice(row : row) %>%
      select(-Scenario) %>%
      melt(id = NULL) %>%
      rename(Region = variable, Demand = value) %>%
      mutate(Market_Share = Demand / sum(Demand))
    
    d <- data_demand %>%
      mutate(Index = pull(base, Market_Share) / data_demand %>%
               filter(Region == as.character(base$Region)) %>% 
               pull(Market_Share)) %>%
      mutate(Real_Market_Share_New = Market_Share * Index) %>%
      select(c(Region, Real_Market_Share_New)) %>%
      left_join(reference_points, by = "Region") %>%
      mutate(
        Tau_Diff = case_when(
          Tau_Scaled == 0 ~ 0,
          TRUE ~ model$coef * 
            (Real_Market_Share_New - Real_Market_Share) + bootstrap_r[, row])) %>%
      mutate(Tau_New = Tau_Scaled + Tau_Diff) %>%
      group_by(Producer) %>%
      mutate(Tau_New_Scaled = Tau_New - min(Tau_New)) %>%
      ungroup() %>%
      as.data.frame() %>%
      select(c(Region, Producer, Tau_New_Scaled)) %>%
      dcast(Region ~ Producer, value.var = "Tau_New_Scaled") %>%
      mutate(Scenario = demand[row, ]$Scenario) %>%
      select(Scenario, everything())
    
    return (rbind(seed, d))
  },
  1 : nrow(demand),
  init = NULL) %>%
  group_by(Scenario, Region) %>%
  mutate(Simulation = 1 : n()) %>%
  ungroup() %>%
  select(Simulation, everything()) %>%
  as.data.frame()

write.csv(
  bootstrap.costs, 
  file = "data-raw/bootstrap-costs.csv", 
  row.names = FALSE)
usethis::use_data(bootstrap.costs, overwrite = TRUE)


