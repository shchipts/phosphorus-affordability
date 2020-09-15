# dapmap.markets

This package contains two datasets

* `dapmap.markets`: DAP/MAP fertilizer trade volumes by IFA region 2013-2017

   Sources: 
   - UN Comtrade data accessed from https://comtrade.un.org/
   - IFA Supply Database accessed from https://www.ifastat.org/supply/Phosphate\%20Products/Processed\%20Phosphates
   - data announced by global phosphate companies accessed from https://www.maaden.com.sa/, http://www.mosaicco.com/, https://phosagro.com/, https://www.eurochemgroup.com/, https://www.ocpgroup.ma/

* `dapmap.consumption`: DAP/MAP consumption by region 2007-2018

   Sources: 
   - IFA Supply Database accessed from https://www.ifastat.org/supply/Phosphate\%20Products/Processed\%20Phosphates
   
## Installation

```R
# Install the development version from GitHub
devtools::install_github("shchipts/phosphorus-affordability", subdir = "R/dapmap.markets")
```

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)