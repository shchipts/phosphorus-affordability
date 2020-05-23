(ns phosphorus-markets.market-functions-test
  (:require [clojure.test :refer :all]
            [phosphorus-markets.market-functions :refer :all]))

;;; tests

(deftest we-conditions-test
  (testing "Check whether WE can be constructed:"
    (; Act
     let [table1 (we-conditions '({:kernel {:c1 6}
                                   :k 1 :n 2}
                                  {:kernel {:c1 3}
                                   :k 0 :n 1})
                                {:c1 7})
          table2 (we-conditions '({:kernel {:c1 6}
                                   :k 1 :n 2})
                                {:c1 7})
          table3 (we-conditions '({:kernel {:c1 6 :c2 2 :c3 1}
                                   :k 1 :n 4}
                                  {:kernel {:c1 3 :c2 3 :c3 4}
                                   :k 0 :n 3})
                                {:c1 7 :c2 5 :c3 4})
          table4 (we-conditions '({:kernel {:c1 2 :c2 2 :c3 1 :c4 1}
                                   :k 3 :n 5}
                                  {:kernel {:c1 3 :c2 4 :c3 2 :c4 2}
                                   :k 1 :n 3}
                                  {:kernel {:c1 5 :c2 3 :c3 2 :c4 1}
                                   :k 3 :n 4})
                                {:c1 5 :c2 4 :c3 7 :c4 2})]

      ; Assert
      (is (= table1
             {[:c1] 2}))
      (is (= table2
             {[:c1] -1}))
      (is (= table3
             {[:c1] 2
              [:c2] 0
              [:c3] 1
              [:c1 :c2] 2
              [:c1 :c3] 3
              [:c2 :c3] 1
              [:c1 :c2 :c3] 3}))
      (is (= table4
             {[:c1] 5
              [:c2] 5
              [:c3] -2
              [:c4] 2
              [:c1 :c2] 10
              [:c1 :c3] 3
              [:c1 :c4] 7
              [:c2 :c3] 4
              [:c2 :c4] 8
              [:c3 :c4] 1
              [:c1 :c2 :c3] 10
              [:c1 :c2 :c4] 14
              [:c1 :c3 :c4] 7
              [:c2 :c3 :c4] 8
              [:c1 :c2 :c3 :c4] 14})))))

(deftest excess-demand-set-test
  (testing "Derive excess demand set:"
    (; Act
     let [set1 (excess-demand-set '({:kernel {:c1 6}
                                     :k 1 :n 2}
                                    {:kernel {:c1 3}
                                     :k 0 :n 1})
                                  {:c1 7})
          set2 (excess-demand-set '({:kernel {:c1 6}
                                     :k 1 :n 2})
                                  {:c1 7})
          set3 (excess-demand-set '({:kernel {:c1 6 :c2 2 :c3 1}
                                     :k 1 :n 4}
                                    {:kernel {:c1 3 :c2 3 :c3 4}
                                     :k 0 :n 3})
                                  {:c1 7 :c2 5 :c3 4})
          set4 (excess-demand-set '({:kernel {:c1 6 :c2 2 :c3 1}
                                     :k 0 :n 4}
                                    {:kernel {:c1 3 :c2 3 :c3 4}
                                     :k 0 :n 1})
                                  {:c1 7 :c2 4 :c3 4})
          set5 (excess-demand-set '({:kernel {:c1 6 :c2 4 :c3 1}
                                     :k 2 :n 3}
                                    {:kernel {:c1 2 :c2 3 :c3 1}
                                     :k 1 :n 3})
                                  {:c1 7 :c2 5 :c3 2})
          set6 (excess-demand-set '({:kernel {:c1 6 :c2 4 :c3 1}
                                     :k 2 :n 3}
                                    {:kernel {:c1 2 :c2 3 :c3 0}
                                     :k 1 :n 3})
                                  {:c1 7 :c2 5 :c3 4})
          set7 (excess-demand-set '({:kernel {:c1 4 :c2 4 :c3 2}
                                     :k 2 :n 3}
                                    {:kernel {:c1 2 :c2 5 :c3 1}
                                     :k 1 :n 3})
                                  {:c1 7 :c2 5 :c3 2})
          set8 (excess-demand-set '({:kernel {:c1 2 :c2 2 :c3 1 :c4 1}
                                     :k 3 :n 5}
                                    {:kernel {:c1 3 :c2 4 :c3 2 :c4 2}
                                     :k 1 :n 3}
                                    {:kernel {:c1 5 :c2 4 :c3 2 :c4 1}
                                     :k 3 :n 4})
                                  {:c1 5 :c2 4 :c3 7 :c4 2})
          set9 (excess-demand-set '({:kernel {:c1 2 :c2 2 :c3 1 :c4 1}
                                     :k 3 :n 5}
                                    {:kernel {:c1 3 :c2 4 :c3 2 :c4 2}
                                     :k 1 :n 3}
                                    {:kernel {:c1 5 :c2 3 :c3 2 :c4 1}
                                     :k 3 :n 4})
                                  {:c1 12 :c2 4 :c3 7 :c4 2})
          set10 (excess-demand-set '({:kernel {:c1 2 :c2 2 :c3 1 :c4 1}
                                      :k 3 :n 5}
                                     {:kernel {:c1 3 :c2 4 :c3 2 :c4 2}
                                      :k 1 :n 3}
                                     {:kernel {:c1 5 :c2 3 :c3 2 :c4 1}
                                      :k 3 :n 4})
                                   {:c1 12 :c2 10 :c3 7 :c4 6})]

      ; Assert
      (is (= set1 [:c1]))
      (is (= set2 []))
      (is (= set3 [:c1 :c3]))
      (is (= set4 [:c1 :c2 :c3]))
      (is (= set5 [:c1 :c2 :c3]))
      (is (= set6 [:c1 :c2]))
      (is (= set7 [:c2 :c3]))
      (is (= set8 [:c1 :c2 :c4]))
      (is (= set9 [:c2 :c4]))
      (is (= set10 [])))))

(deftest no-market-entry-test
  (testing "Check whether WE can be constructed:"
    (; Act
     let [table1 (we-conditions '({:kernel {:c1 6 :c2 4}
                                   :k 2 :n 3}
                                  {:kernel {:c1 2 :c2 3 :c3 1}
                                   :k 1 :n 3})
                                {:c1 7 :c2 5 :c3 2})
          table2 (we-conditions '({:kernel {:c1 5 :c3 4}
                                   :k 0 :n 2}
                                  {:kernel {:c1 4 :c2 4 :c3 2}
                                   :k 1 :n 3})
                                {:c1 5 :c2 4 :c3 7})
          set1 (excess-demand-set '({:kernel {:c1 5 :c3 4}
                                     :k 0 :n 2}
                                    {:kernel {:c1 4 :c2 4 :c3 2}
                                     :k 1 :n 3})
                                  {:c1 5 :c2 4 :c3 7})
          set2 (excess-demand-set '({:kernel {}
                                     :k 0 :n 1}
                                    {:kernel {}
                                     :k 0 :n 1})
                                  {:c1 7 :c2 5 :c3 2})]

       ; Assert
      (is (= table1
             {[:c1] 1
              [:c2] 2
              [:c3] -1
              [:c1 :c2] 4
              [:c1 :c3] 0
              [:c2 :c3] 1
              [:c1 :c2 :c3] 4}))
      (is (= table2
             {[:c1] 4
              [:c2] 0
              [:c3] -1
              [:c1 :c2] 4
              [:c1 :c3] 3
              [:c2 :c3] -1
              [:c1 :c2 :c3] 3}))
      (is (= set1 [:c1]))
      (is (= set2 [])))))
