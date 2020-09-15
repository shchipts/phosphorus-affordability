# puse

This package contains two datasets

* `puse`: Estimates of phosphorus use in agricultural crop production by IFA region in 2007-2018, and in 2030 scenarios

  Sources:
  - IFA, & IPNI. (2017). Assessment of Fertilizer Use by Crop at the Global Level 2014-2014/15 accessed from https://www.ifastat.org/plant-nutrition 
  - Crop production 2007-2018 in FAOSTAT Crops database (2020) accessed from http://www.fao.org/faostat/en/#data/QC
  - FAO "Business as Usual" and "Stratified Societies" scenarios crop production 2030 in FAO. (2018). The future of food and agriculture - Alternative pathways to 2050 accessed from http://www.fao.org/global-perspectives-studies/food-agriculture-projections-to-2050/en/

* `pconsumption`: Phosphorus consumption in agriculture by region
  
  Sources:
  - IFA Consumption database accessed from https://www.ifastat.org/databases/plant-nutrition
   
## Installation

```R
# Install the development version from GitHub
devtools::install_github("shchipts/phosphorus-affordability", subdir = "R/puse")
```

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)