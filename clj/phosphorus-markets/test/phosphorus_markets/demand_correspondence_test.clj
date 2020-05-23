(ns phosphorus-markets.demand-correspondence-test
  (:require [clojure.test :refer :all]
            [phosphorus-markets.demand-correspondence :refer :all]))

;;; tests

(deftest build-without-capacity-hit
  (testing "without any capacity constraint reached"
    (; Act
     let [sc1 (build {:supply {:c1 100 :c2 100}
                      :demand 60
                      :entry {:c1 10 :c2 20}
                      :total-demand 100})
          sc2 (build {:supply {:c1 100 :c2 100}
                      :demand 55
                      :entry {:c1 10 :c2 40}
                      :total-demand 100})
          sc3 (build {:supply {:c1 100 :c2 100}
                      :demand 45
                      :entry {:c1 10 :c2 20}
                      :total-demand 100})
          sc4 (build {:supply {:c1 130 :c2 130 :c3 130 :c4 130 :c5 130}
                      :demand 61
                      :entry {:c1 5 :c2 7 :c3 14 :c4 25 :c5 27}
                      :total-demand 130})
          sc5 (build {:supply {:c1 90 :c2 90 :c3 90 :c4 90 :c5 90 :c6 90}
                      :demand 55
                      :entry {:c1 10 :c2 10 :c3 25 :c4 25 :c5 31 :c6 31}
                      :total-demand 90})]

      ; Assert
      (is (= sc1
             {:kernel {:c1 33 :c2 23}
              :price 44
              :k 1 :n 3}))

      (is (= sc2
             {:kernel {:c1 40 :c2 10}
              :price 50
              :k 0 :n 3}))

      (is (= sc3
             {:kernel {:c1 27 :c2 17}
              :price 38
              :k 1 :n 2}))

      (is (= sc4
             {:kernel {:c1 22 :c2 20 :c3 13 :c4 2 :c5 0}
              :price 28
              :k 4 :n 5}))

      (is (= sc5
             {:kernel {:c1 21 :c2 21 :c3 6 :c4 6 :c5 0 :c6 0}
              :price 32
              :k 1 :n 6})))))

(deftest build-with-capacity-hit
  (testing "with some capacity constraints reached"
    (; Act
     let [sc1 (build {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                      :demand 100
                      :entry {:c1 4 :c2 7 :c3 13 :c4 25 :c5 27}
                      :total-demand 138})
          sc2 (build {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                      :demand 135
                      :entry {:c1 4 :c2 7 :c3 13 :c4 25 :c5 27}
                      :total-demand 180})
          sc3 (build {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                      :demand 62
                      :entry {:c1 7 :c2 7 :c3 13 :c4 13 :c5 27}
                      :total-demand 100})
          sc4 (build {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                      :demand 120
                      :entry {:c1 7 :c2 7 :c3 13 :c4 13 :c5 27}
                      :total-demand 160})]

      ; Assert
      (is (= sc1
             {:kernel {:c1 30 :c2 20 :c3 20 :c4 16 :c5 10}
              :price 42
              :k 1 :n 2}))

      (is (= sc2
             {:kernel {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
              :price 80
              :k 0 :n 1}))

      (is (= sc3
             {:kernel {:c1 18 :c2 18 :c3 12 :c4 12}
              :price 26
              :k 2 :n 4}))

      (is (= sc4
             {:kernel {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
              :price 60
              :k 0 :n 1})))))

(deftest build-only-home-supply
  (testing "with no imports"
    (; Act
     let [sc1 (build {:supply {:c1 10 :c2 10}
                      :demand 5
                      :entry {:c1 10 :c2 20}
                      :total-demand 10})
          sc2 (build {:supply {:c1 10 :c2 10}
                      :demand 5
                      :entry {:c1 9 :c2 20}
                      :total-demand 10})
          sc3 (build {:supply {:c1 10 :c2 10 :c3 10}
                      :demand 5
                      :entry {:c1 9 :c2 20 :c3 9}
                      :total-demand 10})]

      ; Assert
      (is (= sc1
             {:kernel {}
              :price 10
              :k 0 :n 1}))
      (is (= sc2
             {:kernel {:c1 0}
              :price 10
              :k 1 :n 2}))
      (is (= sc3
             {:kernel {:c1 0 :c3 0}
              :price 10
              :k 1 :n 3})))))

(deftest include-only-importers-selling-to-market
  (testing "with only importers who supply some goods to a market"
    (; Act
     let [sc1 (build {:supply {:c1 90 :c2 90 :c3 90 :c4 90 :c5 90 :c6 90}
                      :demand 55
                      :entry {:c1 10 :c2 10 :c3 25 :c4 25 :c5 31 :c6 32}
                      :total-demand 90})
          sc2 (build {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                      :demand 60
                      :entry {:c1 4 :c2 7 :c3 9 :c4 26 :c5 45}
                      :total-demand 100})
          sc3 (build {:supply {:c1 80 :c2 80}
                      :demand 80
                      :entry {:c1 10 :c2 55}
                      :total-demand 100})]

      ; Assert
      (is (= sc1
             {:kernel {:c1 21 :c2 21 :c3 6 :c4 6 :c5 0}
              :price 32
              :k 1 :n 5}))
      (is (= sc2
             {:kernel {:c1 22 :c2 19 :c3 17 :c4 0}
              :price 27
              :k 2 :n 4}))
      (is (= sc3
             {:kernel {:c1 45}
              :price 55
              :k 0 :n 2})))))

(deftest one-element-demand-set-with-full-capacity
  (testing "with one-element demand set and maximum possible imports
    at market price"
    (; Act
     let [sc (build {:supply {:c1 5 :c2 4 :c3 7}
                     :demand 9
                     :entry {:c1 4 :c2 9 :c3 5}
                     :total-demand 20})]

      ; Assert
      (is (= sc
             {:kernel {:c1 5 :c3 4}
              :price 9
              :k 0 :n 2})))))

(deftest price-inc-test
  (testing "Estimate auction price increment from single market data"
    (; Act
     let [p1 (price-inc [:c1]
                        {:supply {:c1 2 :c2 3 :c3 3}
                         :entry {:c1 1 :c2 1 :c3 1}
                         :total-demand 5}
                        {:price 3})
          p2 (price-inc [:c1]
                        {:supply {:c1 1 :c2 3 :c3 3}
                         :entry {:c1 1 :c2 1 :c3 1}
                         :total-demand 5}
                        {:price 3})
          p3 (price-inc [:c1 :c3]
                        {:supply {:c1 1 :c2 3 :c3 3}
                         :entry {:c1 1 :c2 1 :c3 1}
                         :total-demand 5}
                        {:price 4})
          p4 (price-inc [:c1 :c2 :c3]
                        {:supply {:c1 2 :c2 3 :c3 1}
                         :entry {:c1 1 :c2 1 :c3 2}
                         :total-demand 15}
                        {:price 10})
          ; skip imports with no market demand
          p5 (price-inc [:c1 :c2]
                        {:supply {:c1 1 :c2 1}
                         :entry {:c1 1 :c2 5}
                         :total-demand 5}
                        {:price 5})]

      ; Assert
      (is (= p1 1))
      (is (= p2 1))
      (is (= p3 1))
      (is (= p4 6))
      (is (= p5 3)))))

(deftest rebuild-test
  (testing "Rebuild demand correspondence from previous iteration price level"
    (; Act
     let [sc-case1-1 (rebuild {:supply {:c1 100 :c2 100}
                               :demand 60
                               :entry {:c1 10 :c2 20}
                               :total-demand 100}
                              {:price 43 :k 0})
          sc-case1-2 (rebuild {:supply {:c1 100 :c2 100}
                               :demand 60
                               :entry {:c1 11 :c2 20}
                               :total-demand 100}
                              {:price 44 :k 1})
          sc-case1-3 (rebuild {:supply {:c1 100 :c2 100}
                               :demand 60
                               :entry {:c1 100 :c2 99}
                               :total-demand 100}
                              {:price 44 :k 2})
          sc-case1-4 (rebuild {:supply {:c1 100 :c2 100}
                               :demand 60
                               :entry {:c1 100 :c2 100}
                               :total-demand 100}
                              {:price 100 :k 1})

          sc-case2-1 (rebuild {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                               :demand 100
                               :entry {:c1 4 :c2 7 :c3 14 :c4 25 :c5 27}
                               :total-demand 138}
                              {:price 42 :k 1})
          sc-case2-2 (rebuild {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                               :demand 100
                               :entry {:c1 12 :c2 7 :c3 14 :c4 25 :c5 27}
                               :total-demand 138}
                              {:price 42 :k 1})
          sc-case2-3 (rebuild {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                               :demand 100
                               :entry {:c1 12 :c2 7 :c3 14 :c4 27 :c5 28}
                               :total-demand 138}
                              {:price 42 :k 2})
          sc-case2-4 (rebuild {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                               :demand 100
                               :entry {:c1 38 :c2 38 :c3 38 :c4 38 :c5 38}
                               :total-demand 138}
                              {:price 43 :k 1})

          sc-case3-1 (rebuild {:supply {:c1 30 :c2 20 :c3 20 :c4 20 :c5 10}
                               :demand 60
                               :entry {:c1 7 :c2 47 :c3 9 :c4 46 :c5 45}
                               :total-demand 100}
                              {:price 27 :k 2})]
      ; Assert
      (is (= sc-case1-1
             {:kernel {:c1 33 :c2 23}
              :price 44
              :k 1 :n 3}))
      (is (= sc-case1-2
             {:kernel {:c1 32 :c2 23}
              :price 44
              :k 2 :n 3}))
      (is (= sc-case1-3
             {:kernel {:c2 0}
              :price 100
              :k 1 :n 2}))
      (is (= sc-case1-4
             {:kernel {}
              :price 100
              :k 0 :n 1}))

      (is (= sc-case2-1
             {:kernel {:c1 30 :c2	20 :c3 20 :c4	16 :c5 10}
              :price 42
              :k 1 :n 2}))
      (is (= sc-case2-2
             {:kernel {:c1 29 :c2	20 :c3 20 :c4	16 :c5 10}
              :price 42
              :k 2 :n 3}))
      (is (= sc-case2-3
             {:kernel {:c1 30 :c2	20 :c3 20 :c4	15 :c5 10}
              :price 43
              :k 1 :n 2}))
      (is (= sc-case2-4
             {:kernel {:c1 18 :c2	18 :c3 18 :c4	18 :c5 10}
              :price 56
              :k 0 :n 5}))

      (is (= sc-case3-1
             {:kernel {:c1 30 :c3 20 :c4 1 :c5 2}
              :price 47
              :k 0 :n 3})))))


;;; test grouping


(deftest build-test
  (testing "Build market demand correspondence:\n"
    (build-without-capacity-hit)
    (build-with-capacity-hit)
    (build-only-home-supply)
    (include-only-importers-selling-to-market)
    (one-element-demand-set-with-full-capacity)))


;;; tests in the namespace


(defn test-ns-hook
  "Explicit definition of tests in the namespace."
  []
  (build-test)
  (price-inc-test)
  (rebuild-test))
