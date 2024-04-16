# S-ARIMA
rm(list=ls())
########################################################
## Monthly clothing sales. Source: U.S. Census Bureau ##
########################################################

library(readxl)
setwd("C:/Users/mengt/Desktop/S1/stochastic modelling/W15")
data1<-read_xls("sales.xls")  # Load the data
sales<-ts(data1$SALES,frequency=12,start=c(2003,1)) # Create ts object

# Create a training set and a test set
train<-window(sales,end=c(2009,12))
test<-window(sales,start=c(2010,1))
head(train)
# Visualize the series
library(forecast)
plot(train) # Looks like the series has a bit of a drift
Acf(train,lag.max=50) # Declining ACF. AR process. Spikes every 12.
Pacf(train,lag.max=50) # Two spikes. One lag 12 other 24. AR(2) seasonal or AR(1).
                       # The one at 13 might be due to sampling error.

# Is the data stationary
library(urca)
train%>%ur.kpss()%>%summary()   # Non stationary
ndiffs(train)   # Use one difference to make stationary

# Transform Test and Train Sets
train<-diff(log(train))
test<-diff(log(test))

# Visualize the stationary series
plot(train)

Acf(train,lag.max = 50)
# Declining ACF? -> AR Process. Slow decay (perhaps needs to be integrated).
# Two spikes? -> MA(2) Perhaps the second spike is noise? MA(1)
# Spikes every 12 months? -> Seasonal component
Pacf(train,lag.max=50)
# Three significant spikes? -> AR(3) process
# Declining Spikes? -> MA process
# One significant spike at month 12? -> AR(1) seasonal component at 12. 
                                        #Second spike could be sampling error

# Let's fit the possible models

# ARMA (3,0,2)  S-ARIMA (1,1,0)
fit1<-Arima(train,order=c(3,0,2),seasonal=list(order=c(1,1,0),period=12))
fit1

fit2<-Arima(train,order=c(3,0,0),seasonal=list(order=c(1,1,0),period=12))
fit2

fit3<-Arima(train,order=c(0,0,2),seasonal=list(order=c(1,1,0),period=12))
fit3

# Let's black box it!
fit4<-auto.arima(train)   # Step-wise and Approximation
fit4

 # Check the residuals
Acf(fit1$residuals)
Pacf(fit1$residuals)
Box.test(fit1$residuals, type="Ljung",lag=10) # No serial correlation

Acf(fit4$residuals)
Pacf(fit4$residuals)
Box.test(fit4$residuals, type="Ljung",lag=10)

# Forecast the series 13 periods ahead
forecast1<-forecast::forecast(fit1,h=13)  # h number of periods ahead
forecast2<-forecast::forecast(fit4,h=13)

# Assess the accuracy of the model
(ME1<-mean(test-forecast1$mean))                 #Mean Error
(RMSE1<-sqrt(mean((test-forecast1$mean)^2)))     #Root Mean Squared Error
(MAE1<-mean(abs(test-forecast1$mean)))           #Mean Absolute Error
(MAPE1<-mean(abs((test-forecast1$mean)/test)))   #Mean absolute Percentage Error

(ME2<-mean(test-forecast2$mean))                 #Mean Error
(RMSE2<-sqrt(mean((test-forecast2$mean)^2)))     #Root Mean Squared Error
(MAE2<-mean(abs(test-forecast2$mean)))           #Mean Absolute Error
(MAPE2<-mean(abs((test-forecast2$mean)/test)))   #Mean absolute Percentage Error

# Plot the best model
par(mai=c(0.5,0.5,0.5,0.5))
plot(window(train),type="l",xlim=c(2003.0,2012.0),ylim=c(-1,1),
     ylab="Percent Monthly Change",xlab="Period")
lines(test,col="black",lwd=2)
lines(forecast1$mean,col="blue",lwd=2)
lines(forecast1$lower[,2],col="red",lty=2,lwd=2)
lines(forecast1$upper[,2],col="red",lty=2,lwd=2)
abline(v=2010,lty=2)
legend(2004, 1, legend=c("Test", "Forecast", "95% Upper", "95% Lower"),
       col=c("black","blue", "red", "red"), 
       lty=c(1,1,2,2), cex=0.8, text.font=1, bg='lightblue')

###########################################################
## Your Turn. Try with the Residential Construction Data ##
###########################################################

rm(list=ls())
# Load the data and create a time series object

# Create test and train series. The test starts at 2010,2

# Plot the series, the ACF and PACF.

# Is the data stationary?

# Propose three models and assess the fit using the BIC or AIC.

# Black box it. How did your model do?

# Choose the top two models and Check the residuals. Is there serial correlation?

# Forecast the series 13 periods ahead.
forecast1<-forecast::forecast(fit1,h=13)  # h number of periods ahead
forecast2<-forecast::forecast(fit2,h=13)

# Assess the accuracy of the models using the test set. 

# Plot the train, test and predicted data.



