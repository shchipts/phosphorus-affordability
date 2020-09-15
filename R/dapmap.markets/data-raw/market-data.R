library(dplyr)

# load regions
d <- read.csv("data-raw/regions.csv", check.names = FALSE)

regions <- Reduce(
  function(seed, x) {
    
    values <- list(as.character(filter(d, Region == x)[, 2]))
    names(values) <- c(x)
    
    return (append(seed, values))
  },
  sort(unique(as.character(d[, 1]))),
  init = list())
regions <- append(
  regions, 
  list("East Asia" = append(
    regions[["China"]], 
    regions[["East Asia (excl. China)"]])))
regions["China"] <- NULL
regions["East Asia (excl. China)"] <- NULL

# load regional trade
trade <- read.csv(
  "data-raw/comtrade regional sales volume.csv", 
  check.names = FALSE) %>%
  filter(`Comtrade Reports` == "Import")
trade['East Asia'] = Reduce(
  function(s, x)(s + trade[, x]), 
  c("China", "East Asia (excl. China)"), 
  init = rep(0, nrow(trade)))
trade <-  trade %>% 
  select(-c(append(c("China", "East Asia (excl. China)"), "Comtrade Reports")))

# load other dapmap.markets
totals <- read.csv("data-raw/comtrade total trade.csv", check.names = FALSE)
sales <- read.csv("data-raw/companies sales.csv", check.names = FALSE)
in.region <- read.csv("data-raw/companies.csv", check.names = FALSE)
consumption <- read.csv(
  "data-raw/ifa supply db regional consumption.csv", 
  check.names = FALSE) %>%
  filter(Year %in% 2013 : 2017) %>%
  select(-c("Year"))


# compile trade dapmap.markets
get.home.region <- function(tag)(
  as.character((in.region %>% filter(Company == tag))$`Home Region`[[1]]))

phosagro <- "PhosAgro/EuroChem"
phosagro.dapmap.markets <- trade %>% filter(Exporter == phosagro)
phosagro.home <- get.home.region(phosagro)
phosagro.dapmap.markets[, phosagro.home] <- phosagro.dapmap.markets[, phosagro.home] + 
  (sales %>% filter(Exporter == phosagro))$Sales - 
  (totals %>% filter(Exporter == phosagro & 
                       `Comtrade Reports` == "Export"))[, "Sales Volume"]

mosaic <- "Mosaic"
mosaic.dapmap.markets <- trade %>% filter(Exporter == mosaic)
mosaic.dapmap.markets[, get.home.region(mosaic)] <- 
  (sales %>% filter(Exporter == mosaic))$Sales - 
  (sales %>% filter(Exporter == mosaic))$Exports

dapmap.markets <- trade %>% 
  filter(Exporter %in% c("OCP", "Maaden", "China (export)")) %>%
  rbind(phosagro.dapmap.markets, mosaic.dapmap.markets)
  
dapmap.markets <- dapmap.markets[, append(c("Exporter", "Year"), colnames(consumption))]

years <- sort(unique(dapmap.markets$Year))
global.supply <- Reduce(
  function(s, y) {
    
    d <- as.data.frame(
      t(
        colSums(
          dapmap.markets %>% 
            filter(Year == y) %>% 
            select(-c("Year", "Exporter")))))
    
    return (rbind(s, d))
  },
  years,
  init = data.frame())

home.dapmap.markets <- cbind(
  data.frame(
    Exporter = rep("Home and Other Imports", length(years)),
    Year = years),
  consumption - global.supply)

dapmap.markets <- rbind(dapmap.markets, home.dapmap.markets)

cols <- colnames(dapmap.markets)
cols[cols == "Exporter"] <- "Producer"
colnames(dapmap.markets) <- cols

write.csv(
  dapmap.markets,
  file = "data-raw/dapmap-markets.csv", 
  row.names = FALSE)
usethis::use_data(dapmap.markets, overwrite = TRUE)