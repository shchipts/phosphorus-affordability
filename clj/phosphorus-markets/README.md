# phosphorus-markets

Competitive equilibrium prices of distributed DAP/MAP commodity market.

World trade in DAP/MAP commodities breaks down into transactions on individual markets
residing at different geographical locations. The markets are linked by the shared access
to a finite pool of international suppliers.  Suppliers differentiate price offers for
distinct markets based on the trade costs. The algorithm runs the generalized English
auction for differentiated markets (Gul & Stacchetti 2000). Executes price adjustment
procedure for different model parameterization provided in input files.

Gul, F., & Stacchetti, E. (2000). The English Auction with Differentiated Commodities. Journal of Economic Theory, 92(1): 66-95. https://doi.org/10.1006/jeth.1999.2580

## Install

No installation needed. This is a standalone java application.
Requires Java SE 14.

## Usage

  execute in the root directory

  $ lein run settings.edn

  ```
  Options:

  -k, --number-of-chunks K  10   Chunk auctions into K-sized slices
  -s, --save PATH           bin  PATH to folder for output writing
  -t, --trace                    Print stack trace
  -h, --help                     Print command help

  Arguments:

  settings-path   Path to the file with settings
  ```

### Settings example

  ```
  {:supply "supply.csv"
   :demand "demand.csv"
   :entry {:africa "Africa.csv"
           :ea "East Asia.csv"
           :eeca "Eastern Europe and Central Asia.csv"
           :la "Latin America.csv"
           :na "North America.csv"
           :oceania "Oceania.csv"
           :sa "South Asia.csv"
           :europe "Western and Central Europe.csv"
           :wa "Western Asia.csv"}
   :markets {:africa "Africa"
             :ea "East Asia"
             :eeca "Eastern Europe and Central Asia"
             :la "Latin America"
             :na "North America"
             :oceania "Oceania"
             :sa "South Asia"
             :europe "Western and Central Europe"
             :wa "Western Asia"}}

  ```

## Documentation

* [API docs](https://shchipts.github.io/phosphorus-affordability/)

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)
