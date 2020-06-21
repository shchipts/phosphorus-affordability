;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Benchmark tests for single auction run."
      :author "Anna Shchiptsova"}
 phosphorus-markets.auction-bench
  (:require [utilities-clj.benchmark :refer [defbenchmark]]
            [commodities-auction.auction :as auction]))

(def ^:private supply
  "Supply of import goods."
  {:china 3511
   :maaden 1161
   :mosaic 3921
   :ocp 1755
   :phosagro 2474})

(def ^:private demand
  "Market demand."
  {:africa 1427
   :ea 13072
   :eeca 1042
   :la 4894
   :na 4015
   :oceania 821
   :sa 6706
   :europe 1441
   :wa 781})

(def ^:private entry
  "Entry prices."
  {:africa
   {:china 0.1086
    :maaden 0.088394
    :ocp 0.100032
    :phosagro 0.097781}
   :ea
   {:china 0.068949
    :maaden 0.074739
    :mosaic 0.093073
    :phosagro 0.084038}
   :eeca
   {:phosagro 0.069154}
   :la
   {:china 0.010878
    :maaden 0
    :mosaic 0
    :ocp 0
    :phosagro 0}
   :na
   {:china 0.045469
    :mosaic 0.001959
    :ocp 0.024679
    :phosagro 0.031258}
   :oceania
   {:china 0.093745
    :maaden 0.083657
    :mosaic 0.101114
    :ocp 0.097839}
   :sa
   {:china 0
    :maaden 0.008626
    :mosaic 0.041522
    :phosagro 0.036405}
   :europe
   {:china 0.087605
    :ocp 0.068774
    :phosagro 0.060002}
   :wa
   {:china 0.114711
    :ocp 0.10626
    :phosagro 0.105997}})

(defbenchmark run
  "Benchmarking generalized English auction."
  []
  ()
  (auction/run supply demand entry :summary))
