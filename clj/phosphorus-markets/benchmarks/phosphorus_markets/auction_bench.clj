;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Benchmark tests for phosphorus-markets.auction namespace."
      :author "Anna Shchiptsova"}
 phosphorus-markets.auction-bench
  (:require [utilities-clj.benchmark :refer [defbenchmark]]
            [phosphorus-markets.auction :as auction]))

(def ^:private supply
  "Supply of import goods."
  {:china 3453
   :maaden 1257
   :mosaic 3235
   :ocp 2079
   :phosagro 2565})

(def ^:private demand
  "Market demand."
  {:africa 1322
   :ea 12451
   :eeca 998
   :la 4692
   :na 4062
   :oceania 996
   :sa 5807
   :europe 1629
   :wa 700})

(def ^:private entry
  "Entry prices."
  {:africa
   {:china 4109
    :maaden 3130
    :mosaic 4233
    :ocp 3182
    :phosagro 3195}
   :ea
   {:china 2603
    :maaden 2432
    :mosaic 3214
    :ocp 2421
    :phosagro 2474}
   :eeca
   {:china 32657
    :maaden 32657
    :mosaic 32657
    :ocp 32657
    :phosagro 2548}
   :la
   {:china 1075
    :maaden 481
    :mosaic 293
    :ocp 0
    :phosagro 0}
   :na
   {:china 2182
    :maaden 32657
    :mosaic 0
    :ocp 767
    :phosagro 849}
   :oceania
   {:china 3691
    :maaden 3079
    :mosaic 3695
    :ocp 3287
    :phosagro 3058}
   :sa
   {:china 0
    :maaden 0
    :mosaic 1318
    :ocp 312
    :phosagro 673}
   :europe
   {:china 2996
    :maaden 32657
    :mosaic 32657
    :ocp 2107
    :phosagro 1764}
   :wa
   {:china 4305
    :maaden 2930
    :mosaic 32657
    :ocp 3356
    :phosagro 3395}})

(defbenchmark run
  "Benchmarking generalized English auction."
  []
  ()
  (auction/run supply
               demand
               entry))
