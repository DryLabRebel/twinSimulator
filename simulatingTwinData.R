#!/usr/bin/env Rscript

suppressMessages(suppressWarnings(library(R.utils, quietly = T)))
# Accept command line arguments
args <- commandArgs(trailingOnly = TRUE, asValues = T, args = c("mzr", "dzr", "N"))

# Documentation
cat("\nCorrelated twin data simulator.\nAccepts three inputs, --mzr (MZ correlation), --dzr (DZ correlation), --N (number of twin pairs).\n\n")
cat("Twins are randomly assigned a gender and zygosity status, \"1\" for males and \"0\" for females.\n\n")
cat("'mzm' = monozygotic males\n")
cat("'mzf' = monozygotic females\n")
cat("'dzm' = dizygotic male pair\n")
cat("'dzf' = dizygotic female pair\n")
cat("'dzM' = dizygotic twin pair, first born is male\n")
cat("'dzF' = dizygotic twin pair, first born is female\n\n")
# store current output warnings setting
oldw <- getOption("warn")

# Suppress warnings: will throw a warning if a non-numeric is entered - but I have my own warnings below, which are clearer which are more user friendly
options(warn = -1)
if (is.null(args[["mzr"]]) == T) {
  cat("No MZ correlation detected. Default (0.8) will be used.\n\n")
  mzr <<- 0.8 #Number of twin pairs
} else {
  mzr <<- as.numeric(args$mzr)
}

if (is.null(args[["dzr"]]) == T) {
  cat("No DZ correlation detected. Default (0.4) will be used.\n\n")
  dzr <<- 0.4 #Number of twin pairs
} else {
  dzr <<- as.numeric(args$dzr)
}

if (is.null(args[["N"]]) == T) {
  cat("No sample size detected. Default (1000) will be used.\n\n")
  N <<- 1000 #Number of twin pairs
} else {
  N <<- as.numeric(args$N)
}
# reactivate warnings
options(warn = oldw)

# Checking for bad/non-numeric input
if (is.na(mzr) == T) {
  stop(
       "Bad input. Your MZ correlation is not a numeric value\n\n", call. = FALSE
 )
} else if (is.na(dzr) == T) {
  stop(
       "Bad input. Your DZ correlation is not a numeric value\n\n", call. = FALSE
 )
} else if (is.na(N) == T) {
  stop(
       "Bad input. Your sample size is not a numeric value\n\n", call. = FALSE
 )
} 

# sanity test for input
if (mzr < (-1) | mzr > 1) {
  stop(
       "Bad input. Your MZ correlation is out of bounds.
       Please enter a number between -1 and 1
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N.\n\n", call. = FALSE
 )
} else if (dzr < (-1) | dzr > 1) {
  stop(
       "Bad input. Your DZ correlation is out of bounds.
       Please enter a number between -1 and 1 for both
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N.\n\n", call. = FALSE
 )
} else if (N <= 1) {
  stop(
       "Bad input. Your sample size is only one or less, or is not a whole number.
       Please ensure N is a whole number >= 2
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N.\n\n", call. = FALSE
 )
} 

if (mzr < dzr) {
# Warnings regarding unlikely or unlikely twin pair correlations
  cat("WARNING: supplied DZ correlation is larger than MZ correlation, this is unlikely (but not impossible). Was this intentional?\n\n")
} 

if (mzr < 0) {
  cat("WARNING: supplied MZ correlation is less than zero, in real world data this is very unlikely (but not impossible). Was this intentional?\n\n")
} 

if (dzr < 0) {
  cat("WARNING: supplied DZ correlation is less than zero, in real world data this is unlikely (but not impossible). Was this intentional?\n\n")
}

library(MASS, quietly = T)
# library(tidyverse, quietly = T)
# library(dplyr, quietly = T)
# library(GGally, quietly = T)

cat("No of arguments supplied:\n")
cat(paste(length(args)), "\n\n")

cat("mzr:\n")
cat(paste(mzr), "\n\n")

cat("dzr:\n")
cat(paste(dzr), "\n\n")

cat("Sample size:\n")
cat(paste(N), "\n\n")

set.seed(5)

# create a variance covariance matrix for MZs and DZs
mzCov <- rbind(c(1, mzr), c(mzr, 1))
dzCov <- rbind(c(1, dzr), c(dzr, 1))

# create the mean vector
MZmu <- c(10, 10)
DZmu <- c(11, 11) 

# generate the multivariate normal distribution
mz <- as.data.frame(mvrnorm(n = N, mu = MZmu, Sigma = mzCov))
dz <- as.data.frame(mvrnorm(n = N, mu = DZmu, Sigma = dzCov))

# Super informative Stack post - https://stats.stackexchange.com/questions/336166/what-is-the-difference-between-dbinom-and-dnorm-in-r

sexmz <- rbinom(n = N, 1, 0.5)

mz$sex1 <- sexmz
mz$sex2 <- mz$sex1 # You could use 'sexmz' here too, but this way you are explicitly duplicating the gender of twin 1
dz$sex1 <- rbinom(n = N, 1, 0.5)
dz$sex2 <- rbinom(n = N, 1, 0.5)

mz$zyg[mz$sex1 == 1]  <- "mzm"
mz$zyg[mz$sex1 == 0]  <- "mzf"

dz$zyg[
       dz$sex1 == 1 &
       dz$sex2 == 1
       ]  <- "dzm"

dz$zyg[
       dz$sex1 == 0 &
       dz$sex2 == 0
       ]  <- "dzf"

dz$zyg[
       dz$sex1 == 1 &
       dz$sex2 == 0
       ]  <- "dzM"

dz$zyg[
       dz$sex1 == 0 &
       dz$sex2 == 1
       ]  <- "dzF"

names(mz)[names(mz) == "V1"] <- "twin1"
names(mz)[names(mz) == "V2"] <- "twin2"

names(dz)[names(dz) == "V1"] <- "twin1"
names(dz)[names(dz) == "V2"] <- "twin2"

head(mz)
head(dz)

# tidy up the above
# *Check* (17-05-2021) - # give your columns names
# *Check* (17-05-2021) - # add in some conditions - default values, checks for bad input, etc.
# *Check* (19-05-2021) - # find a way to uniquely specify arguments, so you can leave MZ blank, but still input dzr and/or N, so MZ uses default
# find a way to optionally specify arguments without a flag - iff they are in the correct order?
  # Maybe I don't need to do this?
  # Maybe it would be even better if it was an interactive program that could be executed, and accept input
  # This way I could start with instructions, and have the user input the information they're interested in?

# *Check* (21-05-2021) - # add in sex variables

# Hang on. Sex is not quite so simple. I need to assign a sex value to each individual - and then need a way to determine zygosity
# Ah, no, only for dz. For MZ the sex will be the same in every case
# So what do I need to do?
# I need a zygosity column - "01" mzf, "02" mzm, "03" dzf, "04" dzm, "05" dzo
# I need to create a sex column for each twin
# for mzs, I need the same value in each column
# for dzs, I can randomly assign the values. So... if I just randomly assign 0's and 1's to each twin... it will be 50% dzo. Yep. Which is probably biologically realistic... is it?
# So, the simplest thing would be to just duplicate the mz sex column, and run two separte dz columns

# add in age variables

# What do I want to do?
# Create an age variable for my twin pairs
# Do I want to just randomly assign an age (with a mean and sd) for each row of my dataset?
  # Well, if I want there to be an age dependent effect then maybe I'd want it to be correlated with my twin variables?
  # I could specify an optional age effect parameter - so the correlated variables would be randomly generated, but weighted by age?
  # Lets just start simple...
    # Generate a random vector of age variables of length N ( or dob? ) - so age could be dependent on some future variable (date of data collection!)
# When you run a twin study - what kinds of things are common?
  # You're looking for a miminum age?
  # You're looking for an age range?

# *Check* (21-05-2021) - # add in zyg ID

# add in FID and IID

# rbind into 1 fam per line

# save output as a *.txt file - use 'args' as filename - Twimsim_mzr[mzr]_dzr[dzr]_N[N].txt

# when printing, suppress the '[1]' at the beginning of the line - i.e just print the output, as output

# Don't take forever - get something that works, and shows off a few things
# What next?
# Web development?

# Do the same thing in python
# Do the same thing in bash
# Do the same thing in C++

