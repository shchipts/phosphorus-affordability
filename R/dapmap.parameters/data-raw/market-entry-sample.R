library(dapmap.markets)
library(dplyr)
library(reshape2)

# Excludes import flows smaller than 1% of total import flows.
# Excluded volume is added to domestic supply. Total consumption by region and 
# year in corrected data is equal to total consumption in raw data.
markets_corrected <- dapmap.markets %>%  
  group_by(Year) %>%
  group_modify(~ {
    
    volumes <- .x %>%
      filter(Producer != "Home and Other Imports") %>%
      select(-Producer)
    
    thresholds <- unname(colSums(volumes)) / 100
    
    corrected <- Reduce(
      function(s, i){
        col <- volumes[i] %>%
          mutate_all(list(~ ifelse(. > thresholds[i], ., 0)))
        
        if (is.null(s)) col else cbind(s, col)
      },
      1 : ncol(volumes),
      init = NULL)
    
    home_volumes <- .x %>%
      filter(Producer == "Home and Other Imports") %>%
      select(-Producer) + colSums(volumes) - colSums(corrected)
    
    return (cbind(
      .x %>% select(Producer),
      rbind(corrected, home_volumes)))
  }) %>%
  ungroup() %>%
  relocate(Producer, Year) %>%
  as.data.frame()

market_entry <- markets_corrected %>%
  melt(id = c("Producer", "Year")) %>%
  rename(Region = variable, Flow = value) %>%
  filter(Flow != 0) %>%
  group_by(Year) %>%
  mutate(World = sum(Flow)) %>%
  ungroup() %>%
  group_by(Region, Year) %>%
  mutate(Market = sum(Flow)) %>%
  group_modify(
    ~ .x %>% 
      mutate(
        Home = sum(
          .x %>% 
            filter(Producer == "Home and Other Imports") %>%
            pull(Flow)))) %>%
  ungroup() %>%
  filter(Producer != "Home and Other Imports") %>%
  mutate(`Market Price` = (Home + World - Market) / World) %>%
  group_by(Year, Producer) %>%
  mutate(`Producer Price` = min(`Market Price` - Flow / World)) %>%
  ungroup() %>%
  mutate(Tau = (`Market Price` - Flow / World - `Producer Price`)) %>%
  as.data.frame() %>%
  dcast(Year + Producer ~ Region, value.var = "Tau") %>%
  arrange(Producer, Year)

year <- 2014
region <- "Latin America"

data_markets <- markets_corrected %>%
  melt(id = c("Year", "Producer")) %>%
  rename(Region = variable, Volume = value) %>%
  group_by(Year, Region) %>%
  group_modify(~ .x %>% mutate(Market_Volume = sum(Volume))) %>%
  ungroup() %>%
  group_by(Year) %>%
  mutate(World = sum(Volume)) %>%
  ungroup() %>%
  filter(Producer != "Home and Other Imports") %>%
  mutate(Market_Share = Market_Volume / World) %>%
  group_by(Producer) %>%
  group_modify(
    ~ .x %>% 
      mutate(
        Base = .x %>%
          filter(Year == year & Region == region) %>% 
          pull(Market_Share))) %>%
  ungroup() %>%
  group_by(Year, Producer) %>%
  group_modify(
    ~ .x %>% 
      mutate(
        Index = Base / .x %>% filter(Region == region) %>% 
          pull(Market_Share))) %>%
  ungroup() %>%
  mutate(Real_Market_Share = Market_Share * Index) %>%
  as.data.frame()

data <- market_entry %>%
  melt(id = c("Year", "Producer")) %>%
  rename(Region = variable, Tau = value) %>%
  filter(!is.na(Tau)) %>%
  filter(!(Producer == "Maaden" & Year == 2013)) %>%
  group_by(Year, Producer) %>%
  group_modify(
    ~ .x %>% 
      mutate(
        Tau_Ref = .x %>% 
          filter(Region == region) %>% 
          pull(Tau)) %>%
      mutate(Tau_Scaled = Tau - Tau_Ref)) %>%
  ungroup() %>%
  select(Year, Producer, Region, Tau_Scaled) %>%
  left_join(
    data_markets %>%
      select(Year, Producer, Region, Real_Market_Share),
    by = c("Year", "Producer", "Region"))

data_response <- data %>%
  group_by(Producer, Region) %>%
  mutate(n = n()) %>%
  ungroup() %>%
  filter(n > 1) %>%
  filter(Tau_Scaled != 0) %>%
  group_by(Producer, Region) %>%
  group_modify(~ {
    ref <- .x[1, ]
    
    .x %>% 
      filter(Year != ref$Year) %>%
      mutate(
        Diff_Tau = Tau_Scaled - ref$Tau_Scaled,
        Diff_Real_Market_Share = Real_Market_Share - ref$Real_Market_Share)
  }) %>%
  ungroup() %>%
  select(-n) %>%
  as.data.frame()

data_reference <- data %>%
  group_by(Producer, Region) %>%
  group_modify(~ {
    if (year %in% (.x %>% pull(Year)))
      .x %>% filter(Year == year)
    else .x[1, ]
  }) %>%
  ungroup() %>%
  as.data.frame()       

data_base <- data_markets %>%
  filter(Year == year & Region == region) %>%
  select(c(Year, Region, Market_Share)) %>%
  slice(1 : 1)

write.csv(
  data_response, 
  file = "data-raw/market entry sample/market entry response.csv", 
  row.names = FALSE)

write.csv(
  data_reference, 
  file = "data-raw/market entry sample/market entry reference point.csv", 
  row.names = FALSE)

write.csv(
  data_base, 
  file = "data-raw/market entry sample/base market.csv", 
  row.names = FALSE)