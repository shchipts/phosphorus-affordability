# dapmap.parameters

This package contains three datasets with bootstrap samples

* `bootstrap.demand`: DAP/MAP fertilizer demand by IFA region in 2030 scenarios
* `bootstrap.supply`: DAP/MAP fertilizer supply by IFA region in 2030 scenarios
* `bootstrap.costs`: Market entry by international supplier and IFA region in 2030 scenarios

Scenarios:
- Business as Usual
- Stratified Societies
in FAO. (2018). The future of food and agriculture - Alternative pathways to 2050.

Suppliers:
- Chinese exporters
- Maaden https://www.maaden.com.sa/
- Mosaic http://www.mosaicco.com/
- OCP https://www.ocpgroup.ma/
- PhosAgro/EuroChem  https://phosagro.com/ https://www.eurochemgroup.com/
  
IFA regions https://www.ifastat.org/:
- Africa
- East Asia
- Eastern Europe and Central Asia
- Latin America
- North America
- Oceania
- South Asia
- Western and Central Europe
- Western Asia
   
## Installation

```R
# Install the development version from GitHub
devtools::install_github("shchipts/phosphorus-affordability", subdir = "R/dapmap.parameters")
```

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)