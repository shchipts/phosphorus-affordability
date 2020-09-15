# dapmap.markets

This package contains two datasets

* `dapmap.markets`: DAP/MAP fertilizer trade volumes 2013-2017
   This compilation provides records on the regional DAP/MAP fertilizer trade volumes estimated from the UN Comtrade data (source: https://comtrade.un.org/), 
   IFA Supply Database (source: https://www.ifastat.org/supply/Phosphate\%20Products/Processed\%20Phosphates) 
   and data announced by global phosphate companies. 

* `dapmap.consumption`: DAP/MAP consumption by region 2007-2018
   This compilation provides records on the DAP/MAP fertilizer consumption derived from the IFA Supply Database (source: https://www.ifastat.org/supply/Phosphate\%20Products/Processed\%20Phosphates)
   
## Installation

```R
# Install the development version from GitHub
devtools::install_github("shchipts/phosphorus-affordability", subdir = "R/dapmap.markets")

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)