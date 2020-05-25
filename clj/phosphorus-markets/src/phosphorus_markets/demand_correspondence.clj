;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Demand correspondence for an individual market."
      :author "Anna Shchiptsova"}
 phosphorus-markets.demand-correspondence)

(defn- entry-with-home
  "Appends domestic industry supply to imports."
  [{entry :entry
    demand :demand
    total-demand :total-demand}]
  (assoc entry
         :home
         (- total-demand demand)))

(defn- demand-fn
  "Returns supply function."
  [entry exit]
  (fn [price]
    (cond
      (<= price entry) 0
      (> price exit) (- exit entry)
      :else (- price entry))))

(defn- demand-fns
  "Returns collection of supply functions."
  [entry exit]
  (->> (keys entry)
       ((juxt identity
              (fn [ks]
                (map #(demand-fn (get entry %)
                                 (get exit %))
                     ks))))
       (apply zipmap)))

(defn- exit
  "Returns a hash map of supply constraints for market imports."
  [{supply :supply
    entry :entry
    total-demand :total-demand}]
  (reduce-kv (fn [m k v]
               (->> (get entry k)
                    (+ v)
                    (#(if (> % total-demand)
                        total-demand
                        %))
                    (assoc m k)))
             {}
             supply))

(defn- exit-with-home
  "Returns a hash map of supply constraints for market imports and
  domestic insdustry."
  [market-parameters]
  (assoc (exit market-parameters)
         :home
         (:total-demand market-parameters)))

(defn- construct
  "Constructs demand correspondence from parameters."
  ([total-demand]
   (construct 0 1 total-demand {}))
  ([k n price kernel]
   (hash-map :k k
             :n n
             :kernel kernel
             :price price)))

(defn build
  "Builds correspondence between optimal import bundles and market price.
  Arguments to this function must include parameters of import supply curves,
  market demand and total demand in the network of phosphorus markets. If
  provided, search for demand set starts from the specified price level."
  ([market-parameters] (build market-parameters 0))
  ([{supply :supply
     demand :demand
     entry :entry
     total-demand :total-demand
     :as market-parameters}
    price]
   (let [exit_ (exit-with-home market-parameters)
         entry_ (entry-with-home market-parameters)
         fns (demand-fns entry_ exit_)
         aggregate #(->> (vals fns)
                         (map (fn [f]
                                (f %)))
                         (apply +))]
     (if (->> (vals entry)
              (filter #(< % total-demand))
              not-empty)
       (->> (vals entry_)
            (concat (vals exit_))
            (filter #(not (< % price)))
            (#(conj % price))
            distinct
            sort
            (map #(vector % (aggregate %)))
            (take-while #(<= (second %) demand))
            last
            ((fn [[p v]]
               (let [fquery (let [active (->> (keys fns)
                                              (filter #(> (get exit_ %) p))
                                              (filter #(<= (get entry_ %) p)))]
                              (fn [f] (f (- demand v) (count active))))
                     kp (+ (fquery quot) p)
                     next-price (if (pos? (fquery mod)) (inc kp) kp)]
                 (->> (dissoc fns :home)
                      (filter (fn [[_ f]] (pos? (f next-price))))
                      (into {})
                      (reduce-kv #(assoc %1 %2 (%3 kp))
                                 {})
                      (construct (- demand (aggregate kp))
                                 (->> (keys fns)
                                      (filter #(>= (get exit_ %)
                                                   next-price))
                                      (filter #(< (get entry_ %)
                                                  next-price))
                                      count)
                                 next-price))))))
       (construct total-demand)))))

(defn price-inc
  "Measures price increment for next iteration in English auction
  from single market data. Arguments to this function must include
  list of importers in the excess demand set, market parameters and
  current market price."
  [ids {entry :entry :as market-parameters} {p :price}]
  (let [exit (exit market-parameters)]
    (reduce #(let [x (if (< (get exit %2) p)
                       (- p (get exit %2)) 1)]
               (cond
                 (= x 1) (reduced 1)
                 (nil? %1) x
                 (< x %1) x
                 :else %1))
            nil
            (filter #(< (get entry %) p) ids))))

(defn rebuild
  "Rebuilds correspondence between optimal import bundles and market price
  starting from necessary price for imports obtained in the previous iteration
  of English auction. Arguments to this function must include market parameters
  and results of previous iteration."
  [market-parameters {price :price k :k}]
  (build market-parameters
         (if (zero? k)
           price
           (dec price))))
