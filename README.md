Twin Simulator
==============

A portfolio project.

A very simple R script which randomly generates correlated data and has very basic error checking functionality.

This script accepts three named arguments:

- `--mzr` (the monozygotic twin correlation; default = 0.8)
- `--dzr` (the dizygotic twin correlation; default = 0.4)
- `--n`   (the sample size; default = 1000)

All three arguments are optional. If one or more arguments are missing, the program will use the default values.

To execute the script you must have R installed, and the packages `Rutils` and `MASS`.

Usage:
------

Download the script `simulatingTwinData.R` into some directory. From that directory on the command line enter:

`$./simulatingTwinData.R`

This will simulate a twin dataset with the default values.

To specify custom values enter:

`$./simulatingTwinData.R --mzr=X --dzr=Y --N=Z`

where X, Y and Z are numerical values. If non numerical values are entered, the program will throw and error
and exit.

The flags can be entered in any order.

`mzr` and `dzr` *must* be a numeric value between -1 and 1, otherwise the program will throw and error and exit.

`N` *must* be a positive integer >= 2, otherwise the program will throw and error and exit.

If `mzr` is less than `dzr` the program will run, but will warn you that in real world datasets this can happen, but it is uncommon.

Future planned functionality:

- the inclusion of age and sex variables
- the ability to simulate sex-limitation effects
