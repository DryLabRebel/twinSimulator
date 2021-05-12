## 12/02/16 Meeting

## basic simulation of a phenotype
N = 1000 #Number of individuals
h2_1 = 0.8 #Heritability score in environment 1
h2_2 = 0.8 #Heritability score in environment 2 #This was later changed to simulate phenotypes in different environments with a correlation of 1 (no GxE-interactions).
e_1 = (1 - h2_1) #Environment 1 contribution
e_2 = (1 - h2_2) #Environment 2 contribution
g1 <- rnorm(N, 0, sd=sqrt(h2_1)) #Generating 1000 genotypes randomly from a normally distributed population using Heritability score 1
e1 <- rnorm(N, 0, sd=sqrt(e_1)) #Generating 1000 environmental scores randomly from a normally distributed population Environmental score 1
g2 <- rnorm(N, 0, sd=sqrt(h2_2))#Generating 1000 genotypes randomly from a normally distributed population using Heritability score 2
e2 <- rnorm(N, 0, sd=sqrt(e_2)) #Generating 1000 environmental scores randomly from a normally distributed population Environmental score 2
y1 <- g1 + e1 #Generating 1000 phenotypes randomly from the 1st normally-distributed-randomly-generated-genotype-envirotype-compiled population
y2 <- g2 + e2 #Generating 1000 phenotypes randomly from the 2nd normally-distributed-randomly-generated-genotype-envirotype-compiled population

library(MASS) #Loading a software program to allow R to perform multivariate analyses on the data
rg <- 0.9999          # simulated genetic correlation between the two populations
cov_g <- rg * sqrt(h2_1) * sqrt(h2_2)   # genetic covariance. ## The covariance is the product of the correlation and the standard deviations of each population
cov_g
gmat <- matrix(c(h2_1, cov_g, cov_g, h2_2),2,2) # genetic variance-covariance matrix with the heritability diagonally opposite and the covariances diagonally opposite
emat <- matrix(c(1-h2_1, 0, 0, 1-h2_2),2,2) # Why are there zero's here? Is it because you're assuming that the environments are independant from each other, and hence there's no covariance?
g <- mvrnorm(N,c(0,0),gmat) #A multivariate normal distribution of the genotype matrix. This is asking R to randomly generate N genotypes, while each time duplicating a close approximation of each
#selection for the purpose of producing 2 nearly identical genotypes at a time, 1000 times.
#to simulate testing the population in two different environments
e <- mvrnorm(N, c(0,0),emat) #A multivariate normal distrubution of the environment matrix. This is asking R to randomly generate N environments, while each time duplicating a close approximation of each selection to simulate testing the population in two different environments
y1 <- g[,1] + e[,1] #This is generating a phenotype based on the data from all rows of the first column of the g matrix. Before the comma is the 'row' information. So for this example
#R will take the information from all rows and calculate a phenotype for each one. It will take the information from the first column (the effect score).
y2 <- g[,2] + e[,2] #Same as above for environment and genotype two, which in this example is the same, since the heritability is the same.

summary(lm(y1 ~ g[,1])) #What does g[,1] mean here?
summary(lm(y2 ~ g[,2])) #Same question.

plot(lm(y2 ~ g[,2]))

help(c) #Combines values into a vector or list.
gmat
emat




head(g)
e
help(mvrnorm)
y1
y2

plot(y1, y2)


## SNP-level
M=100 #Simulated number of SNPs?
bmat <- gmat/M #an effect score matrix based on the genotype matrix averaged over 100 SNPs?
bmat
b <- mvrnorm(M, c(0,0),bmat) #Simulating 100 individual SNP effects from a random distrubtion of effects based on the average effect size (bmat), twice (one for each relevantly similar pair of individuals split into two environments - with the same heritability) - the different environments are the 'two (possibly correlated) vectors'?? Is bmat the sd in this example??
head(bmat)
head(b)

plot(b) #The reason this looks like a straight line is because the heritability is the same for each population, hence the covariance is ~1.
hist(b)
u <- (b[,1]) #I just made these up, just assigning a name to each population. I made a histogram of each of these and saw again that they were *very similar.
v <- (b[,2]) #I got a warm fuzzy feeling when I did this and understood what I was doing (i.e. I was creating a vector based on N rows from column 1 and 2 of the bmat matrix respectively)
plot(u, v) #Should've realised this would be identical to 'plot(b)' except that I gave names to each axis.

help(matrix)

snpdata <- matrix(0,N,M) #creating an empty (0) matrix with N rows, and M columns.
for(i in 1:M){
  snpdata[,i] <- rbinom(N,2,0.4)
}
#This for loop is creating i values from 1 to M (no. of columns), where i is N number of paired (rbinom) values at 0.4 frequency??
#In other words it is assigning randomly 2 alleles to 1000 individuals, based on a SNP frequency of 0.4??
#0.4 is half the simulated heritability??
#snpdata is now a collection of 2N alleles distributed randomly based on a SNP frequency of 0.4.
head(snpdata)

snpdata <- scale(snpdata)# This is standardizing the distribution of alleles. By scaling the data, you shift the mean to zero by, literally, taking it away from each data point. Then what's left over is the variance, so by dividing each data point by the sd, 
g1 <- snpdata %*% b[,1]
g2 <- snpdata %*% b[,2]

help(scale)

g1

y1 <- g1 + e[,1]
y2 <- g2 + e[,2]

summary(lm(y1~snpdata[,1]))
summary(lm(y2~snpdata[,1]))




data <- data.frame(y,g,e)
head(data)

var(g)/var(y)
plot(g, y)

## we will now do this differently and break g down into the effects of each SNP marker
# creating SNP data
M = 10
SNP1 <- rbinom(N,2,0.4)
SNP2 <- rbinom(N,2,0.4)
SNP3 <- rbinom(N,2,0.4)
SNP4 <- rbinom(N,2,0.4)
SNP5 <- rbinom(N,2,0.4)
SNP6 <- rbinom(N,2,0.4)
SNP7 <- rbinom(N,2,0.4)
SNP8 <- rbinom(N,2,0.4)
SNP9 <- rbinom(N,2,0.4)
SNP10 <- rbinom(N,2,0.4)
snp_data <- data.frame(SNP1,SNP2,SNP3,SNP4,SNP5,SNP6,SNP7,SNP8,SNP9,SNP10)
head(snp_data)
hist(snp_data[,1])
mean(snp_data[,1])  # = 2 * frequency
dim(snp_data)

# creating effect sizes for each marker
b <- rnorm(M, 0, sd = sqrt(h2/M))

# predicting from each marker
g1 = scale(SNP1) * b[1]
g2 = scale(SNP2) * b[2]
g3 = scale(SNP3) * b[3]
g4 = scale(SNP4) * b[4]
g5 = scale(SNP5) * b[5]
g6 = scale(SNP6) * b[6]
g7 = scale(SNP7) * b[7]
g8 = scale(SNP8) * b[8]
g9 = scale(SNP9) * b[9]
g10 = scale(SNP10) * b[10]
data = data.frame(snp_data, g1,g2,g3,g4,g5,g6,g7,g8,g9,g10)

# creating a phenotype from the marker predictions plus environment
g = g1 + g2 + g3 + g4 + g5 + g6 + g7 + g8 + g9 + g10
e <- rnorm(N, 0 , sd = sqrt(1-var(g)))
y = g + e
data <- data.frame(y,g,g1,g2,g3,g4,g5,g6,g7,g8,g9,g10,e)
var(g)
hist(y)
plot(g, y)


### homework
N = 1000      # what does this mean
M = 1000      # what does this mean
h2=0.8        # define this
snpdata <- matrix(0,N,M)  # describe what I am doing here

# what is going on here?
for(i in 1:1000){
  snpdata[,i] <- rbinom(N,2,0.4)
}

# why am I scaling the data
snpdata <- scale(snpdata)

# what is going on here?
b <- rnorm(M,0,sd = sqrt(h2/M))

# and here?
g <- snpdata %*% b

# what are these values?
e <- rnorm(N,0, sd = sqrt(1-h2))

# what is the variance of y, the variance of g, and the variance of e?
y = g + e
