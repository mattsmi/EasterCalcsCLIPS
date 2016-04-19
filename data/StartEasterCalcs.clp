;;; This script runs the calculations for Easter.
;;; It should be executed from within a CLIPS shell by: (batch* "StartEasterCalcs.clp").

(clear)
(reset)
(defglobal ?*EDM* = 3)
(defglobal ?*yearSought* = nil)
(defglobal ?*prevEaster* = nil)
(defglobal ?*easter* = nil)


;; Batch script begins here.
(load "ByzGlobals01qaSiyr.clp")
(load "ByzFuncs01qaSiyr.clp")
(load "ByzFuncs02qaSiyr.clp")
(load "RunEaster.clp")


;; Now execute the rules engine, so that it will run until the agenda is empty.
(run)
;; Exit the CLIPS shell in case the user does not know how.
(exit)
