Twin Simulator
==============

A portfolio project.

A very simple R script which randomly generates correlated data and has very basic error checking functionality.

This script accepts four named arguments:

- `--mzr` (the monozygotic twin correlation; default = 0.8)
- `--dzr` (the dizygotic twin correlation; default = 0.4)
- `--n`   (the sample size; default = 1000)
- `--age` (the mean age of the whole sample (poisson distribution); default = 25, sd is fixed at 5)
- `--minage` (the minimum age of the whole sample; default = 0)
- `--maxage` (the mean age of the whole sample; default = 25, sd is fixed at 5)

All four arguments are optional. The program will use default values for any/all missing inputs.

To execute the script you must have R installed, and the packages `Rutils` and `MASS`.

By executing the script with one or more flags, the script will randomly generate a pair of correlated values
(designated by either the input provided, or by the assigned defaults).

The script will generate two data frames. One for monozygotic twins, and one for dizygotic twins.

The script will also randomly assign a gender to each twin, or twin pair.

Necessarily, monozygotic twins will always be the same gender. Dizygotic twins can be male/male,
female/female or male/female twin pairs.

Necessarily, twin pairs will always be the same age.

Phenotypes are normally distributed.

Age is a truncated poisson distribution (max 120). A minimum age can be set (optional). If no
minimum age is set, the defaul minimum is zero , however:

*technically there in **no** minimum. By default the min age is
set to `-Inf`, however a poisson distribution is probability distribution of positive discrete values by
definition, so the minimum will always be zero - **however however**:*

*If you set the minimum value of a simulated truncated poisson to
`zero`, the simulated distribution will **not** be the same as a standard poisson - in R at least.*

Each dataframe will contain 5 columns:

- `twin1` - the phenotype for twin one (which can be thought of as the 'first born' twin)
- `twin2` - the phenotype for twin two (which can be thought of as the 'second born' twin)
- `sex1` - the sex of twin 1
- `sex2` - the sex of twin 2
- `age1` - the age of twin 1
- `age2` - the age of twin 2 (which is necessarily the same as twin1, in real samples it's not biologically
  necessary for twins to be born on the same day, but it's very unlikely they will be born in a different year)
- `zyg` - the zygosity status according to sex.

`mzm` = monozygotic males  
`mzf` = monozygotic females  
`dzm` = dizygotic male pair  
`dzf` = dizygotic female pair  
`dzM` = dizygotic twin pair, first born is male  
`dzF` = dizygotic twin pair, first born is female  

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

- the ability to simulate sex-limitation effects
- the inclusion of 1 or more siblings
