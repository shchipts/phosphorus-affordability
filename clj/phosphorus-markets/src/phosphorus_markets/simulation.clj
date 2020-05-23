;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Simulation of phosphorus prices over market states."
      :author "Anna Shchiptsova"}
 phosphorus-markets.simulation
  (:require [phosphorus-markets.auction :as auction]
            [clojure.math.numeric-tower :as math]))

(defn run
  "Simulates market equilibria over a set of parameters using an auction.
  Arguments to this function must include a set of parameters describing
  import supply curves  and markets' demand in the network of phosphorus
  markets. Returns a map with trajectories of import prices (:imports),
  market prices (:markets), and consumers/farmers surpluses (:surplus)."
  [supply-coll demand-coll entry-coll]
  (->> (map (fn [s d e]
              (->> (vals d)
                   (apply +)
                   ((fn [scale]
                      (reduce-kv (fn [m k v]
                                   (->> (vals v)
                                        (map #(math/round (* % scale)))
                                        (zipmap (keys v))
                                        (assoc m k)))
                                 {}
                                 e)))
                   (auction/run s d)))
            supply-coll
            demand-coll
            entry-coll)
       (apply map
              (juxt (fn [& x] (ffirst x))
                    (fn [& x]
                      (->> (map second x)
                           ((juxt #(keys (first %))
                                  #(apply mapv
                                          vector
                                          (map vals %))))
                           (apply zipmap)))))
       (into {})))
