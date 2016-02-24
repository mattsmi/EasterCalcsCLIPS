;####################################################################################
;;;;;; To print out the facts use: (printout t (facts) crlf) .

;;;These functions calculate the date of Easter, including the Easter falling before or after a given date.

;;;Rules and functions start here
(deffunction F10_CalcEaster
    (?imYear ?imMethod)
    
    ;validate the arguments
    (if (or (< ?imMethod ?*iEDM_JULIAN*) (> ?imMethod ?*iEDM_WESTERN*)) then
        (return nil)
    )
    (if (and (= ?imMethod ?*iEDM_JULIAN*) (< ?imYear ?*iFIRST_EASTER_YEAR*)) then
        (return nil)
    )
    (if (and (or (= ?imMethod ?*iEDM_ORTHODOX*) (= ?imMethod ?*iEDM_WESTERN*)) (or (< ?imYear ?*iFIRST_VALID_GREGORIAN_YEAR*) (> ?imYear ?*iLAST_VALID_GREGORIAN_YEAR*))) then
        (return nil)
    )

    ;Using the formula by Jean Meeus in his book Astronomical Algorithms (1991, p. 69)
    (if (or (= ?imMethod ?*iEDM_JULIAN*) (= ?imMethod ?*iEDM_ORTHODOX*)) then
        (bind ?iA (mod ?imYear 4))
        (bind ?iB (mod ?imYear 7))
        (bind ?iC (mod ?imYear 19))
        (bind ?iD (mod (+ (* 19 ?iC) 15) 30))
        (bind ?iE (mod (+ (- (+ (* 2 ?iA) (* 4 ?iB)) ?iD) 34) 7))
        (bind ?iTemp (+ ?iD ?iE 114))
        (bind ?iF (div ?iTemp 31))
        (bind ?iG (mod ?iTemp 31))
        (bind ?iMonth ?iF)
        (bind ?iDay (+ ?iG 1))
        (bind ?dTemp (mkDate ?imYear ?iMonth ?iDay))
        (if (= ?imMethod ?*iEDM_ORTHODOX*) then
            (bind ?iTemp (daysAdd ?dTemp (CalcDayDiffJulianCal ?dTemp)))
            (return ?iTemp)
        else
            ;return Julian date for Easter
            (return ?dTemp)
        )
    else
        (if (= ?imMethod ?*iEDM_WESTERN*) then
            ;Calculate Easter Sunday date 
            ;first two digits of the year 
            (bind ?iFirstDig (div ?imYear 100)) 
            (bind ?iRemain19 (mod ?imYear 19))
                ;Calculate PFM date 
            (bind ?iTempNum (- (+ (div (- ?iFirstDig 15) 2) 202) (* 11 ?iRemain19))) 
            (switch ?iTempNum 
                (case 21 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 24 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 25 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 27 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 28 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 29 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 30 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 31 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 32 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 34 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 35 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 38 then (bind ?iTempNum (- ?iTempNum 1))) 
                (case 33 then (bind ?iTempNum (- ?iTempNum 2))) 
                (case 36 then (bind ?iTempNum (- ?iTempNum 2))) 
                (case 37 then (bind ?iTempNum (- ?iTempNum 2))) 
                (case 39 then (bind ?iTempNum (- ?iTempNum 2))) 
                (case 40 then (bind ?iTempNum (- ?iTempNum 2))) 
                (default none) 
            ) 
            (bind ?iTempNum (mod ?iTempNum 30)) 
    
            (bind ?iTableA (+ ?iTempNum 21)) 
            (if (= ?iTempNum 29) then 
                (bind ?iTableA (- ?iTableA 1)) 
            ) 
            (if (and (= ?iTempNum 28) (> ?iRemain19 10)) then 
                (bind ?iTableA (- ?iTableA 1)) 
            ) 
    
            ;Find the next Sunday 
            (bind ?iTableB (mod (- ?iTableA 19) 7)) 
            
            (bind ?iTableC (mod (- 40 ?iFirstDig) 4)) 
            (if (= ?iTableC 3) then 
                (bind ?iTableC (+ ?iTableC 1)) 
            ) 
            (if (> ?iTableC 1) then 
                (bind ?iTableC (+ ?iTableC 1)) 
            ) 
            
            (bind ?iTempNum (mod ?imYear 100)) 
            (bind ?iTableD (mod (+ ?iTempNum (div ?iTempNum 4)) 7)) 
            
            (bind ?iTableE (+ (mod (- 20 ?iTableB ?iTableC ?iTableD) 7) 1)) 
            (bind ?imDay (+ ?iTableA ?iTableE))
            
            ;Return the date of Easter 
            (if (> ?imDay 31) then 
                (bind ?imDay (- ?imDay 31)) 
                (bind ?imMonth 4) 
            else 
                (bind ?imMonth 3) 
            ) 
            (bind ?dTemp (mkDate ?imYear ?imMonth ?imDay))
            (return ?dTemp)
            
        else
            (return nil)
        )
    )
)

(deffunction F09_CalcPreviousEaster
    (?dDate ?iDateMethod)
    
    ;Check arguments
    (bind ?iYearTemp (yearFromDateINT ?dDate))
    (if (or (not (integerp ?dDate)) (not (integerp ?iDateMethod))) then
        (return nil)
    )
    (if (or (< ?iDateMethod ?*iEDM_JULIAN*) (> ?iDateMethod ?*iEDM_WESTERN*)) then
        (return nil)
    )
    
    (bind ?dDateHolder (F10_CalcEaster ?iYearTemp ?iDateMethod))
    (if (< ?dDateHolder ?dDate) then
        (return ?dDateHolder)
    else
        (return (F10_CalcEaster (- ?iYearTemp 1) ?iDateMethod))
    )
)

(deffunction F11_CalcNextEaster
    (?dDate ?iDateMethod)
    
    
    ;Check arguments
    (bind ?iYearTemp (yearFromDateINT ?dDate))
    (if (or (not (integerp ?dDate)) (not (integerp ?iDateMethod))) then
        (return nil)
    )
    (if (or (< ?iDateMethod ?*iEDM_JULIAN*) (> ?iDateMethod ?*iEDM_WESTERN*)) then
        (return nil)
    )
    
    (bind ?dDateHolder (F10_CalcEaster ?iYearTemp ?iDateMethod))
    (if (> ?dDateHolder ?dDate) then
        (return ?dDateHolder)
    else
        (return (F10_CalcEaster (+ ?iYearTemp 1) ?iDateMethod))
    )
)
