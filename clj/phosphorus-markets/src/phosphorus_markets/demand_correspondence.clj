;   Copyright (c) 2020 International Institute for Applied Systems Analysis. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "TODO:"
      :author "Anna Shchiptsova"}
  phosphorus-markets.demand-correspondence)


(def ^:private home
  "Identifier for domestic industry supply."
  :home)

(defn- with-home
  "TODO:"
  [{entry :entry
    demand :demand
    total-demand :total-demand}]
  (assoc
    entry
    home
    (- total-demand demand)))

(defn- demand-fn
  "TODO:"
  [entry exit]
  (fn[price]
    (cond
      (<= price entry) 0
      (> price exit) (- exit entry)
      :else (- price entry))))

(defn- demand-fns
  "TODO:"
  [entry exit]
  (->> (keys entry)
       ((juxt identity
              (fn[ks]
                (map #(demand-fn (get entry %)
                                 (get exit %))
                     ks))))
       (apply zipmap)))

(defn- exit
  "TODO:"
  [{supply :supply
    entry :entry
    total-demand :total-demand}]
  (reduce-kv (fn[m k v]
               (->> (get entry k)
                    (+ v)
                    (#(if (> % total-demand)
                        total-demand
                        %))
                    (assoc m k)))
             {}
             supply))

(defn build
  "Builds correspondence between optimal import bundles and market price."
  [{supply :supply
    demand :demand
    entry :entry
    total-demand :total-demand
    :as market-parameters}]
  (let [exit_ (assoc (exit market-parameters)
                     :home
                     total-demand)
        entry_ (with-home market-parameters)
        fns (demand-fns entry_ exit_)
        aggregate #(->> (vals fns)
                        (map (fn[f](f %)))
                        (apply +))]
    (if (->> (vals entry)
             (filter #(< % total-demand))
             not-empty)
      (->> (vals entry_)
           (concat (vals exit_))
           distinct
           sort
           (map #(vector % (aggregate %)))
           (filter #(<= (second %) demand))
           last
           ((fn[[p v]]
              (let [active (->> (keys fns)
                                (filter #(> (get exit_ %) p))
                                (filter #(<= (get entry_ %) p)))]
                (->> (count active)
                     (quot (- demand v))
                     (+ p)
                     ((juxt (fn[_](count active))
                            (fn[kp](- demand (aggregate kp)))
                            (fn[kp]
                              (let [price (->> (count active)
                                               (mod (- demand v))
                                          (#(if (> % 0) (inc kp) kp)))]
                                (->> (dissoc fns home)
                                     (filter (fn[[_ f]]
                                               (> (f price) 0)))
                                     (into {})
                                     (reduce-kv #(assoc %1 %2 (%3 kp))
                                                {})
                                     (hash-map :price price :kernel))))))
                     (#(->> (butlast %)
                            (zipmap [:n :k :price])
                            (merge (last %)))))))))
      (let [kv {:n 0
                :k 0
                :price total-demand}]
        (->> (filter (fn[[_ v]]
                       (= v total-demand))
                     entry)
             keys
             (#(zipmap % (repeat 0)))
             (assoc kv :kernel))))))

(defn price-inc
  "Measures price increment for next iteration in English auction
  from single market data."
  [ids {entry :entry :as market-parameters} {p :price}]
  (let [exit (exit market-parameters)]
    (->> (filter #(< (get entry %) p) ids)
         (map #(let[v (get exit %)]
                 (if (< v p) (- p v) 1)))
         sort
         first)))
