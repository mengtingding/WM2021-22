rm(list=ls())

library(forecast)
# Lets simulate some AR(1) processes
y<-0
phi<-c(0.4,0.7,0.95,1) #Persistence
const<-(1)

nrep<-400
y1<-y
y2<-y
y3<-y
y4<-y

set.seed(12)
for (i in 2:nrep){
  y1[i]=const+phi[1]*y1[i-1]+rnorm(1,0,0.5)
  y2[i]=const+phi[2]*y2[i-1]+rnorm(1,0,0.5)
  y3[i]=const+phi[3]*y3[i-1]+rnorm(1,0,0.5)
  y4[i]=const+phi[4]*y4[i-1]+rnorm(1,0,0.5)
}

y1<-ts(y1)
y2<-ts(y2)
y3<-ts(y3)
y4<-ts(y4)

# What does the series look like?
par(mfrow=c(2,2),mai=rep(0.5,4)) 
plot(window(y1,start=200), main="AR (1), Phi=0.4")
abline(h=mean(y1))
plot(window(y2,start=200), main="AR (1), Phi=0.7")
abline(h=mean(y2))
plot(window(y3,start=200), main="AR (1), Phi=0.95")
abline(h=mean(y3))
plot(window(y4,start=200), main="AR (1), Phi=1")   # A random walk with drift

# What do the autocorrelations look like
Acf(y1,main="AR (1), Phi=0.4")  # Decreasing as number of lags increase
Acf(y2,main="AR (1), Phi=0.7")  # Some seasonal pattern
Acf(y3,main="AR (1), Phi=0.95")  # Exponential decrease
Acf(y4,main="AR (1), Phi=1")  # Very slow decaying behavior

# The Acf is steadily decreasing. The series takes longer to decay when
# phi is larger.

# What do the Pacf look like?
Pacf(y1,main="AR (1), Phi=0.4")
Pacf(y2,main="AR (1), Phi=0.7")
Pacf(y3,main="AR (1), Phi=0.95")
Pacf(y4,main="AR (1), Phi=1")
# The Pacf have one spike and then all other lags equal to zero. The first spike
# is very close to the value of phi.

# Series 4 is a random walk with drift. The series is not stationary.

#If the LM statistic is greater than the critical value 
#(given in the table below for alpha levels of 10%, 5% and 1%), 
#then the null hypothesis is rejected; the series is non-stationary.

library(urca)
y1%>%ur.kpss()%>%summary()   # Ho: Stationary. Value below most critical
y2%>%ur.kpss()%>%summary()   # Can't reject. 0.08 is less than all levels
y3%>%ur.kpss()%>%summary()   # Reject at all levels
y4%>%ur.kpss()%>%summary()   # Reject at all levels

ndiffs(y4)

# We can make the series stationary by finding the first difference.
d_y4<-diff(y4)
plot(d_y4)
d_y4%>%ur.kpss()%>%summary()

#####################################
### Personal Income in California ###
#####################################

# Load the Data and create a time series object.
library(readxl)
data1<-read_xls("CAINCOME.xls")
income<-ts(data1$IncomeGrowth_CA,start=1970)
par(mfrow=c(1,1))

# Plot the data and the mean
plot(income)   #Looks like the AR(1)'s we created above
abline(h=mean(income))

# Plot the Acf and Pacf
Acf(income)
Pacf(income)

# Estimate the model
ar1<-Arima(income,c(1,0,0))  # Arima returns the mean not the constant! c=mu*(1-phi)
(ar1)

ma3<-Arima(income,c(0,0,3))
(ma3)

arma13<-Arima(income,c(1,0,3))
(arma13)

# Plot residuals. Are they white noise?
plot(ar1$residuals)
Acf(ar1$residuals)
Pacf(ar1$residuals)

# Test for serial correlation
Box.test(ar1$residuals, type="Ljung",lag=10)

# Forecast the series six periods ahead.
forecast1<-forecast::forecast(ar1,h=6)
plot(forecast1)

##########################
## Consumer Price Index ##
##########################

# Load the data
data2<-read_xls("CPI.xls")
cpi<-ts(data2$CPI_Growth,start=1914)

# plot the data
plot(cpi)
abline(h=mean(cpi))

# Is the data stationary? 
cpi%>%ur.kpss()%>%summary()
ndiffs(cpi)

# Plot the ACF and PACF
Acf(cpi)  # Seems like it is declining. Perhaps 2 spikes? MA(2)
Pacf(cpi) # Two spikes? AR(2)

# Try different models.
(ar2<-Arima(cpi,order=c(2,0,0)))  

(ma2<-Arima(cpi,order=c(0,0,2)))

(arma22<-Arima(cpi,order=c(2,0,2)))


# Check residuals. Are they white noise?
plot(ma2$residuals)
Acf(ma2$residuals)
Pacf(ma2$residuals)

# Test for serial correlation
Box.test(ma2$residuals, type="Ljung",lag=10)

#Plot fitted values
plot(ar2$x, main="AR(2) Fit")
lines(ar2$fitted, col="blue")

plot(ma2$x, main="MA(2) Fit")
lines(ma2$fitted, col="blue")

# Now forecast the series 6 periods ahead.
(forecast2<-forecast::forecast(ma2,h=6))
plot(forecast2)



