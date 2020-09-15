library(dapmap.markets)
library(dplyr)
library(reshape2)

n_boot <- 1000

# means of producers' market shares and observed disturbance terms
data <- dapmap.markets %>%
  melt(id = c("Year", "Producer")) %>%
  group_by(Year, Producer) %>%
  summarise_if(is.numeric, sum) %>%
  ungroup() %>%
  group_by(Year) %>%
  mutate(across(is.numeric, ~ .x / sum(.x))) %>%
  ungroup() %>%
  filter(Producer != "Home and Other Imports") %>%
  group_by(Producer) %>%
  mutate(avr = mean(value), diff = value - mean(value)) %>%
  ungroup() %>%
  select(-c(Year, value)) %>%
  as.data.frame()

# centered residuals from the joint sample of disturbance terms
r_raw <- pull(data, diff)
r <- r_raw - mean(r_raw)

# means of producers' market shares
means <- data %>%
  select(Producer, avr) %>%
  group_by(Producer) %>%
  summarise_all(first) %>%
  ungroup() %>%
  as.data.frame() %>%
  dcast(. ~ Producer, value.var = "avr") %>%
  select(-.)

# wild bootstrap resampling
bootstrap_r <- replicate(
  n_boot, 
  sample(
    r * replicate(length(r), sample(c(-1, 1), size = 1)), 
    size = ncol(means), 
    replace = TRUE))

# bootstrap market shares
bootstrap_sample <- Reduce(
  function(seed, i)(
    rbind(seed, means + bootstrap_r[, i])),
  1 : n_boot,
  init = data.frame())

# bootstrap capacities
bootstrap.supply <- read.csv("data-raw/bootstrap-demand.csv") %>%
  group_by(Scenario) %>%
  group_modify(~ {
    world_demand <- .x %>% mutate(World = rowSums(.)) %>% pull(World)
    
    return (bootstrap_sample %>% 
              mutate_all( ~ round(. * world_demand)))
  }) %>%
  ungroup() %>%
  as.data.frame()

write.csv(
  bootstrap.supply, 
  file = "data-raw/bootstrap-supply.csv", 
  row.names = FALSE)
usethis::use_data(bootstrap.supply, overwrite = TRUE)