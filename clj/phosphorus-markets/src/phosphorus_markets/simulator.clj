;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Simulation of equilibrium prices for distributed
      commodity market through the generalized English auction."
      :author "Anna Shchiptsova"}
 phosphorus-markets.simulator
  (:require [commodities-auction.auction :as auction]))

(defn- record
  "Records simulation results."
  [m i j k]
  (let [n (count (first (vals m)))]
    (assoc m
           :simulation
           (repeat n (+ (* i k) j))
           :iteration
           (range 1 (inc n)))))

(defn- iterations
  "Combines results of separate auction runs."
  [i coll size]
  (reduce-kv (fn [m j [_ v]]
               (merge-with concat
                           m
                           (record v
                                   i
                                   (inc j)
                                   size)))
             {}
             (vec coll)))

(defn prun
  "Runs generalized English auction for different parameterization of
  distributed commodity market.
  Returns a lazy sequence of equilibrium prices for a chunk of parameters'
  tuples. Runs auction procedure in parallel for each chunk."
  [coll {chunk-size :k}]
  (map-indexed  (fn [i chunk-itm]
                  (->> (pmap #(apply auction/run %)
                             chunk-itm)
                       ((juxt #(keys (first %))
                              #(apply map
                                      (fn [& more]
                                        (iterations i
                                                    more
                                                    chunk-size))
                                      %)))
                       (apply map #(conj %& (inc i)))))
                (partition-all chunk-size coll)))
