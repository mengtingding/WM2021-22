##############################################
### Changes in US Residential Construction ###
##############################################
rm(list=ls())

# Load the required packages
library(readxl)
library(forecast)
library(urca)

# Load the data and create ts object
data2<-read_xls("constructionchanges(2).xls")
const<-ts(data2$ConstructionChanges,start=c(2002,2),frequency=12)

# Create test and train series
train<-window(const,end=c(2009,12))
test<-window(const,start=c(2010,1))

# Plot the train data. Check for Stationarity.
plot(train)   # Doesn't seem to drift. 
              #Construction peaks during the 
              #spring declines in winter.

## trend, seasonality,

ndiffs(train) #No differences needed; ndiffs(train)=0
summary(ur.kpss(train)) #No unit root.
#The data is stationary.

# Look at the Acf and Pacf. Propose models for seasonality.
Acf(train,lag.max=50) # Slow Decaying seasonal ACF. 
                      # Spikes are positively correlated every 12 months. - seasonal pattern
Pacf(train,lag.max=50) # Significant spike at 12. S-AR
                       
model<-Arima(train,order=c(0,0,0),
             seasonal=list(order=c(1,1,0),period=12))

# Now check the residuals. Propose model for non-seasonal
Acf(model$residuals)    #Declining Acf
Pacf(model$residuals)   #One spike in Pacf

# Use the Ar(1) model
(model_ar<-Arima(train,order=c(1,0,0),
             seasonal=list(order=c(1,1,0),period=12)))
#Use the Ma(2) model
(model_ma<-Arima(train,order=c(0,0,2), lambda=lam,
                seasonal=list(order=c(1,1,0),period=12)))
#Use the ArMa(1,2) model
(model_arma<-Arima(train,order=c(1,0,2),
                 seasonal=list(order=c(1,1,0),period=12)))

# Choose the Ar(1). It is the simplest model and has
# the lowest AICc

# Check the residuals again. Let's make sure
# we model all of the time dependencies. The
# residuals should look like white noise.

Acf(model_ar$residuals) #Looks like white noise
Pacf(model_ar$residuals)  #Looks like white noise
Box.test(model_ar$residuals) #No serial correlation
                              #P-value over 0.05


# Now let's forecast the series 13 periods ahead
# Using the Ar(1) model
forecast1<-forecast::forecast(model_ar,h=13)  # h number of periods ahead


# Assess the accuracy of the model against 
# the test set.
acc1<-round(accuracy(forecast1,test),2)  


# Let's save the accuracy results
models<-data.frame(acc1[2,1:5])
colnames(models)<-c("S-ARIMA")

# Let's also do Cross Validation.
farima<-function(x,h){
  forecast::forecast(Arima(x,order=c(1,0,0),
                           seasonal=list(order=c(1,1,0),
                           period=12)),h=h)
}

e1<-tsCV(train,farima,h=1)
(cv1<-sqrt(mean(e1^2,na.rm=TRUE)))

# Plot the model
par(mai=c(0.5,0.5,0.5,0.5))
plot(window(train),type="l",xlim=c(2003.0,2013.0),ylim=c(-10000,10000),
     ylab="Percent Monthly Change",xlab="Period", main="S-ARIMA")
lines(test,col="black",lwd=2)
lines(forecast1$mean,col="green",lwd=2)
abline(v=2010,lty=2)
legend(2010.5, 10000, legend=c("Test", "Forecast"),
       col=c("black","green", "red", "red"), 
       lty=c(1,1,2,2), cex=0.8, text.font=1, bg='lightblue')

############################
## A neural network model ##
############################

# NNAR(p,k) to indicate there are p lagged inputs and 
# k nodes in the hidden layer.

model_nn<-nnetar(train,p=1,P=1,repeats=500,
             size=9, scale.inputs = TRUE)       #p nonseasonal lags
                                                #P seasonal lags
                                                # size nodes in hidden layer
                                                # repeats number of networks to fit
(model_nn)

forecast2<-forecast::forecast(model_nn,h=13)

# Assess the accuracy
(acc2<-accuracy(forecast2,test))

# Cross Validation

fnn<-function(x,h){
  forecast::forecast(nnetar(x, scale.inputs = TRUE) ,h=h)
}

e2<-tsCV(train,fnn,h=1)
(cv2<-sqrt(mean(e2^2,na.rm=TRUE)))

#Plot
par(mai=c(0.5,0.5,0.5,0.5))
plot(window(train),type="l",xlim=c(2003.0,2013.0),ylim=c(-10000,10000),
     ylab="Percent Monthly Change",xlab="Period", main="NN")
lines(test,col="black",lwd=2)
lines(forecast2$mean,col="green",lwd=2)
abline(v=2010,lty=2)
legend(2010.5, 10000, legend=c("Test", "Forecast"),
       col=c("black","green"), 
       lty=c(1,1,2,2), cex=0.8, text.font=1, bg='lightblue')

NN<-acc2[2,1:5]
models<-data.frame(models,NN)

#################################
### Error Trend Seasonal (ETS) ##
#################################

model_ets<-ets(train) # Calculates the model for us.
summary(model_ets)  # Additive for level, None for slope, Additive for season.

forecast3<-forecast::forecast(model_ets,h=13)

(acc3<-accuracy(forecast3,test))

# Cross Validation
fets<-function(x,h){
  forecast::forecast(ets(x),h=h)
}

e3<-tsCV(train,fets,h=1)
cv3<-sqrt(mean(e3^2,na.rm=TRUE))

# Plot
par(mai=c(0.5,0.5,0.5,0.5))
plot(window(train),type="l",xlim=c(2003.0,2013.0),ylim=c(-10000,10000),
     ylab="Percent Monthly Change",xlab="Period", main="ETS")
lines(test,col="black",lwd=2)
lines(forecast3$mean,col="green",lwd=2)
abline(v=2010,lty=2)
legend(2010.5, 10000, legend=c("Test", "Forecast"),
       col=c("black","green"), 
       lty=c(1,1,2,2), cex=0.8, text.font=1, bg='lightblue')

ETS<-acc3[2,1:5]
models<-data.frame(models,ETS)

###############
## Ensemble ###
###############

CVs<-data.frame(c(cv1,cv2,cv3))
colnames(CVs)<-c("RMSE")
rownames(CVs)<-c("S-Arima","NN","ETS")

# Create an Ensemble with the Neural Network and the S-Arima
a<-0.5
ens<-a*forecast1$mean+(1-a)*forecast2$mean

# Plot
par(mai=c(0.5,0.5,0.5,0.5))
plot(window(train),type="l",xlim=c(2003.0,2013.0),ylim=c(-10000,10000),
     ylab="Percent Monthly Change",xlab="Period", main="Ensemble")
lines(test,col="black",lwd=2)
lines(ens,col="green",lwd=2)
abline(v=2010,lty=2)
legend(2010.5, 10000, legend=c("Test", "Forecast"),
       col=c("black","green"), 
       lty=c(1,1,2,2), cex=0.8, text.font=1, bg='lightblue')

(ME<-mean(test-ens))                     #Mean Error
(RMSE<-sqrt(mean((test-ens)^2)))         #Root Mean Squared Error
(MAE<-mean(abs(test-ens)))               #Mean Absolute Error
(MPE<-mean((test-ens)/test)*100)         #Mean Percent Error
(MAPE<-mean(abs((test-ens)/test))*100)   #Mean Absolute Percentage

ensemble<-c(ME,RMSE,MAE,MPE,MAPE)
models<-data.frame(models,ensemble)
