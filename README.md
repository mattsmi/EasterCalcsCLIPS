Calculating Easter using the CLIPS Expert System tool (Rules Engine)
====================================================================

CLIPS functions for calculating the dates of Julian, Revised Julian, and Gregorian Easter for a given year. Dates are returned in ISO 8601 format (YYYY-MM-DD). The script is quite simple and does not perform any checking that it receives a valid year; it assumes it receives a valid year in "YYYY" format.

To calculate the date of Easter for a given year by running this CLIPS code: 

  * change directory to the `data` directory,
  * launch a CLIPS shell
  * execute the following in the CLIPS shell: `(batch* "StartEasterCalcs.clp")` .

The script will automatically close the CLIPS shell.

If you do not have CLIPS already installed, install it from here: [CLIPS at SourceForge](https://sourceforge.net/projects/clipsrules/files/CLIPS/6.30/) .

**NB** This runs on CLIPS Version 6.30. It will need to be modified for CLIPS Version 6.40.

