;   Copyright (c) 2020 International Institute for Applied Systems Analysis.
;   All rights reserved. The use and distribution terms for this software
;   are covered by the MIT License (http://opensource.org/licenses/MIT)
;   which can be found in the file LICENSE at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns ^{:doc "Run the project's benchmark tests."
      :author "Anna Shchiptsova"}
 leiningen.bench
  (:require [utilities-clj.benchmark :as benchmark]))

(defn bench
  "Run the project's benchmark tests.

Arguments to this task must be a list of namespaces with benchmark
tests and benchmark options.

Recognized formats of namespace arguments:
  \"namespace-name\", \"namespace-name/benchmark-test-name\"

  \"namespace-name\"
    all benchmark tests in this namespace will be executed,
  \"namespace-name/benchmark-test-name\"
    specified benchmark test in this namespace will be executed.

  If no namespace is specified, all namespaces in the \"benchmarks\" directory
  will be loaded.

Recognized benchmark options: :quick
  :quick forces benchmark tests to be run with criterium.core/quick-benchmark,
    with no argument benchmark tests are run with criterium.core/benchmark."
  [project & args]
  (apply benchmark/bench args))
