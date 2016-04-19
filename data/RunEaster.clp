;;; This script is a basic driving example of
;;;    how to calculate the date of Easter.

(defrule rGetDetailsFromInput
    (declare (salience ?*normal-priority*))
    (initial-fact)
    =>
    ;Ask the user for the year, in which they are seeking the date of Easter.
    ;  Being lazy = do not bother to check that we receive a valid year.
    (printout t crlf "Year, for which Easter is sought (YYYY)? ")
    (bind ?iUserYear (read))

    ;Calculate Easter for that year according to the Julian, Revised Julian, and Gregorian calendars.
    (bind ?iJulianEaster (unmakeDate (F10_CalcEaster ?iUserYear ?*iEDM_JULIAN*) ?*iEDM_JULIAN*))
    (bind ?iRevisedJulianEaster (unmakeDate (F10_CalcEaster ?iUserYear ?*iEDM_ORTHODOX*) ?*iEDM_ORTHODOX*))
    (bind ?iGregorianEaster (unmakeDate (F10_CalcEaster ?iUserYear ?*iEDM_WESTERN*) ?*iEDM_WESTERN*))

    ;Output results
    (printout t "Easter according to the Julian Calendar for " ?iUserYear ": " ?iJulianEaster crlf)
    (printout t "Easter according to the Revised Julian Calendar for " ?iUserYear ": " ?iRevisedJulianEaster crlf)
    (printout t "Easter according to the Gregorian Calendar for " ?iUserYear ": " ?iGregorianEaster crlf)
)
(defrule checkEasterDatingMethod
    (declare (salience ?*highest-priority*))

    (test (not (member$ EDM (get-defglobal-list))))
    =>
    ;If it hasn't been set, set it to a reasonable default; i.e., Western Easter (Gregorian Calendar).
    (build "(defglobal ?*EDM* = ?*iEDM_WESTERN*)")
)
(defrule checkEasterDatingMethodNotNULL
    (declare (salience ?*highest-priority*))

    (test (and (member$ EDM (get-defglobal-list)) (eq (eval (sym-cat "?*" "EDM" "*")) nil)))

    =>
    ;If it hasn't been set, set it to a reasonable default; i.e., Western Easter (Gregorian Calendar).
    (build "(defglobal ?*EDM* = ?*iEDM_WESTERN*)")
)
