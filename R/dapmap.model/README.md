# dapmap.model

This package contains four datasets with the estimates of the amount of competition in the distibuted model of DAP/MAP commodity markets

* `concentration.observed`: a normalized Herfindahl–Hirschman index of concentration (Hirschman 1964) by region  
for DAP/MAP fertilizer trade volumes 2013-2017
* `concentration.observed`: an inverse normalized Herfindahl–Hirschman index of diversification (Berry 1971) by international supplier  
for DAP/MAP fertilizer trade volumes 2013-2017
* `concentration.simulated`: a normalized Herfindahl–Hirschman index of concentration (Hirschman 1964) by region  
for DAP/MAP fertilizer trade volumes in 2030 scenarios
* `concentration.simulated`: an inverse normalized Herfindahl–Hirschman index of diversification (Berry 1971) by international supplier  
for DAP/MAP fertilizer trade volumes in 2030 scenarios

The index of concentration takes the value 0 when a regional market is provided equally by all six suppliers (international suppliers plus domestic industry),
and approaches 1 when the market in question has a single supplier.  
The index of diversification takes the value 0 when an international supplier is active on a single regional market, and approaches 1 when the supplier in question
sells in equal shares to all markets.

See also:  
  1\. Herfindahl–Hirschman Index. (2020, September 20). In Wikipedia. Accessed from https://en.wikipedia.org/wiki/Herfindahl%E2%80%93Hirschman_Index  
  2\. Hirschman, A. (1964). The Paternity of an Index. The American Economic Review, 54(5): 761. https://www.jstor.org/stable/1818582  
  3\. Berry, C. (1971). Corporate Growth and Diversification. Journal of Law and Economics, 14(2): 371-383. https://doi.org/10.1086/466714

## Notes

The following classifications are used:  
- scenarios (from FAO. (2018). The future of food and agriculture - Alternative pathways to 2050 http://www.fao.org/global-perspectives-studies/food-agriculture-projections-to-2050/en/)  
  1\. Business as Usual  
  2\. Stratified Societies  
- international suppliers  
  1\. Chinese exporters  
  2\. Maaden https://www.maaden.com.sa/  
  3\. Mosaic http://www.mosaicco.com/  
  4\. OCP https://www.ocpgroup.ma/  
  5\. PhosAgro/EuroChem  https://phosagro.com/ https://www.eurochemgroup.com/    
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
devtools::install_github("shchipts/phosphorus-affordability", subdir = "R/dapmap.model")
```

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)