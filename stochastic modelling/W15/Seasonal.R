# Seasonal AR process.
rm(list=ls())

library(forecast)

# Lets simulate a S-AR(1) process
y<-c(0,0,0,0)
phi<-(0.8)

nrep<-400

set.seed(25)
for (i in 5:nrep){
  y[i]=phi*y[i-4]+rnorm(1,0,0.25)
}

y<-ts(y[100:150])
plot(y)
abline(v=seq(2,60,4),lty=2)

Acf(y)    # Declining ACF. Spikes only significant for lags multiple of 4.
Pacf(y)   # One single spike at lag 4

# Lets try a S_AR(2) process

z<-rep(0,12)
phi1<-0.5
phi2<-0.3

set.seed(42)
for (i in 9:nrep){
  z[i]=phi1*z[i-4]+phi2*z[i-8]+rnorm(1,0,0.25)
}

z<-ts(z[100:150])
plot(z)
abline(v=seq(3,60,4),lty=2)

Acf(z)  # Declining ACF. Spikes only significant for lags multiple of 4.
Pacf(z) # Two spikes at lag 4 and lag 8.


