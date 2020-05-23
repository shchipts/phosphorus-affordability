(ns phosphorus-markets.simulation-test
  (:require [clojure.test :refer :all]
            [phosphorus-markets.simulation :refer :all]))

;;; tests

(deftest scale-and-run
  (testing "with scaled market entries"
    (; Act
     let [simulation (run [{:c1 5 :c2 7 :c3 4}
                           {:c1 5 :c2 7 :c3 4}
                           {:c1 3 :c2 4 :c3 1}
                           {:c1 5 :c2 4 :c3 7}]
                          [{:m1 9 :m2 11}
                           {:m1 9 :m2 11}
                           {:m1 9 :m2 11}
                           {:m1 9 :m2 11}]
                          [{:m1 {:c1 0 :c2 0 :c3 0.05}
                            :m2 {:c1 0 :c2 0.05 :c3 0}}
                           {:m1 {:c1 0.1 :c2 0.2 :c3 0.25}
                            :m2 {:c1 0.1 :c2 0.25 :c3 0.2}}
                           {:m1 {:c1 0.1 :c2 0.05 :c3 0.15}
                            :m2 {:c1 0.05 :c2 0.05 :c3 0.1}}
                           {:m1 {:c1 0.2 :c2 0.45 :c3 0.25}
                            :m2 {:c1 0.25 :c2 0.1 :c3 0.35}}])]

      ; Assert
      (is (= simulation
             {:imports {:c1 [9 7 13 4] :c2 [7 3 13 2] :c3 [9 5 13 2]}
              :markets {:m1 [12 12 17 12] :m2 [12 12 16 12]}
              :surplus {:m1 [8 5 5 3] :m2 [8 4 4 2]}})))))

(deftest round-scale-and-run
  (testing "with scaled market entries and then rounded to the nearest integer"
    (; Act
     let [simulation (run [{:c1 5 :c2 7 :c3 4}
                           {:c1 5 :c2 7 :c3 4}]
                          [{:m1 9 :m2 11}
                           {:m1 9 :m2 11}]
                          [{:m1 {:c1 0 :c2 0 :c3 0.05}
                            :m2 {:c1 0 :c2 0.05 :c3 0}}
                           {:m1 {:c1 0.095 :c2 0.22 :c3 0.24}
                            :m2 {:c1 0.09 :c2 0.26 :c3 0.2}}])]

      ; Assert
      (is (= simulation
             {:imports {:c1 [9 7] :c2 [7 3] :c3 [9 5]}
              :markets {:m1 [12 12] :m2 [12 12]}
              :surplus {:m1 [8 5] :m2 [8 4]}})))))


;;; test grouping


(deftest run-test
  (testing "Run simulation over market states:\n"
    (scale-and-run)
    (round-scale-and-run)))


;;; tests in the namespace


(defn test-ns-hook
  "Explicit definition of tests in the namespace."
  []
  (run-test))
