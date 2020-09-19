library(dapmap.markets)
library(dapmap.parameters)
library(dplyr)
library(reshape2)

concentration <- function(data) {
  
  n <- length(unique(data[, 1]))
  
  return (data %>%
    select(-c(1)) %>%
    group_by_at(1) %>%
    summarise_all(~ (sum((. / sum(.)) ^ 2) - 1 / n) / (1 - 1 / n)) %>%
    ungroup() %>%
    as.data.frame())
}

diversification <- function(data) {
  
  id <- colnames(data)[2]
  labels <- c("tag", id)
  colnames(data) <- append(labels, tail(colnames(data), -2))

  data %>%
    filter(tag != "Home and Other Imports") %>%
    melt(id.vars = labels) %>%
    dcast(paste("variable +", id, "~ tag"), value.var = "value") %>%
    concentration() %>%
    mutate_at(-1, ~ 1 - .)
}

bundle <- Reduce(
  function(seed, scenario) {
    
    readf <- function(file)(
      read.csv(
        paste("data-raw/", scenario, "/", file, sep = ""),
        check.names = FALSE) %>%
        select(-iteration))
    
    filterf <- function(d)(
      d %>%
        filter(Scenario == scenario) %>%
        select(-Scenario))
    
    demand <- bootstrap.demand %>%
      filterf() %>%
      mutate(simulation = 1 : n()) %>%
      melt(id.vars = "simulation") %>%
      rename(region = variable, market_size = value) %>%
      group_by(simulation) %>%
      mutate(total_size = sum(market_size)) %>%
      ungroup() %>%
      as.data.frame()
    
    supply <- bootstrap.supply %>%
      filterf() %>%
      mutate(simulation = 1 : n()) %>%
      melt(id.vars = "simulation") %>%
      rename(producer = variable, capacity = value) %>%
      as.data.frame()
    
    entry <- bootstrap.costs %>%
      filterf() %>%
      melt(id.vars = c("Simulation", "Region")) %>%
      rename(
        simulation = Simulation, 
        region = Region, 
        producer = variable,
        tau = value) %>%
      left_join(
        readf("bootstrap suppliers.csv") %>%
          melt(id.vars = "simulation") %>%
          rename(producer = variable, producer_price = value),
        by = c("simulation", "producer")) %>%
      filter(!is.na(tau)) %>%
      mutate(entry = producer_price + tau) %>%
      select(-c(tau, producer_price))
    
    markets <- entry %>%
      left_join(demand, by = c("simulation", "region")) %>%
      left_join(supply, by = c("simulation", "producer")) %>%
      left_join(
        readf("bootstrap markets.csv") %>%
          melt(id.vars = "simulation") %>%
          rename(region = variable, price = value),
        by = c("simulation", "region")) %>%
      mutate(volume = case_when(
        is.na(entry) ~ 0,
        price > entry ~ (price - entry) * total_size,
        TRUE ~ 0)) %>%
      mutate(volume = ifelse(capacity < volume, capacity, volume)) %>%
      group_by(simulation, region) %>%
      group_modify(~ rbind(
        .x %>% select(c(producer, volume)), 
        data.frame(
          producer = "Home and Other Imports", 
          volume = head(pull(.x, market_size), 1) - sum(pull(.x, volume))))) %>%
      ungroup() %>%
      as.data.frame() %>%
      dcast(producer + simulation ~ region, value.var = "volume") %>%
      mutate_at(vars(-producer, -simulation), ~ replace(., is.na(.), 0))
    
    return (list(
      rbind(
        seed[[1]],
        concentration(markets) %>%
          mutate(Scenario = scenario)),
      rbind(
        seed[[2]],
        diversification(markets) %>%
          mutate(Scenario = scenario))))
  },
  c("Business As Usual", "Stratified Societies"),
  init = list(NULL, NULL))

concentration.observed <- concentration(dapmap.markets)
diversification.observed <- diversification(dapmap.markets)

concentration.simulated <- select(bundle[[1]], Scenario, everything())
diversification.simulated <- select(bundle[[2]], Scenario, everything())

write.csv(
  concentration.observed,
  file = "data-raw/concentration-observed.csv",
  row.names = FALSE)
usethis::use_data(concentration.observed, overwrite = TRUE)

write.csv(
  diversification.observed,
  file = "data-raw/diversification-observed.csv",
  row.names = FALSE)
usethis::use_data(diversification.observed, overwrite = TRUE)

write.csv(
  concentration.simulated,
  file = "data-raw/concentration-simulated.csv",
  row.names = FALSE)
usethis::use_data(concentration.simulated, overwrite = TRUE)

write.csv(
  diversification.simulated,
  file = "data-raw/diversification-simulated.csv",
  row.names = FALSE)
usethis::use_data(diversification.simulated, overwrite = TRUE)