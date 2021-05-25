Twin Simulator
==============

A portfolio project.

A simple R script which randomly generates correlated twin data for identical (monozygotic) and
non-identical (dizygotic) twins with basic error checking functionality.

This script accepts six named arguments:

- `--mzr` (the monozygotic twin correlation; default = 0.8)
- `--dzr` (the dizygotic twin correlation; default = 0.4)
- `--n`   (the number of monozygotic *and* dizygotic twins; default = 1000)
- `--age` (the mean age of the whole sample (poisson distribution); default = 25)
- `--minage` (the minimum age of the whole sample; default = 0)
- `--maxage` (the mean age of the whole sample; default = 25, sd is fixed at 5)

NOTE: The sample size represents the number of twin 'families' per zygosity, so N = 1000 will generate 1000 monozygotic and 1000 dizygotic twin pairs, which becomes 4000 individuals in total.

All six arguments are optional. The program will use default values for any/all missing inputs.

To execute the script you must have R installed, and the R packages `Rutils`, `extraDistr` and `MASS` installed.

By executing the script with one or more flags, the script will randomly generate pairs of correlated values
for both monozygotic and dizygotic twins according to the specified values, equal to the number of samples specified
(designated either by the input provided, or by the assigned defaults).

The script will generate a dataframe containing monozygotic and dizygotic twins each with the number of twin pairs
equal to N

It will randomly assign a six digit unique ID to each pair of twins (each family).

The script will also randomly assign a gender to each twin, or twin pair.

Necessarily, monozygotic twins will always be the same gender. Dizygotic twins will be male/male,
female/female or male/female twin pairs.

Necessarily, twin pairs will always be the same age.

Phenotypes are normally distributed.

Age is in years, and uses a truncated poisson distribution (max 120). A minimum age can be set (optional). If no
minimum age is set, the defaul minimum is zero.

*NOTE: technically there in **no** minimum; actually the default min age is
set to `-Inf`, however a poisson distribution is a probability distribution of positive discrete values by
definition, so the minimum will always be zero*

*ALSO NOTE: If you manually set the minimum value of a simulated truncated poisson to
`zero`, the resulting distribution will **not** be the same as a standard poisson*

Each dataframe will contain 8 columns:

- `twin1` - the phenotype for twin one (which can be thought of as the 'first born' twin)
- `twin2` - the phenotype for twin two (which can be thought of as the 'second born' twin)
- `sex1` - the sex of twin 1
- `sex2` - the sex of twin 2
- `age1` - the age of twin 1
- `age2` - the age of twin 2 (which is necessarily the same as twin1)
- `zyg` - the zygosity of each twin pair
- `FID` - a randomly generated, unique six digit ID for each row (family)

Zygosity:

`mzm` = monozygotic males  
`mzf` = monozygotic females  
`dzm` = dizygotic male pair  
`dzf` = dizygotic female pair  
`dzM` = dizygotic twin pair, first born is male  
`dzF` = dizygotic twin pair, first born is female  

Usage:
------

Download the script `simulatingTwinData.R` into some directory. Inside the same directory, create a new
folder/directory named `data` - R will save the simulated dataset into this directory.

From inside the same directory as the script, on the command line enter:

`$./simulatingTwinData.R`

This will simulate a twin dataset with the default values.

To specify custom values enter:

`$./simulatingTwinData.R --mzr=X --dzr=Y --N=Z --age=W --minage=V --maxage=U`

where X, Y, Z, W, V and U are numerical values. If non numerical values are entered, the program will throw and error
and exit.

The flags can be entered in any order.

`mzr` and `dzr` *must* be a numeric value between -1 and 1, otherwise the program will throw and error and exit.

`N` *must* be a positive integer >= 2, otherwise the program will throw and error and exit.

`age`, `minage` and `maxage` must all be positive integers >= zero and <= 120, otherwise the program will throw an error and exit.

If `mzr` is less than `dzr` the program will warn you that in real world datasets this is unusual (but not impossible).

If N >= 1M the program will let you know that this is a large number of simualtions, and may take some time to complete.

Future planned functionality:

- the ability to simulate sex-limitation effects
- the inclusion of 1 or more siblings
