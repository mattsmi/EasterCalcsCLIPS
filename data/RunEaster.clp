;;; This script is a basic driving example of
;;;    how to calculate the date of Easter.

(defrule rGetDetailsFromInput
    (initial-fact)
    =>
    ;Ask the user for the year, in which they are seeking the date of Easter.
    ;  Lazy = do not bother to check that we receive a valid year.
    (printout t crlf "Year, for which Easter is sought (YYYY)? ")
    (bind ?iUserYear (read))
    
    ;Calculate Easter for that year according to the Julian, Revised Julian, and Gregorian calendars.
    (bind ?iJulianEaster (unmakeDate (F10_CalcEaster ?iUserYear 1)))
    (bind ?iRevisedJulianEaster (unmakeDate (F10_CalcEaster ?iUserYear 2)))
    (bind ?iGregorianEaster (unmakeDate (F10_CalcEaster ?iUserYear 3)))
    
    ;Output results
    (printout t "Easter according to the Julian Calendar for " ?iUserYear ": " ?iJulianEaster crlf)
    (printout t "Easter according to the Revised Julian Calendar for " ?iUserYear ": " ?iRevisedJulianEaster crlf)
    (printout t "Easter according to the Gregorian Calendar for " ?iUserYear ": " ?iGregorianEaster crlf)
)