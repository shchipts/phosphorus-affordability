# phosphorus-markets

Competitive equilibrium prices of distributed DAP/MAP commodity market.

World trade in DAP/MAP commodities breaks down into transactions on individual markets
residing at different geographical locations. The markets are linked by the shared access
to a finite pool of international suppliers.  Suppliers differentiate price offers for
distinct markets based on the trade costs. The algorithm runs the generalized English
auction for differentiated markets (Gul & Stacchetti 2000). Executes price adjustment
procedure for different model parameterization provided in input files.

## Install

No installation needed. This is a standalone java application.
Requires Java SE 14.

## Usage

  execute in the root directory

  $ lein run settings.edn

  \* Options

  -k, --number-of-chunks K  10   Chunk auctions into K-sized slices
  -s, --save PATH           bin  PATH to folder for output writing
  -t, --trace                    Print stack trace
  -h, --help                     Print command help

  \* Arguments:

  settings-path   Path to the file with settings

### Example of settings file

TODO

## Documentation

* [API docs](https://shchipts.github.io/phosphorus-markets/)

## License

Copyright © 2020 International Institute for Applied Systems Analysis

Licensed under [MIT](http://opensource.org/licenses/MIT)
