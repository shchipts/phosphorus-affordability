;   Copyright (c) 2020 International Institute for Applied Systems Analysis. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Supply and demand correspondence for imports on multiple markets."
      :author "Anna Shchiptsova"}
  phosphorus-markets.market-functions
  (:require [clojure.math.combinatorics :as combinatorics]))


(defn- residual-demand-fn
  "Returns a function that determines how many items are minimally
  required from a subset of imports to complement kernel to some
  optimal import bundle."
  [demand-correspondences supply]
  (let [active (map #(assoc (select-keys % [:k :n])
                       :kernel
                       (reduce-kv (fn[m k v]
                                    (assoc m
                                      k
                                      (let [x (get-in % [:kernel k])]
                                        (if (and (not (nil? x))
                                                 (< x v))
                                          1 0))))
                                  {}
                                  supply))
                    demand-correspondences)]
    (fn[subset]
      (apply +
             (map (fn[dp]
                    (let [items (get dp :kernel)]
                      (-> (reduce #(+ %1 (get items %2))
                                  0
                                  subset)
                          (+ (get dp :k))
                          (- (get dp :n))
                          (max 0))))
                  active)))))


(defn we-conditions
  "Checks necessary conditions for prices to be a Walrasian equilibrium
  price vector. For each combination of importers, returns a hash map with
  aggregate supply/demand balance for goods as values and importers' enumeration
  as keys. Arguments to this function must include a list of hash maps
  characterizing demand orrespondence of individual market, and a hash map
  with importers' supply constraints."
  [demand-correspondences supply]
  (let [values (-> (keys supply)
                   (zipmap (repeat 0))
                   transient
                   (#(reduce (fn[seed d]
                               (reduce-kv (fn[m k v]
                                            (assoc! m k (+ v (get m k))))
                                          seed
                                          (:kernel d)))
                             %
                             demand-correspondences))
                   persistent!)
        residual (residual-demand-fn demand-correspondences supply)]
    (->> (keys supply)
         combinatorics/subsets
         (drop 1)
         (reduce (fn[coll subset]
                   (->> (map (fn[id]
                               (- (get values id)
                                  (get supply id)))
                             subset)
                        (apply +)
                        (+ (residual subset))
                        (assoc! coll (vec subset))))
                 (transient {}))
         (persistent!))))

(defn excess-demand-set
  "Derives excess demand set based on markets' demand for imports in an
  iteration of English auction. Returns a vector with identifiers of overdemanded
  importers. Arguments to this function must include a list of hash maps
  characterizing demand orrespondence of individual market, and a hash map with
  importers' supply constraints."
  [demand-correspondences supply]
  (->> (we-conditions demand-correspondences
                      supply)
       (reduce-kv (fn[m k v]
                    (cond
                      (> v (first m)) [v [k]]
                      (and (= v (first m))
                           (not= v 0)) [(first m) (conj (second m) k)]
                      :else m))
                  [0 []])
       second
       (reduce #(if (or (empty? %1)
                        (> (count %1) (count %2)))
                  %2 %1)
               [])))
