;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Equilibrium prices of distributed DAP/MAP commodity market."
      :author "Anna Shchiptsova"}
 phosphorus-markets.core
  (:require [clojure.java.io :as io]
            [phosphorus-markets.provider :as provider]
            [phosphorus-markets.simulator :as sim]
            [utilities-clj.cmd :as cmd]
            [utilities-clj.reader :as reader]
            [utilities-clj.writer :as writer])
  (:gen-class))

(def ^{:private true} cli-args
  "Command line arguments."
  {:required
   [["settings-path" "Path to the file with settings"]]})

(def ^:private cli-options
  "Command line options."
  [["-k" "--number-of-chunks K" "Chunk auctions into K-sized slices"
    :id :k
    :default 10
    :parse-fn #(Integer/parseInt %)]
   ["-s" "--save PATH" "PATH to folder for output writing"
    :id :save
    :default "bin"]])

(defn- write
  "Wraps saving data to disk."
  [{folder :save} i id m]
  (writer/csv-file folder
                   (str (name id)
                        " ("
                        i
                        ").csv")
                   (provider/to m)))

(defn -main
  "Determines competitive equilibrium prices of distributed DAP/MAP
  commodity market.

  The algorithm runs the generalized English auction for differentiated
  DAP/MAP markets. Executes price adjustment procedure for different model
  parameterization provided in input files."
  [& args]
  (cmd/terminal
   {:short-desc
    "Equilibrium prices of distributed DAP/MAP commodity market."
    :args args
    :args-desc cli-args
    :options cli-options
    :execute
    (fn [[pars] options]
      (time
       (->> (io/file pars)
            .getParent
            (provider/from (reader/load-edn pars)
                           reader/read-csv)
            ((fn [coll]
               (println (str "Total number of auctions: " (count coll)))
               (sim/prun coll options)))
            (map-indexed #(do
                            (doseq [m %2]
                              (apply write options m))
                            (println (str "Chunk "
                                          (inc %1)
                                          " of "
                                          (:k options)
                                          " auctions executed."))))
            doall
            ((fn [_]
               (println (str "Results saved to: \""
                             (:save options)
                             "\"")))))))}))
