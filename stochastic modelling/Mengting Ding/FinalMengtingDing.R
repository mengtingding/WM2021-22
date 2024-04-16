print("As a member of the William and Mary community, I pledge on my honor not to lie, cheat, or steal, either in my academic or personal life. I understand that such acts violate the Honor Code and undermine the community of trust, of which we are all stewards.")
rm(list=ls())
library(forecast)
library(glue)
library(dplyr)
library(ggplot2)

covid <- read.csv('Covid.csv')

cases <- ts(covid$new_cases,start = c(2020,3),frequency=365)
train<-window(cases,end=c(2021.7475))
test<-window(cases,start=c(2021.748))

###################
# 3)
plot(train,main="Number of New Covid Cases in the US",bty="l",
     ylab ="",xlim=c(2020,2022)) 
text(x=2021.9,y=0,label="Source:WHO",cex=1)

###################
# 4)
ndiffs(train) # this time series needs 1 difference to be stationary
#par(mfrow=c(1,2))
Acf(diff(train),lag.max=100)
Pacf(diff(train),lag.max=100)

###################
# 5) 
Smodel <- Arima(train, order=c(0,1,0),seasonal = list(order=c(3,1,0),period=7))
#par(mfrow=c(1,2))
Acf(Smodel$residuals,lag.max = 100)
Pacf(Smodel$residuals,lag.max = 100)



###################
# 6) 
model_sarima <- Arima(train,order=c(1,0,1),seasonal = list(order=c(3,1,0),period=7))
#par(mfrow=c(1,2))
Acf(model_sarima$residuals,lag.max = 100)
Pacf(model_sarima$residuals,lag.max = 100)
model_sarima$bic


###################
# 7) 
model_auto <- auto.arima(train)
model_auto$bic
glue("model_auto does not perform better than model_sarima as model_sarima has a smaller bic.")
# model_auto BIC 14168.75; model_sarima BIC 13875.59

###################
#8)
forecast_sarima <- forecast::forecast(model_sarima,h=7)
plot(forecast_sarima, xlim=c(2021.6,2021.8))
lines(test)

###################
#9) 
acc1<-accuracy(forecast_sarima,test)
acc1[2,1:5]
Accuracy_Models <- data.frame(acc1[2,1:5])
colnames(Accuracy_Models) <- c("S_Arima")
##################
#10)
set.seed(10)
Model_NN <- nnetar(train,scale.inputs = TRUE)
forecast_NN <- forecast::forecast(Model_NN,h=7)
acc2 <- accuracy(forecast_NN,test)
Accuracy_Models <- cbind(Accuracy_Models,acc2[2,1:5])
colnames(Accuracy_Models)<-c("S_Arima","created NN")

##################
#11) 
plot(forecast_NN,xlim=c(2021.6,2021.8))
lines(test)

##################
# 12)
a <- seq(0,1,0.01)
R <- c(1:101)
for (i in 1:101){
  ens <- a[i]*forecast_sarima$mean + (1-a[i])*forecast_NN$mean
  R[i] <- sqrt(mean((test-ens)^2))
}
alpha_min <- a[which(R == min(R), arr.ind = TRUE)]
RMSE <- round(min(R),2)
ens <- alpha_min*forecast_sarima$mean + (1-alpha_min)*forecast_NN$mean
ME<-round(mean(test-ens),2)                    
MAE<-round(mean(abs(test-ens)),2)               
MPE<-round(mean((test-ens)/test)*100,2)
MAPE<-round(mean(abs((test-ens)/test))*100,2)
ensemble <- c(ME,RMSE,MAE,MPE,MAPE)
Accuracy_Models <- data.frame(Accuracy_Models,ensemble)
glue("The RMSE for this model is {RMSE}. 
     The ensemble model is the best model to predict COVID as it has the smallest error rate.")








