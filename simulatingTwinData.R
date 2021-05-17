#!/usr/bin/env Rscript

args <- commandArgs( trailingOnly = TRUE )

print("Correlated twin data simulator. Accepts three inputs, must be in order: MZr (MZ correlation), DZr (DZ correlation), N (number of twin pairs).", quote=F)

oldw <- getOption("warn")

options(warn = -1)
if ( is.na( args[1] ) == T ) {
  print( "No MZ correlation detected. Default ( 0.8 ) will be used.", quote = F )
  MZr <<- 0.8 #Number of twin pairs
} else {
  MZr <<- as.numeric( args[1] )
}

if ( is.na( args[2] ) == T ) {
  print( "No DZ correlation detected. Default ( 0.4 ) will be used.", quote = F )
  DZr <<- 0.4 #Number of twin pairs
} else {
  DZr <<- as.numeric( args[2] )
}

if ( is.na( args[3] ) == T ) {
  print( "No sample size detected. Default ( 1000 ) will be used.", quote = F )
  N <<- 1000 #Number of twin pairs
} else {
  N <<- as.numeric( args[3] )
}
options(warn = oldw)

# Checking for bad input

if ( is.na(MZr) == T ) {
  stop( 
       "Bad input. Your MZ correlation is not a numeric value", call. = FALSE
  )
} else if ( is.na(DZr) == T ) {
  stop( 
       "Bad input. Your DZ correlation is not a numeric value", call. = FALSE
  )
} else if ( is.na(N) == T ) {
  stop( 
       "Bad input. Your sample size is not a numeric value", call. = FALSE
  )
} 

# sanity test for MZ correlation
if ( MZr < ( -1 ) | MZr > 1 ) {
  stop( 
       "Bad input. Your MZ correlation is out of bounds. 
       Please enter a number between -1 and 1
       and/or please ensure you entered your arguments in order: MZr, DZr, N.", call. = FALSE
  )
} else if ( DZr < ( -1 ) | DZr > 1 ) {
  stop( 
       "Bad input. Your DZ correlation is out of bounds. 
       Please enter a number between -1 and 1 for both 
       and/or please ensure you entered your arguments in order: MZr, DZr, N.", call. = FALSE
  )
} else if ( N <= 1 ) {
  stop( 
       "Bad input. Your sample size is less than zero, or is not a whole number. 
       Please ensure N is a whole number >= 2
       and/or please ensure you entered your arguments in order: MZr, DZr, N.", call. = FALSE
  )
} else if ( MZr < DZr ) {
# Warning when MZ correlation is less than DZ correlation - might happen if user inputs correlation in the wrong order
  print( "supplied DZ correlation is larger than MZ correlation, this is unusual ( but not impossible ). Please ensure you entered your arguments in order: MZr, DZr, N.", quote = F )
}

library( MASS )
# library( tidyverse )
# library( dplyr )
# library( GGally )

print( "No of arguments supplied:", quote = F )
print( paste( length( args )), quote = F )

print( "MZr:", quote = F )
print( paste( MZr ), quote = F )

print( "DZr:", quote = F )
print( paste( DZr ), quote = F )

print( "Sample size:", quote = F )
print( paste( N ), quote = F )

set.seed( 5 )

# create a variance covariance matrix for MZs and DZs
mzCov <- rbind( c( 1, MZr ), c( MZr, 1 ))
dzCov <- rbind( c( 1, DZr ), c( DZr, 1 ))

# create the mean vector
MZmu <- c( 10, 10 )
DZmu <- c( 11, 11 ) 

# generate the multivariate normal distribution
mz <- as.data.frame( mvrnorm( n = N, mu = MZmu, Sigma = mzCov ))
dz <- as.data.frame( mvrnorm( n = N, mu = DZmu, Sigma = dzCov ))

names( mz )[names( mz ) == "V1"] <- "twin1"
names( mz )[names( mz ) == "V2"] <- "twin2"

names( dz )[names( dz ) == "V1"] <- "twin1"
names( dz )[names( dz ) == "V2"] <- "twin2"

head( dz )
head( mz )

# tidy up the above
# give your columns names
# add in age and sex variables
# add in some conditions - default values, checks for bad input, etc.

# Don't take forever - get something that works, and shows off a few things
# What next?
# Web development?

# Do the same thing in python
# Do the same thing in bash
# Do the same thing in C++

