;;; This script produces values for Easter for valid Easter dates (e.g. from AD 326 to AD 4099).
;;;    Our calendar functions, however, limit us to dates later than the UNIX Epoch (1 January 1970).
;;;    NB: (a) Easter calculation defined at the Council of Nicæa in AD 325.
;;;        (b) Gregorian calendar defined and started in October AD 1582.
;;;        (c) Revised Julian or Milanković calendar defined in May AD 1923.
;;; It should be executed from within a CLIPS shell by: (batch* "TestAllDatesForEaster.clp").

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


;; Define a template for the Easter data
(deftemplate EasterForThreeCals
 (slot JulianEaster (default nil))
 (slot RevisedJulianEaster (default nil))
 (slot GregorianEaster (default nil))
)

;; Define a function to iterate through dates required.
(deffunction CalcDataForAllCalendars
    (?iStartYear ?iFinishYear)

    ;;Some basic checking of arguments
    ;;   The year should be an integer.
    (if (or (not (integerp ?iStartYear)) (not (integerp ?iFinishYear))) then
        (printout t crlf crlf "Invalid year(s) for calculating Easter: " ?iStartYear " - " ?iFinishYear crlf crlf)
        (return nil)
    )
    ;;   The year should not be before the decision of the council of Nicæa came into effect.
    (if (< ?iStartYear 326) then
        (printout t crlf crlf "It is not possible to calculate the date of Easter before the Council of Nicæa!" crlf crlf)
        (return nil)
    )
    
    ;Loop through the years, creating the data.
    (bind ?iCounter ?iStartYear)
    (while (<= ?iCounter ?iFinishYear)
        (bind ?iJulianEaster (unmakeDate (F10_CalcEaster ?iCounter ?*iEDM_JULIAN*)))
        (if (> ?iCounter 1923) then
            ;We can create all three calendars
            (bind ?iRevisedJulianEaster (unmakeDate (F10_CalcEaster ?iCounter ?*iEDM_ORTHODOX*)))
            (bind ?iGregorianEaster (unmakeDate (F10_CalcEaster ?iCounter ?*iEDM_WESTERN*)))
            (assert (EasterForThreeCals (JulianEaster ?iJulianEaster) (RevisedJulianEaster ?iRevisedJulianEaster) (GregorianEaster ?iGregorianEaster)))
        else
            (if (> ?iCounter 1582) then
                ;We can create only two calendars
                (bind ?iGregorianEaster (unmakeDate (F10_CalcEaster ?iCounter ?*iEDM_WESTERN*)))
                (assert (EasterForThreeCals (JulianEaster ?iJulianEaster) (GregorianEaster ?iGregorianEaster)))
            else
                ;Only the Julian calendar is relevant for the given year.
                (assert (EasterForThreeCals (JulianEaster ?iJulianEaster)))
            )
        )
        ;Increment counter
        (bind ?iCounter (+ ?iCounter 1))
    )

    ;we return no value
    (return nil)
)

;; Now execute the rules engine, so that it will run until the agenda is empty.
;;     In this case, it merely loops through the function to create the dates of Easter.
(CalcDataForAllCalendars 1970 4099)
(run)

;; Finish and exit the CLIPS shell, in case the user does not know how.
(defglobal ?*sFileName* = (str-cat "ListOfEasterDates" ".txt"))
(save-facts ?*sFileName* local EasterForThreeCals)
(printout t "{'Result': " "'FINIS'}" crlf)
(exit)
