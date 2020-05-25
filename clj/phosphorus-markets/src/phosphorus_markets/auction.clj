;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Generalized English auction."
      :author "Anna Shchiptsova"}
 phosphorus-markets.auction
  (:require [phosphorus-markets.demand-correspondence :as dp]
            [phosphorus-markets.market-functions :as mf]))

(defn- record-iterations
  "Appends current prices to accumulated results."
  ([demand-sets] [])
  ([prev supply demand-sets incs]
   (->> (keys supply)
        (map #(if (nil? (get incs %))
                0 (get incs %)))
        (#(concat % (map :price demand-sets)))
        (into [])
        (reduce conj prev))))

(defn- record
  "Returns import prices, market prices and market prices
  at the start of an auction."
  [m n]
  (fn compile-record
    ([demand-sets]
     (-> (+ m n)
         (repeat 0)
         (concat (map :price demand-sets))))
    ([prev supply demand-sets incs]
     (->> (keys supply)
          (mapv (fn[v1 v2]
                  (+ v1
                     (if (nil? (get incs v2))
                       0 (get incs v2))))
                (take m prev))
          (#(reduce (fn [s x] (conj s x))
                    %
                    (concat (map :price demand-sets)
                            (take-last n prev))))))))

(defn- iteration
  "Returns auction state."
  [supply recordf]
  (fn compile-iteration
    ([markets]
     (let [demand-sets (map dp/build markets)]
       (compile-iteration markets
                          (recordf demand-sets)
                          {}
                          demand-sets)))
    ([markets
      iterations
      increments
      demand-sets]
     (hash-map :demand-sets
               demand-sets
               :markets
               markets
               :excess-demand
               (mf/excess-demand-set demand-sets
                                     supply)
               :iterations
               (recordf iterations
                        supply
                        demand-sets
                        increments)))))

(defn- market-balance
  "Finds market prices for supply and demand after price increase
  for imports in excess demand set."
  [{prev-demand-sets :demand-sets
    prev-markets :markets
    excess-demand :excess-demand
    iterations :iterations}
   iteratef]
  (let [increments (->> (map #(dp/price-inc excess-demand %1 %2)
                             prev-markets
                             prev-demand-sets)
                        (filter some?)
                        (reduce (fn [s x] (if (< x s) x s)))
                        repeat
                        (zipmap excess-demand))]
    (->> (map (fn [pars]
                (update pars
                        :entry
                        #(merge-with + % increments)))
              prev-markets)
         ((juxt identity
                #(map dp/rebuild % prev-demand-sets)))
         ((fn [[cur-markets cur-demand-sets]]
            (iteratef cur-markets
                      iterations
                      increments
                      cur-demand-sets))))))

(defn- transpose
  "Returns results of every iteration, including import prices and
  market prices."
  [supply demand]
  (fn [iterations]
    (zipmap [:imports
             :markets]
            ((juxt #(% iterations
                       supply
                       (fn [v1 v2]
                         ((fnil (fn [x] (+ x v2)) 0) (last v1))))
                   #(% (drop (count supply) iterations)
                       demand
                       (fn [_ v2] (identity v2))))
             (fn [coll kv f]
               (->> (count demand)
                    (+ (count supply))
                    (#(partition (count kv) % coll))
                    (reduce (fn [all batch]
                              (map (fn [v1 v2]
                                     (conj v1 (f v1 v2)))
                                   all
                                   batch))
                            (repeat (count kv) []))
                    (zipmap (keys kv))))))))

(defn- aggregate
  "Returns auction results as import prices, market prices and surpluses."
  [supply demand]
  (fn [iterations]
    (let [m (count supply) n (count demand)]
      (->> ((juxt #(take m %)
                  #(take n (drop m %))
                  #(take-last n %))
            iterations)
           (map vec)
           ((fn [[v1 v2 v3]] [v1 v2 (map - v2 v3)]))
           (map #(zipmap (keys %1) %2)
                [supply demand demand])
           (zipmap [:imports
                    :markets
                    :surplus])))))

(defn run
  "Finds a minimal Walrasian equilibrium for phosphorus markets using the
  procedure of generalized English auction (Gul & Stacchetti 2000).
  Arguments to this function must include parameters of import supply curves
  and markets' demand in the network of phosphorus markets.

  By default, returns a map with import prices (:imports), market prices
  (:markets), and consumers/farmers surpluses (:surplus).

  Recognized options:
    :sequence   - record results of all iterations in :imports and :markets.

  ## References
      [1] Gul, F., & Stacchetti, E. (2000). The English Auction with
  Differentiated Commodities. Journal of Economic Theory, 92: 66-95."
  ([supply demand entry]
   (run supply demand entry nil))
  ([supply demand entry option]
   (if (= option :sequence)
     (run supply
          demand
          entry
          record-iterations
          (transpose supply demand))
     (run supply
          demand
          entry
          (record (count supply) (count demand))
          (aggregate supply demand))))
  ([supply demand entry recordf transformf]
   (let [iteratef (iteration supply recordf)]
     (->> (vals demand)
          (apply +)
          repeat
          (map (fn [& args]
                 (zipmap [:demand
                          :entry
                          :supply
                          :total-demand]
                         args))
               (vals demand)
               (vals entry)
               (repeat supply))
          iteratef
          (iterate #(market-balance % iteratef))
          (drop-while #(seq (:excess-demand %)))
          first
          :iterations
          transformf))))
