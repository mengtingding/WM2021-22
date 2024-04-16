rm(list=ls())

# Understanding time series objects, lags and differences.
set.seed(10)
(x<-ts(round(rnorm(10,20,4),0),frequency=12, 
       start=c(2000,1))) #start date

# Defines a ts object. Data, frequency of data 1->yearly, 4->Quarters, 
# 2->semi annually, 12-> monthly
# In start specify year, month, day as a vector.
# End can also be specified.

(lag_x<-stats::lag(x,k=-1))   # creates the lag of the variable
# k=-1 for one period behind
(lag_x<-stats::lag(x,k=-2))
# k=-2 for two periods behind

# Find the first difference
(d1_x<-diff(x,lag=1, differences = 1)) # Using the diff function. so that we can make series stationary
# Lagged used to calculate difference. 
# For Differences of differences use 2

(d1_log_x<-diff(log(x)))  # What are these numbers? percentage change
x

library(readxl)
data<-read_xls("DJ.xls")      # Import the data
dj<-ts(data$DJ,frequency=12,start=c(1988,1))   # define as time series
plot(dj, ylab="DJ Index", xlab="Month")      # plot. Observe trend and variance.
abline(h=mean(dj))

d1_dj<-diff(dj)   #calculate the first difference
plot(d1_dj, ylab="Change in DJ Index")       #plot. What happened? ## hetero, 
abline(h=mean(d1_dj))

log_dj<-log(dj)   #Log transformation
plot(log_dj)      #What happened?

d1_log_dj<-diff(log(dj))  ## compress everything to a smaller scale
plot(d1_log_dj,ylab="Dow Jones Percent Change")   #Is there a trend? is the mean constant? has the variance stabilized?
## the mean is somewhat stabilized compared to before taking log transformation.
abline(h=mean(d1_log_dj))

## BoxCox transformation 
library(forecast)
(lambda <- BoxCox.lambda(dj))   # Finds the best alpha to conduct your transformation
d2_BC_dj<-diff(BoxCox(dj,lambda))
plot(d2_BC_dj,ylab="Dow Jones BC")
abline(h=mean(d2_BC_dj))

hist(d1_log_dj)


# Autocorrelation and Partial Autocorrelation Functions

# Use the stationary series with the log transformation 
# or Box-Cox to create the acf and pacf.
##stationary series
##    |
##    |
Acf(d1_log_dj,lag.max = 12, plot=FALSE, type="correlation", ci=0.95) # Type covariance as well.
Acf(d1_log_dj,lag.max = 12, plot=TRUE, type="correlation", ci=0.99)
## the correlation we found is statistically significant, not by chance, when the corr goes beyond the 
## signficant level, we reject that it is not significant ( b) 
library(dynlm)
dynlm(d1_log_dj~L(d1_log_dj,-1)+L(d1_log_dj,-2)+L(d1_log_dj,-3))  # Run a regression of dj on its lags.
Pacf(d1_log_dj, lag.max=12, plot=FALSE, ci=0.95)
Pacf(d1_log_dj, lag.max=12, plot=TRUE, ci=0.95)# no time dependencies, no partial autocorelations

# Is there serial correlation?
Box.test(d1_log_dj, type=c("Ljung"), lag=10)
# Ho: No serial correlation until lag=10
# High p value can't reject null -> No serial correlation

# White noise process.
Acf(x,ci=0.95)    ## nothing above the signficant level meaning that we are only dealing with noise
Pacf(x, ci=0.95)
Box.test(x, type=c("Ljung"), lag=2)
# High p value again -> No serial correlation

#Constant variance, mean, and ergodic process.
x<-ts(round(rnorm(1000,20,4),0),frequency=12, 
      start=c(2000,1))
hist(x)

# How many lags to use?
# For non seasonal use: min(10,T/5) -> T is the length of the time series
# For seasonal use: min(2m,T/5) -> m is the period of seasonality
# https://robjhyndman.com/hyndsight/ljung-box-test/

## using autocorelation or pacf, spot the pattern, gives a hint on how to model time series