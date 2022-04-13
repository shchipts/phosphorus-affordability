# phosphorus-affordability

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6457219.svg)](https://doi.org/10.5281/zenodo.6457219)

Contains routines for application of the matching model of spatially distributed DAP/MAP commodity market to global crops production scenarios

* `R/dapmap.markets`: 1. DAP/MAP fertilizer trade volumes by region 2013-2017 dataset 2. DAP/MAP consumption by region 2007-2018 dataset
* `R/puse`: 1. Estimates of phosphorus use in agricultural crop production by region in 2007-2018, and in 2030 scenarios 2. Phosphorus consumption in agriculture by region dataset
* `R/dapmap.parameters`: 1. DAP/MAP fertilizer demand by region in 2030 scenarios dataset 2. DAP/MAP fertilizer capacity by international supplier in 2030 scenarios dataset 3. Trade costs by international supplier and region in 2030 scenarios dataset
* `R/dapmap.auctions`: Bundles of bootstrap parameters to simulate competitive equilibrium with clojure phosphorus-affordability program
* `clj/phosphorus-markets`: Competitive equilibrium prices of distributed DAP/MAP commodity market
* `R/dapmap.model`: Estimates of the amount of competition in the distributed model of DAP/MAP commodity markets

Gul, F., & Stacchetti, E. (2000). The English Auction with Differentiated Commodities. Journal of Economic Theory, 92(1): 66-95. https://doi.org/10.1006/jeth.1999.2580

## License

Copyright © 2022 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)
