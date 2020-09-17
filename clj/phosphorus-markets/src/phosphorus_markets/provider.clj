;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Forward and backward processing of I/O data."
      :author "Anna Shchiptsova"}
 phosphorus-markets.provider
  (:require [clojure.edn :as edn]
            [clojure.set :as s]
            [utilities-clj.format :as formatter]))

(defn- to-line
  "Converts values to string collection."
  [coll]
  (map #(if (or (float? %)
                (ratio? %))
          (formatter/double-to-str (double %) 6)
          (str %))
       coll))

(defn- parse
  "Parses content of csv file with auction parameters."
  [rows]
  (->> (drop 1 rows)
       (map (fn [coll]
              (map edn/read-string
                   coll)))
       (map (fn [coll]
              (->> (first rows)
                   (map keyword)
                   (#(zipmap % coll)))))))

(defn from
  "Converts file content with market parameters to model data."
  [{supply :supply
    demand :demand
    entry :entry
    names :markets}
   readf
   folder]
  (->> (vals entry)
       (into [supply demand])
       (map (comp parse readf #(str folder "/" %)))
       (split-at 2)
       ((juxt (comp vec first)
              #(apply map
                      (fn [& coll]
                        (zipmap (map (fn [k]
                                       (keyword (get names k)))
                                     (keys entry))
                                coll))
                      (second %))))
       (apply conj)
       (apply map vector)))

(defn to
  "Converts auction results to file data."
  [m]
  (let [first-ids [:iteration :simulation]]
    (->> (keys m)
         (filter (comp not (set first-ids)))
         (#(if (s/subset? (set first-ids) (set (keys m)))
             (into % first-ids)
             %))
         ((juxt (fn [sorted-keys]
                  (apply map
                         #(to-line %&)
                         (map #(get m %)
                              sorted-keys)))
                #(to-line (map (comp str symbol) %))))
         (apply conj))))
