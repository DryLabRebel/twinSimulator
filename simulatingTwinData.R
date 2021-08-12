#!/usr/bin/env Rscript

suppressMessages(suppressWarnings(library(R.utils, quietly = T)))
suppressMessages(suppressWarnings(library(extraDistr, quietly = T)))
# Accept command line arguments

# argin
labs <- c("mzr", "dzr", "N", "age", "minage", "maxage")
defaults <- c(0.8, 0.4, 1000, 25, -Inf, 120)

args <- commandArgs(trailingOnly = TRUE, asValues = T, args = labs)

# Documentation
cat("\nCorrelated twin data simulator.\nAccepts three inputs:\n  --mzr (MZ correlation)\n  --dzr (DZ correlation)\n  --N (number of twin pairs)\n  --age (mean age of whole sample)\n  --minage (minimum age)\n  --maxage (maximum age)\n\n")
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

for (i in length(labs)) do {

if (is.null(args[[paste(labs[i], sep="")]]) == T) {
  cat("No ", paste(labs[i], sep=""), " detected. Default (", paste(as.character(defaults[i]), sep=""),") will be used.\n\n")
  labs[i] <<- defaults[i]
} else {
  labs[i] <<- as.numeric(args$labs[i])
}

# Ah, this probs won't work - I'll need a list I think - surprise, surprise
# What do I want to do? I want to assign the value of default, to the variable name, from the 'list' labs
# Maybe a bit over the top though? I don't have/want a data frame. I just want to assign a value, to a variable, and I want multiple variables?

# if (is.null(args[["dzr"]]) == T) {
#   cat("No DZ correlation detected. Default (0.4) will be used.\n\n")
#   dzr <<- 0.4
# } else {
#   dzr <<- as.numeric(args$dzr)
# }
# 
# if (is.null(args[["N"]]) == T) {
#   cat("No sample size detected. Default (1000) will be used.\n\n")
#   N <<- 1000
# } else {
#   N <<- round(as.numeric(args$N), 0)
# }
# 
# if (is.null(args[["age"]]) == T) {
#   cat("No mean age detected. Default (25) will be used.\n\n")
#   age <<- 25
# } else {
#   age <<- round(as.numeric(args$age), 0)
# }
# 
# if (is.null(args[["minage"]]) == T) {
#   cat("No minimum age detected. Default (0) will be used.\n\n")
#   minage <<- -Inf
# } else {
#   minage <<- round(as.numeric(args$minage), 0)
# }
# 
# if (is.null(args[["maxage"]]) == T) {
#   cat("No maximum age detected. Default (120) will be used.\n\n")
#   maxage <<- 120
# } else {
#   maxage <<- round(as.numeric(args$maxage), 0)
# }

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
} else if (is.na(age) == T) {
  stop(
       "Bad input. Your age is not a numeric value\n\n", call. = FALSE
 )
} else if (is.na(minage) == T) {
  stop(
       "Bad input. Your minage is not a numeric value\n\n", call. = FALSE
 )
} else if (is.na(maxage) == T) {
  stop(
       "Bad input. Your maxage is not a numeric value\n\n", call. = FALSE
 )
}   

# sanity test for input
if (mzr < (-1) | mzr > 1) {
  stop(
       "Bad input. Your MZ correlation is out of bounds.
       Please enter a number between -1 and 1
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N, --age, --minage, --maxage.\n\n", call. = FALSE
 )
} else if (dzr < (-1) | dzr > 1) {
  stop(
       "Bad input. Your DZ correlation is out of bounds.
       Please enter a number between -1 and 1 for both
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N, --age, --minage, --maxage.\n\n", call. = FALSE
 )
} else if (N <= 1) {
  stop(
       "Bad input. Your sample size is less than two, or is not a whole number.
       Please ensure N is a whole number >= 2
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N, --age, --minage, --maxage.\n\n", call. = FALSE
 )
} else if (age < 0 | age > 120) {
  stop(
       "Bad input. Your mean age is out of bounds.
       Please ensure mean age is a whole number between zero and 120.
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N, --age, --minage, --maxage.\n\n", call. = FALSE
 )
} else if ((minage != -Inf & minage < 0) | minage > 120) {
  stop(
       "Bad input. Your minimum age is out of bounds
       Please ensure mean age is a whole number between zero and 120.
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N, --age, --minage, --maxage.\n\n", call. = FALSE
 )
} else if (maxage < 0 | maxage > 120) {
  stop(
       "Bad input. Your maximum age is out of bounds
       Please ensure mean age is a whole number between zero and 120.
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N, --age, --minage, --maxage.\n\n", call. = FALSE
 )
} else if (minage > age) {
  stop(
       "Bad input. You can't have a mean age less than your minimum age group dummy.
       Please ensure mean age is larger than or equal to your minimum age
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N, --age, --minage, --maxage.\n\n", call. = FALSE
 )
} else if (age > maxage) {
  stop(
       "Bad input. You can't have a mean age that exceeds your maximum age group dummy.
       Please ensure mean age is less than or equal to your maximum age
       and/or please ensure you used the correct values for each flag: --mzr, --dzr, --N, --age, --minage, --maxage.\n\n", call. = FALSE
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

if (N >= 1000000) {
  cat("You've specified a sample size of 1 million or more. This may take a while.\n\n")
}

if (minage == maxage) {
  cat("Your min and max age are the same. Your sample will all be the same age. Was this intentional?\n\n")
}

library(MASS, quietly = T)
# library(tidyverse, quietly = T)
# library(dplyr, quietly = T)
# library(GGally, quietly = T)

cat("No of arguments supplied:\n")
cat(paste(length(args), sep=""), "\n\n")

cat("mzr:\n")
cat(paste(mzr, sep=""), "\n\n")

cat("dzr:\n")
cat(paste(dzr, sep=""), "\n\n")

cat("Sample size:\n")
cat(paste(N, sep=""), "\n\n")

cat("mean age:\n")
cat(paste(age, sep=""), "\n\n")

cat("lbound age:\n")
cat(paste(minage, sep=""), "\n\n")

cat("ubound age:\n")
cat(paste(maxage, sep=""), "\n\n")

# set.seed(5)

mzr <- 0.8
dzr <- 0.4
N <- 1000
age <- 25
minage <- -Inf
maxage <- 120

# create a variance covariance matrix for MZs and DZs
mzCov <- rbind(c(1, mzr), c(mzr, 1))
dzCov <- rbind(c(1, dzr), c(dzr, 1))

# create the mean vector
MZmu <- c(10, 10)
DZmu <- c(11, 11) 

# generate the multivariate normal distribution
mz <- as.data.frame(round(mvrnorm(n = N, mu = MZmu, Sigma = mzCov), 2))
dz <- as.data.frame(round(mvrnorm(n = N, mu = DZmu, Sigma = dzCov), 2))

names(mz)[names(mz) == "V1"] <- "twin1"
names(mz)[names(mz) == "V2"] <- "twin2"

names(dz)[names(dz) == "V1"] <- "twin1"
names(dz)[names(dz) == "V2"] <- "twin2"

# Super informative Stack post - https://stats.stackexchange.com/questions/336166/what-is-the-difference-between-dbinom-and-dnorm-in-r

sexmz <- rbinom(n = N, 1, 0.5)

mz$sex1 <- sexmz
mz$sex2 <- mz$sex1 # You could use 'sexmz' here too, but this way you are explicitly duplicating the gender of twin 1
dz$sex1 <- rbinom(n = N, 1, 0.5)
dz$sex2 <- rbinom(n = N, 1, 0.5)

# OK, I think I've got it. I think a poisson distribution is what I'm looking for - trucated is preferred - can specify a max age and/or a minimum age for study recruitment
  # I could do a multivariate normal, which would probably by fine, but unless I'm specifying the exact time of birth, then I just want discrete, non-negative, values with a mean
  # I could potentially do a binomial also, but unless I'm going for a mean age, that is around the middle of human life (what like 35-40?), then an approximately normal distribution seems a little unrealistic
  # I could also just randomly generate values within a range with a uniform distribution (runif), but that seems unrealistic too
  # When working with human twin data, I'm going to have a mean, and the ditribution will be non-uniform
  # If I assume the sample is mostly children (because I work mostly with child/adolescent data so I'm clearly biased), then a poisson will probably be the best approximation?

# OK, weird. poisson is limited at zero by definition, but if I use a truncated poisson, the distribution changes, compared to one with no lower bound
# The distribution with min = 0 produces *more* values that = zero (as if the sampling distribution overlaps zero, and is then truncated, rather than a sampling distributions which by definition is always zero or positive...
# Yep, just make the min -Inf - min will still be zero, but distribution will be a standard poisson

mzage <- rtpois(n = N, lambda = age, a = minage, b = maxage)
dzage <- rtpois(n = N, lambda = age, a = minage, b = maxage)

# OK so... I Want
  # optional min and max age - default min (0), default max (120)

# Need to:
  # Error when minage is > mean
  # Error when mean is > maxage
  # Error any age input is not a positive integer
  # Need to fix - currently no minimum age Error - because if I set it to < 0, it flags the default value (-Inf)
  # Need to specify if < 0, except when '-Inf'

# Hang on... I don't really want a different mean age for mz and dz. If I want to introduce age effects, then I want a correlation between a phenotype, and the age
# Let's figure that out later... maybe

mz$age1 <- mzage
mz$age2 <- mz$age1 # again makes it explicit - the twins are the same age

dz$age1 <- dzage
dz$age2 <- dz$age1 # again makes it explicit - the twins are the same age

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

twindat <- rbind(mz, dz)

twindat$FID <- sample(c(100000:999999), length(twindat[,1]), replace = F)

# names(twindat)[twindat == "V2"] <- "twin2"

twindat <- twindat[, c(8,7,1,3,5,2,4,6)]

head(twindat)
tail(twindat)

write.table(
            twindat,
            "data/twindat.txt",
            col.names = T,
            row.names = F,
            sep = "\t",
            append = F,
            quote = F
            )

# tidy up the above
# *Check* (17-05-2021) - # give your columns names
# *Check* (17-05-2021) - # add in some conditions - default values, checks for bad input, etc.
# *Check* (19-05-2021) - # find a way to uniquely specify arguments, so you can leave MZ blank, but still input dzr and/or N, so MZ uses default

# Hang on. Sex is not quite so simple. I need to assign a sex value to each individual - and then need a way to determine zygosity
# Ah, no, only for dz. For MZ the sex will be the same in every case
# So what do I need to do?
# I need a zygosity column - "01" mzf, "02" mzm, "03" dzf, "04" dzm, "05" dzo
# I need to create a sex column for each twin
# for mzs, I need the same value in each column
# for dzs, I can randomly assign the values. So... if I just randomly assign 0's and 1's to each twin... it will be 50% dzo. Yep. Which is probably biologically realistic... is it?
# So, the simplest thing would be to just duplicate the mz sex column, and run two separte dz columns
# *Check* (21-05-2021) - # add in sex variables

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
# *Check* (25-05-2021) - # add in age variables

# *Check* (21-05-2021) - # add in zyg ID

# add in FID and IID
  # So, do I want randomly generated values
  # Or do I just want to start at 1,000,000,000 and add values?
# OK, so ID's would be more useful if they could
  # Be expanded to include batches (multiple rounds of recruitment)
    # So, you would like a way to identify the data wave
    # You would like to ensure ongoing batches do not create duplicate IDs with previous ones
  # Structured - to help indicate multiple rounds of data collection
    # Participant location (if multiple data collection locations)
    # Data collection at multiple time points
  # Layered IDs - multiple ID streams to help anonymize sensitive data and maintain multiple identifiers for personal and/or study (phenotype) data
# So for my dataset - I might want to include an 'append/overwrite' option
  # I can make provisions for my simulator to indicate a study wave component in the ID generation
  # So you can call the program on multiple occasions and either append/overwrite data, but ensure unique IDs will be created, and will not lead to duplicates in a previous round of data generation
  # Maybe, I can make it so you can create multiple datasets, all with their own unique IDs
  # ***would it be possible to create multiple datasets, which include *overlapping* data!? So I can get the 'same' IDs back to collect more/new/different data?!
    # That woudl be CoOl!

# How do I make this whole thing better?
  # More maintainable
  # More scalable
  # More professional/legitimate?
  # Create functions - in separate files
  # Improve the documentation
    # Create an official documentation!

# OK... can I just create some unique UUIDs for each sample?
  # Start simple - just create unique IDs for each family using sample.

# *Check* (25-05-2021) - # rbind into 1 fam per line

# *Check* (25-05-2021) - # save output as a *.txt file - use 'args' as filename - Twimsim_mzr[mzr]_dzr[dzr]_N[N].txt

# *Check* (25-05-2021) - # when printing, suppress the '[1]' at the beginning of the line - i.e just print the output, as output

# Randomly generate NAs in the data

# What else? I could produce data summaires? Or I could do that in another script

# I could introduce some loops to simplify and improve the code

# Do the same thing in python
# Do the same thing in bash
# Do the same thing in C++

# Start creating training datasets for Machine learning projects!

