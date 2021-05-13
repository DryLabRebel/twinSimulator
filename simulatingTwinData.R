#!/usr/bin/env Rscript

library( MASS )
library( tidyverse )
library( dplyr )
library( GGally )

N=5000 #Number of twin pairs

mean=0
sd=1

MZr=0.8 #monozygotic (MZ) twin correlation
DZr=0.4 #dizygotic (DZ) twin correlation
# Note in a twin study, this will produce a perfect AE model with a heritability of pretty much exactly 0.8

# ----------------------

# I should really figure out why this is important - my best understanding is it allows you to reproduce your randomly generated variables
set.seed( 5 )

# create a variance covariance matrix for MZs and DZs
mzCov <- rbind( c( 1, MZr ), c( MZr, 1 ))
dzCov <- rbind( c( 1, DZr ), c( DZr, 1 ))

# Ah ok ok ok ok... so you start with the v/Cov matrix, and generate the data
# As opposed to generating the v/Cov matrix using data - so obvious now!
# Now I'm thinkin there's probably a nice way to do this in OpenMx

# create the mean vector
mu <- c( 10, 11 ) 

# generate the multivariate normal distribution
mz <- as.data.frame( mvrnorm( n=1000, mu=mu, Sigma=mzCov ))
dz <- as.data.frame( mvrnorm( n=1000, mu=mu, Sigma=dzCov ))

head(dz)
head(mz)

# I did it.. I just simulated some twin data!
# that was amazingly easy

# Now what?

# Don't stop now. What else do you want to be able to do?

# tidy up the above
# give your columns names
# add in age and sex variables

# make it better, more generalizable
# I could make it executable
  # You could simlate and save datasets and inpute whatever correlations you want to!
  # probably not even that hard!

# Produce some distributions and summary statistics

# Do the same thing in python

# Do some twin analyses

# Start getting complicated
# Create some sex effects
# Do some sex limitation

# Create qualitative sex limitation

# Create multiple variables

# Run some power anlayses


