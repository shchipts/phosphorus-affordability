(ns phosphorus-markets.auction-test
  (:require [clojure.test :refer :all]
            [phosphorus-markets.auction :refer :all]))

;;; tests

(deftest iterations
  (testing "with outcomes for every iteration"
    (
      ; Act
      let [auction1 (run {:c1 5 :c2 7 :c3 4}
                         {:m1 9 :m2 11}
                         {:m1 {:c1 0 :c2 0 :c3 1}
                          :m2 {:c1 0 :c2 1 :c3 0}}
                         :sequence)
           auction2 (run {:c1 5 :c2 7 :c3 4}
                         {:m1 9 :m2 11}
                         {:m1 {:c1 2 :c2 4 :c3 5}
                          :m2 {:c1 2 :c2 5 :c3 4}}
                         :sequence)
           auction3 (run {:c1 3 :c2 4 :c3 1}
                         {:m1 9 :m2 11}
                         {:m1 {:c1 2 :c2 1 :c3 3}
                          :m2 {:c1 1 :c2 1 :c3 2}}
                         :sequence)
           auction4 (run {:c1 5 :c2 4 :c3 7}
                         {:m1 9 :m2 11}
                         {:m1 {:c1 4 :c2 9 :c3 5}
                          :m2 {:c1 5 :c2 2 :c3 7}}
                         :sequence)
           auction5 (run {:c1 4 :c2 2 :c3 5 :c4 3}
                         {:m1 7 :m2 4 :m3 6}
                         {:m1 {:c1 11 :c2 13 :c3 12 :c4 11}
                          :m2 {:c1 12 :c2 14 :c3 17 :c4 17}
                          :m3 {:c1 10 :c2 11 :c3 14 :c4 13}}
                         :sequence)]

        ; Assert
        (is (= auction1
               {:imports {:c1 [0 1 2 3 4 5 6 7 8 9]
                          :c2 [0 0 1 2 3 4 5 6 6 7]
                          :c3 [0 1 2 3 4 5 6 7 8 9]}
                :markets {:m1 [4 4 5 6 7 8 9  10 11 12]
                          :m2 [4 5 6 7 8 9 10 11 11 12]}}))

        (is (= auction2
               {:imports {:c1 [0 1 2 3 4 5 6 7]
                          :c2 [0 0 0 1 1 2 3 3]
                          :c3 [0 1 1 2 3 4 5 5]}
                :markets {:m1 [7 8 8 9  10 11 12 12]
                          :m2 [8 8 9 10 10 11 12 12]}}))

        (is (= auction3
               {:imports {:c1 [0 7 8 9 10 11 12 13]
                          :c2 [0 7 8 9 10 11 12 13]
                          :c3 [0 7 8 9 10 11 12 13]}
                :markets {:m1 [12 12 13 14 14 15 16 17]
                          :m2 [12 12 13 13 14 15 15 16]}}))

        (is (= auction4
               {:imports {:c1 [0 1 2 3 4]
                          :c2 [0 0 1 1 2]
                          :c3 [0 0 1 1 2]}
                :markets {:m1 [9  10 11 11 12]
                          :m2 [10 10 11 11 12]}}))
        (is (= auction5
               {:imports {:c1 [0 1 2]
                          :c2 [0 0 1]
                          :c3 [0 0 0]
                          :c4 [0 0 0]}
                :markets {:m1 [13 13 14]
                          :m2 [15 15 16]
                          :m3 [13 13 14]}})))))

(deftest surpluses
  (testing "with surpluses as outcomes"
    (
      ; Act
      let [auction1 (run {:c1 5 :c2 7 :c3 4}
                         {:m1 9 :m2 11}
                         {:m1 {:c1 0 :c2 0 :c3 1}
                          :m2 {:c1 0 :c2 1 :c3 0}})
           auction2 (run {:c1 5 :c2 7 :c3 4}
                         {:m1 9 :m2 11}
                         {:m1 {:c1 2 :c2 4 :c3 5}
                          :m2 {:c1 2 :c2 5 :c3 4}})
           auction3 (run {:c1 3 :c2 4 :c3 1}
                         {:m1 9 :m2 11}
                         {:m1 {:c1 2 :c2 1 :c3 3}
                          :m2 {:c1 1 :c2 1 :c3 2}})
           auction4 (run {:c1 5 :c2 4 :c3 7}
                         {:m1 9 :m2 11}
                         {:m1 {:c1 4 :c2 9 :c3 5}
                          :m2 {:c1 5 :c2 2 :c3 7}})
           auction5 (run {:c1 4 :c2 2 :c3 5 :c4 3}
                         {:m1 7 :m2 4 :m3 6}
                         {:m1 {:c1 11 :c2 13 :c3 12 :c4 11}
                          :m2 {:c1 12 :c2 14 :c3 17 :c4 17}
                          :m3 {:c1 10 :c2 11 :c3 14 :c4 13}})]

        ; Assert
        (is (= auction1
               {:imports {:c1 9 :c2 7 :c3 9}
                :markets {:m1 12 :m2 12}
                :surplus {:m1 8 :m2 8}}))

        (is (= auction2
               {:imports {:c1 7 :c2 3 :c3 5}
                :markets {:m1 12 :m2 12}
                :surplus {:m1 5 :m2 4}}))

        (is (= auction3
               {:imports {:c1 13 :c2 13 :c3 13}
                :markets {:m1 17 :m2 16}
                :surplus {:m1 5 :m2 4}}))

        (is (= auction4
               {:imports {:c1 4 :c2 2 :c3 2}
                :markets {:m1 12 :m2 12}
                :surplus {:m1 3 :m2 2}}))
        (is (= auction5
               {:imports {:c1 2 :c2 1 :c3 0 :c4 0}
                :markets {:m1 14 :m2 16 :m3 14}
                :surplus {:m1 1 :m2 1 :m3 1}})))))



;;; test grouping

(deftest run-test
  (testing "Run English auction:\n"
    (iterations)
    (surpluses)))


;;; tests in the namespace

(defn test-ns-hook
  "Explicit definition of tests in the namespace."
  []
  (run-test))
