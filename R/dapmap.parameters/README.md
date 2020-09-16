# dapmap.parameters

This package contains three datasets with bootstrap samples

* `bootstrap.demand`: DAP/MAP fertilizer demand by region in 2030 scenarios
* `bootstrap.supply`: DAP/MAP fertilizer supply by region in 2030 scenarios
* `bootstrap.costs`: Market entry by international supplier and region in 2030 scenarios

The following classifications used:  
\- scenarios (from FAO. (2018). The future of food and agriculture - Alternative pathways to 2050)  
  1\. Business as Usual  
  2\. Stratified Societies  
\- suppliers  
  1\. Chinese exporters  
  2\. Maaden https://www.maaden.com.sa/  
  3\. Mosaic http://www.mosaicco.com/  
  4\. OCP https://www.ocpgroup.ma/  
  5\. PhosAgro/EuroChem  https://phosagro.com/ https://www.eurochemgroup.com/    
\- regions (based on IFA regional classification https://www.ifastat.org/)  
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
devtools::install_github("shchipts/phosphorus-affordability", subdir = "R/dapmap.parameters")
```

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)