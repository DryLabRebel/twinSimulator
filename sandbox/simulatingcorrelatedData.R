# ----------------------

# An example

library( MASS )
library( tidyverse )
library( dplyr )
library( GGally )

set.seed( 5 )

# create the variance covariance matrix

sigma <- rbind( c( 1, -0.8, -0.7 ), c( -0.8, 1, 0.9 ), c( -0.7, 0.9, 1 ))
# Ah, yeah really simple actually

# Ah ok ok ok ok... so you start with the v/Cov matrix, and generate the data
# As opposed to generating the v/Cov matrix using data - so obvious now!
# Now I'm thinkin there's probably a nice way to do this in OpenMx

# create the mean vector
mu <- c( 10, 5, 2 ) 

# generate the multivariate normal distribution
df <- as.data.frame( mvrnorm( n=1000, mu=mu, Sigma=sigma ))

# So...
# But what exactly happens here?

#NOTE: 
# You need to learn more about:
  # Eigenvectors
  # Refresh on geometry - sine, cosine, etc.
  # Linear algebra
# You need to just start shitposting on your GitHub site
  # You can just write about whatever you want
  # Make an effort to talk about interesting relevant things
  # Have *zero* expectations about anyone ever reading it, except maybe some head hunter


head( df )
# OK, well that was easy.

# So, now I should have, in theory, the means to create an arbitrary number of simulated twin pair data sets, and modify my existing scripts to 

ggpairs( df )
