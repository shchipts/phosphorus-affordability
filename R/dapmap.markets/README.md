# dapmap.markets

This package contains two datasets

* `dapmap.markets`: DAP/MAP fertilizer trade volumes by region 2013-2017

   Sources: 
   - UN Comtrade data accessed from https://comtrade.un.org/
   - IFA Supply Database accessed from https://www.ifastat.org/supply/Phosphate\%20Products/Processed\%20Phosphates
   - data announced by global phosphate companies accessed from https://www.maaden.com.sa/, http://www.mosaicco.com/, https://phosagro.com/, https://www.eurochemgroup.com/, https://www.ocpgroup.ma/

* `dapmap.consumption`: DAP/MAP consumption by region 2007-2018

   Sources: 
   - IFA Supply Database accessed from https://www.ifastat.org/supply/Phosphate\%20Products/Processed\%20Phosphates

## Notes

The following classifications is used:  
- regions (based on IFA regional classification https://www.ifastat.org/)  
  1\. Africa  
  2\. East Asia  
  3\. Eastern Europe and Central Asia  
  4\. Latin America  
  5\. North America  
  6\. Oceania  
  7\. South Asia  
  8\. Western and Central Europe  
  9\. Western Asia 
   
## Installation

```R
# Install the development version from GitHub
devtools::install_github("shchipts/phosphorus-affordability", subdir = "R/dapmap.markets")
```

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)