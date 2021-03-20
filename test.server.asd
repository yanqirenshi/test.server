(defsystem "test.server"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (:clack
               :ningle
               :jonathan
               :cl-base64
               :split-sequence)
  :components ((:module "src"
                :components ((:file "package")
                             (:file "variables")
                             (:file "controller")
                             (:file "response")
                             (:file "router")
                             (:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "test.server/tests"))))

(defsystem "test.server/tests"
  :author ""
  :license ""
  :depends-on ("test.server"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for test.server"
  :perform (test-op (op c) (symbol-call :rove :run c)))
