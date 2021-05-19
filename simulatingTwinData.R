#!/usr/bin/env Rscript

suppressMessages(suppressWarnings(library(R.utils, quietly = T)))
# Accept command line arguments
args <- commandArgs(trailingOnly = TRUE, asValues = T, args = c("mzr", "dzr", "N"))

# Documentation
cat("\nCorrelated twin data simulator.\nAccepts three inputs, --mzr (MZ correlation), --dzr (DZ correlation), --N (number of twin pairs).\n\n")

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
       and/or please ensure you entered your arguments in order: mzr, dzr, N.\n\n", call. = FALSE
 )
} else if (dzr < (-1) | dzr > 1) {
  stop(
       "Bad input. Your DZ correlation is out of bounds.
       Please enter a number between -1 and 1 for both
       and/or please ensure you entered your arguments in order: mzr, dzr, N.\n\n", call. = FALSE
 )
} else if (N <= 1) {
  stop(
       "Bad input. Your sample size is only one or less, or is not a whole number.
       Please ensure N is a whole number >= 2
       and/or please ensure you entered your arguments in order: mzr, dzr, N.\n\n", call. = FALSE
 )
} else if (mzr < dzr) {
# Warning when MZ correlation is less than DZ correlation - might happen if user inputs correlation in the wrong order
  cat("WARNING: supplied DZ correlation is larger than MZ correlation, this is unusual (but not impossible). Was this intentional? Please ensure you entered your arguments in order: mzr, dzr, N.\n\n")
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

names(mz)[names(mz) == "V1"] <- "twin1"
names(mz)[names(mz) == "V2"] <- "twin2"

names(dz)[names(dz) == "V1"] <- "twin1"
names(dz)[names(dz) == "V2"] <- "twin2"

mz$zyg <- "mz"
dz$zyg <- "dz"

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

# add in age and sex variables

# add in zyg ID

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

