(defproject org.iiasa/phosphorus-markets "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "https://github.com/shchipts/phosphorus-affordability"
  :scm {:name "git"
        :url "https://github.com/shchipts/phosphorus-affordability"}
  :license {:name "The MIT License"
            :url "http://opensource.org/licenses/MIT"}
  :dependencies [[org.clojure/clojure "1.10.1"]
                 [org.clojure/math.combinatorics "0.1.6"]
                 [org.clojure/math.numeric-tower "0.0.4"]
                 [org.iiasa/utilities-clj "1.2.0-SNAPSHOT"]
                 [org.iiasa/commodities-auction "0.2.0-SNAPSHOT"]]
  :main ^:skip-aot phosphorus-markets.core
  :jvm-opts ^:replace ["-server" "-Xmx2g"]
  :eval-in-leiningen true)
