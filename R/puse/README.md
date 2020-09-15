# puse

This package contains two datasets

* `puse`: Estimates of phosphorus use in agricultural crop production by IFA region in 2007-2018, and in 2030 scenarios
  This compilation provides records on the regional phosphorus (P) use in crop production based on the IFA-IPNI assessment of fertilizer use 2014-2014/15 (source: IFA, & IPNI. (2017). Assessment of Fertilizer Use by Crop at the Global Level 2014-2014/15. https://www.ifastat.org/plant-nutrition). 
  The compilation covers FAOSTAT crop production data (FAOSTAT Crops database (2020). http://www.fao.org/faostat/en/#data/QC) for years 2007 to 2018, and
  FAO "Business as Usual" and "Stratified Societies" scenarios crop production (source: FAO. 2018. The future of food and agriculture - Alternative pathways to 2050. Rome) data for year 2030.

* `pconsumption`: Phosphorus consumption in agriculture by region
  This compilation provides records on the regional phosphorus (P) consumption in agriculture derived from the IFA Consumption database (source: IFASTAT Consumption database (2020). https://www.ifastat.org/databases/plant-nutrition).
   
## Installation

```R
# Install the development version from GitHub
devtools::install_github("shchipts/phosphorus-affordability", subdir = "R/puse")

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)