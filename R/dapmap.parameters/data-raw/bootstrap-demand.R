library(dapmap.markets)
library(puse)
library(dplyr)
library(reshape2)

n_boot <- 1000

# data smoothing using a central moving average with span 3
smoothing <- function(d, col) {
  
  raw <- d %>% 
    filter(Year %in% 2007 : 2017) %>%
    mutate(Year = as.numeric(as.character(Year)))
  
  return (raw %>% 
            select(Year) %>% 
            slice(2 : (n() - 1)) %>%
            cbind(
              Reduce(
                function(s, row){
                  rbind(
                    s, 
                    (raw %>% select(-Year))[(row - 1) : (row + 1), ] %>%
                      summarise_all(mean))
                },
                2 : (nrow(raw) - 1),
                init = data.frame())) %>%
            melt(id = "Year") %>%
            rename(!!col := value, Region = variable))
}

regress <- function(d, z_new, full_output = FALSE) {
  
  reduced <- lm(x ~ z + 0, data = d)
  structural <- lm(
    y ~ x_hat + 0, 
    data = cbind(d, "x_hat" = reduced$fitted.values))
  
  n_reg <- nrow(d)
  l_reg <- length(reduced$coefficients)
  
  output <- list(
    "coef_structural" = as.numeric(structural$coefficients),
    "coef_reduced" = as.numeric(reduced$coefficients),
    "y_forecast" = as.numeric(
      structural$coefficients * (reduced$coefficients * z_new)))
  
  if (isTRUE(full_output)) {
    
    corrected_e1 <- sqrt(n_reg / (n_reg - l_reg)) * 
      (reduced$residuals - mean(reduced$residuals))
    centered_e2 <- structural$residuals - mean(structural$residuals)
    
    append(
      output, 
      list(
        "residuals_reduced" = as.numeric(corrected_e1),
        "residuals_structural" = as.numeric(centered_e2)))
  }
  else output
}

# wild bootstrap
get_residuals <- function(x)(
  sample(
    x * replicate(length(x), sample(c(-1, 1), size = 1)), 
    replace = TRUE))
get_simulation_residuals <- function(x)(
  sample(
    x * replicate(length(x), sample(c(-1, 1), size = 1)), 
    size = 1, 
    replace = TRUE))

data_all <- puse %>%
  filter(!(Id %in% c("Business As Usual", "Stratified Societies"))) %>%
  rename(Year = Id) %>%
  smoothing("z") %>%
  left_join(smoothing(pconsumption, "x"), by = c("Year", "Region")) %>%
  left_join(smoothing(dapmap.consumption, "y"), by = c("Year", "Region"))

bootstrap.demand <- Reduce(
  function(seed1, scenario) {
    
    data_scenario_all <- puse %>%
      filter(Id == scenario) %>%
      rename(Year = Id) %>%
      melt(id = "Year") %>%
      rename(z_new = value, Region = variable)
    
    results <- Reduce(
      function(seed2, region) {
        
        data <- data_all %>% 
          filter(Region == region) %>% 
          select(-c(Year, Region))
        
        z_scenario <- data_scenario_all %>%
          filter(Region == region) %>%
          pull(z_new)
        
        # observed 2SLS estimates  
        estimates <- regress(data, z_scenario, full_output = TRUE)
        
        bootstrap <- Reduce(
          function(s, i){
            # wild unrestricted residual bootstrap
            bootstrap_r1 <- get_residuals(estimates$residuals_reduced)
            bootstrap_r2 <- get_residuals(estimates$residuals_structural)
            
            simulation_r1 <- get_simulation_residuals(estimates$residuals_reduced)
            simulation_r2 <- get_simulation_residuals(estimates$residuals_structural)
            
            
            bootstrap_data <- data %>%
              mutate(x = estimates$coef_reduced * z + bootstrap_r1) %>%
              mutate(y = estimates$coef_structural * x + bootstrap_r2)
            
            bootstrap_lm <- regress(bootstrap_data, z_scenario)
            
            x_new <- bootstrap_lm$coef_reduced * z_scenario + simulation_r1
            y_new <- bootstrap_lm$coef_structural * x_new + simulation_r2
            
            rbind(s, data.frame("Simulation" = y_new))
          },
          1 : n_boot,
          init = data.frame())
        
        simulations <- bootstrap %>% 
          select(Simulation) %>% 
          rename(!!as.character(region) := Simulation)
        
        if (nrow(seed2) == 0)
          simulations
        else cbind(seed2, simulations)
      },
      unique(pull(data_all, Region)),
      init = data.frame())
    
    return (rbind(
      seed1, 
      results %>%
        mutate_all(~ round(. / 10 ^ 3)) %>%
        mutate(Scenario = scenario) %>%
        select(Scenario, everything())))
  },
  c("Business As Usual", "Stratified Societies"),
  init = NULL)

write.csv(bootstrap.demand, file = "data-raw/bootstrap-demand.csv", row.names = FALSE)
usethis::use_data(bootstrap.demand, overwrite = TRUE)