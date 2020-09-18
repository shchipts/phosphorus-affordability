(defproject org.iiasa/phosphorus-markets "1.0.0"
  :description "Equilibrium prices of distributed DAP/MAP commodity market"
  :scm {:name "git"
        :url "https://github.com/shchipts/phosphorus-affordability"
        :dir "clj/phosphorus-markets"}
  :license {:name "The MIT License"
            :url "http://opensource.org/licenses/MIT"}
  :dependencies [[org.clojure/clojure "1.10.1"]
                 [org.clojure/math.combinatorics "0.1.6"]
                 [org.clojure/math.numeric-tower "0.0.4"]
                 [org.iiasa/utilities-clj "1.0.0"]
                 [org.iiasa/commodities-auction "1.0.1"]]
  :plugins [[lein-codox "0.9.5"]]
  :codox {:output-path "docs"}
  :jvm-opts ^:replace ["-server" "-Xmx2g"]
  :main ^:skip-aot phosphorus-markets.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
