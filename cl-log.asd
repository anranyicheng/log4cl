;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(defpackage :log4cl.system
  (:use :cl :asdf))

(in-package :log4cl.system)

(defsystem :log4cl
  :serial t
  :version "1.0"
  :depends-on (:bordeaux-threads 
               :cl-ppcre
               :demacs)
  :components ((:file "package")
	       (:file "log4cl-util")
               (:file "log4cl-test")
               ;; TODO do this dynamically only if demacs
               ;; package is present
               (:file "demacs-integration")
	       (:file "appender")
	       (:file "console-appender")))

(defsystem :log4cl.test
  :serial t
  :version "1.0"
  :depends-on (:log4cl :stefil)
  :components ((:file "test/logger")
               (:file "test/speed")))

(defmethod perform ((op test-op) (system (eql (find-system :log4cl))))
  (operate 'load-op :log4cl.test)
  (in-package :log4cl.test)
  (eval (read-from-string "(stefil:funcall-test-with-feedback-message 'log4cl.test:test)"))
  (values))
