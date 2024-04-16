rm(list=ls())

###################
### White Noise ###
###################

# What does the series look like?
set.seed(13)
e_t<-ts(rnorm(300,0,0.25),frequency=1,start=1900) # Create white noise
plot(e_t)
hist(e_t)
library(normtest)
ajb.norm.test(e_t)    # Ho: Normality (skewness and kurtosis is zero)
par(mar=c(1,1,1,1))
library(forecast)
Acf(e_t)
Pacf(e_t)

Box.test(e_t, type=c("Ljung"), lag=10)  # No serial correlation

#################
### The MA(1) ###
#################

par(mfrow=c(2,2)) # Use mar=c(1,1,1,1) to adjust margins if needed

y_t1<-2+0.05*lag(e_t,k=-1)+e_t  # 2 is the mean of the series
plot(y_t1, main="MA(1), theta=0.05")
abline(h=2)

y_t2<-2+0.5*lag(e_t,k=-1)+e_t
plot(y_t2, main="MA(1), theta=0.5")
abline(h=2)

y_t3<-2+0.95*lag(e_t,k=-1)+e_t
plot(y_t3, main="MA(1), theta=0.95")
abline(h=2)

y_t4<-2+2*lag(e_t,k=-1)+e_t
plot(y_t4, main="MA(1), theta=2")
abline(h=2)

# The series are very ragged.
# The all fluctuate around the mean of 2. 
# We can prove this with expectations.

Acf(y_t1,main="MA(1), theta=0.05") 
Acf(y_t2,main="MA(1), theta=0.5")
Acf(y_t3,main="MA(1), theta=0.95")
Acf(y_t4,main="MA(1), theta=2")

# theta/(1+theta^2)
Acf(y_t1,main="MA(1), theta=0.05",plot=FALSE) 
Acf(y_t2,main="MA(1), theta=0.5",plot=FALSE)  #Same as theta=2
Acf(y_t3,main="MA(1), theta=0.95",plot=FALSE)
Acf(y_t4,main="MA(1), theta=2",plot=FALSE)  #Same as theta=0.5

# Is there anything common in these ACF's?
# What are the predicted autocorrelations for lag1?
# What about all other?

#PACF
Pacf(y_t1,main="MA(1), theta=0.05")
Pacf(y_t2,main="MA(1), theta=0.5")    
Pacf(y_t3,main="MA(1), theta=0.95")
Pacf(y_t4,main="MA(1), theta=2")      
## decaying behavior 
########################
#### Negative thetas ###
########################

y_t5<-2-0.05*lag(e_t,k=-1)+e_t
plot(y_t5, main="MA(1), theta=-0.05")
abline(h=2)

y_t6<-2-0.5*lag(e_t,k=-1)+e_t
plot(y_t6, main="MA(1), theta=-0.5")
abline(h=2)

y_t7<-2-0.95*lag(e_t,k=-1)+e_t
plot(y_t7, main="MA(1), theta=-0.95")
abline(h=2)

y_t8<-2-2*lag(e_t,k=-1)+e_t
plot(y_t8, main="MA(1), theta=-2")
abline(h=2)

Acf(y_t5,main="MA(1), theta=-0.05")
Acf(y_t6,main="MA(1), theta=-0.5")
Acf(y_t7,main="MA(1), theta=-0.95")
Acf(y_t8,main="MA(1), theta=-2")

#PACF
Pacf(y_t5,main="MA(1), theta=-0.05")
Pacf(y_t6,main="MA(1), theta=-0.5")
Pacf(y_t7,main="MA(1), theta=-0.95")
Pacf(y_t8,main="MA(1), theta=-2")


par(mfrow=c(1,1)) 


###############
### Example ###
###############

# Percent Monthly Change the yield of U.S. treasury securities (TCM5Y)
rm(list=ls())
library(readxl)
data<-read_xls("treasury.xls")
treasury<-ts(data$changetreasury,frequency=12,start=c(1953,5))

# Start by plotting the data. Check for stationarity.
plot(treasury)
abline(h=mean(treasury))
ndiffs(treasury)   # Number of differences to make the series stationary

# Generate the Acf and Pacf function to look for time dependencies
Acf(treasury)
Pacf(treasury)

# Choose model. Let's estimate an MA(1) model.
train<-window(treasury,end=c(2007,12))
test<-window(treasury,start=c(2008,1))
ma_1<-Arima(train,order=c(0,0,1))
(ma_1)

# How well does the model fit the data?
accuracy(ma_1)

# Also check the residuals. Make sure the Acf and Pacf look like white noise
Acf(ma_1$residuals)
Pacf(ma_1$residuals)
Box.test(ma_1$residuals, type="Ljung",lag=10)

# Generate a forecast
(forecast1<-forecast(ma_1,h=4))  #h number of periods ahead
ma_1$residuals    # The model uses the residuals to provide the forecast
#1.3294*0.4823+0.1667  # The forecast for Jan 2008
# The forecast after is just the mean 0.1667449

plot(window(train,start=2005),type="l",xlim=c(2006.0,2009.0),ylim=c(-16,15),
     ylab="Percent Monthly Change",xlab="Period")
lines(test,col="black",lwd=2)
lines(forecast1$mean,col="blue",lwd=2)
lines(forecast1$lower[,2],col="red",lty=2,lwd=2)
lines(forecast1$upper[,2],col="red",lty=2,lwd=2)
abline(v=2008,lty=2)
abline(h=mean(train))
legend(2008.3, -5, legend=c("Test", "Forecast", "95% Upper", "95% Lower"),
       col=c("black","blue", "red", "red"), 
       lty=c(1,1,2,2), cex=0.8, text.font=1, bg='lightblue')


# We can also create a rolling forecast
m1.Rol.F <- ts(forecast1$mean[1],start=c(2008,1),frequency = 12)
dates<-data.frame(c(2007,2008,2008,2008,2008),c(12,1,2,3,4))

for(i in 2:length(test)) {
  temp <- window(treasury, end =c(dates[i,1],dates[i,2]))
  m1.update <- arima(temp, order=c(0,0,1))
  m1.Rol.F <- c(m1.Rol.F, forecast(m1.update, h=1)$mean)
}
(m1.Rol.F <- ts(m1.Rol.F,start=c(2008,1),frequency=12))
lines(m1.Rol.F,type="l", col="orange")

plot(forecast1,xlim=c(2006,2009))

# Asses the accuracy of the forecast
(ME<-mean(test-forecast1$mean))                 #Mean Error
(RMSE<-sqrt(mean((test-forecast1$mean)^2)))     #Root Mean Squared Error
(MAE<-mean(abs(test-forecast1$mean)))           #Mean Absolute Error
(MAPE<-mean(abs((test-forecast1$mean)/test)))   #Mean absolute Percentage Error

accuracy(forecast1,test)
# Rolling forecast accuracy
(ME<-mean(test-m1.Rol.F))                 
(RMSE<-sqrt(mean((test-m1.Rol.F)^2)))     
(MAE<-mean(abs(test-m1.Rol.F)))           
(MAPE<-mean(abs((test-m1.Rol.F)/test)))    


#########################
### The MA(2) Process ###
#########################

y_t9<-2-lag(e_t,k=-1)+0.25*lag(e_t,k=-2)+e_t
plot(y_t9, main="MA(2), theta1=-1, theta2=0.25")
abline(h=2)

y_t10<-2+1.7*lag(e_t,k=-1)+0.72*lag(e_t,k=-2)+e_t
plot(y_t10, main="MA(2), theta1=1.7, theta2=0.72")
abline(h=2)

Acf(y_t9)
Pacf(y_t9)
Acf(y_t10)
Pacf(y_t10)

#########################
### Microsoft Example ###
#########################

data2<-read_xls("MSFT.xls")
MSFT<-ts(data2$MSFT_price)

library(TTR)
MA3<-SMA(MSFT,n=3)   #Create a moving average to smooth the series and observe trends

plot(MSFT)
lines(MA3,col="blue")

RMSFT<-diff(log(MSFT))
plot(RMSFT)

RMA3<-diff(log(MA3))
plot(RMA3)

Acf(RMSFT)
Pacf(RMSFT)
Acf(RMA3)
Pacf(RMA3)

rm(list=ls())
Dat_TSLA<-read.csv("TSLA2.csv")
TSLA<-SMA(ts(Dat_TSLA$Adj.Close),n=3) 

TSLA_TRAIN<-window(TSLA,end=round(0.9*length(TSLA),0))
TSLA_TEST<-window(TSLA,start=round(0.9*length(TSLA),0)+1)

plot(TSLA)
ndiffs(TSLA_TRAIN)

S_TSLA<-diff(log(TSLA_TRAIN),differences=2)
Acf(S_TSLA)
Pacf(S_TSLA)

(model<-Arima(TSLA_TRAIN,order=c(0,2,1)))
forecast<-forecast(model,h=length(TSLA_TEST))

plot(TSLA_TRAIN,xlim=c(0,length(TSLA)),ylim=c(0,1200))
lines(TSLA_TEST,col="blue")
lines(forecast$mean,col="red")
#lines(forecast$lower[,2],col="red",lty=2,lwd=2)
#lines(forecast$upper[,2],col="red",lty=2,lwd=2)
