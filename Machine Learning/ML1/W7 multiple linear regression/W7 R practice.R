rm(list=ls())
setwd("C:/Users/mengt/Desktop/S1/machine learning I/W6")

advertising <- read.csv("Advertising.csv")
str(advertising)
advertising <- advertising[-c(6,131),-1]
cor(advertising)
# between the x's, the correlation is better below 0.8
## create lm
lmAdvert <- lm(sales~TV + radio + newspaper, data=advertising)
lmAdvert <- lm(sales~., data=advertising)

summary(lmAdvert)

## check assumptions
#install.packages("car")
car::vif(lmAdvert) ## multicollinearity checking, any score above 5
## no multicollinearity

hist(lmAdvert$residuals) # left skewness, most likely violated the assumption of normality of errors
mean(lmAdvert$residuals) # the mean is about 0, which means the skewness is not quite bad
plot(lmAdvert) # we have 131 as an outlier, 

#install.packages("scatterplot3d")
library(scatterplot3d)
scatterplot3d(advertising[,c(1,2,4)],color="blue",angle = 100,type="h")

lmtest::bptest(lmAdvert) ## data is homoskedastic, p-value > 0.05

library(ggplot2)
library(tidyverse)
library(dplyr)
#install.packages("broom")
library(broom)

modelResults <- augment(lmAdvert) %>% mutate(index=1:n()) # look at the 3 sd

ggplot(modelResults, aes(index, .std.resid)) + geom_point() 
sum(abs(modelResults$.std.resid) > 3)
subset(modelResults$index, abs(modelResults$.std.resid) > 3)





#----------------------------------W7 Lec 2------------------------------------

corolla <- read.csv("corolla.csv",stringsAsFactors = TRUE)
corolla <- corolla[-222,-c(1,2,6)]
str(corolla)
summary(corolla)

lmcorolla <- lm(Price ~ .,data = corolla)
summary(lmcorolla)

lmcor_forw <- step(lmcorolla, direction = "forward")
summary(lmcor_forw)
# Price ~ Age + KM + HP + QuarterlyTax + Weight
lmcor_bac <- step(lmcorolla, direction = "backward")
summary(lmcor_bac)
#Price ~ Age + KM + HP + QuarterlyTax + Weight

lmcor_mix <- step(lmcorolla, direction = "both")
summary(lmcor_mix)
# lm(formula = Price ~ Age + KM + HP + Automatic + cc + QuarterlyTax + Weight, data = corolla)

car::vif(lmcor_bac) #5-10 range multicollinearity

lmtest::bptest(lmcor_bac) #heteroskedastic
hist(lmcor_bac$residuals)
mean(lmcor_bac$residuals) #around 0
plot(lmcor_bac)

library(broom)
library(tidyverse)

modelResults <- augment(lmcor_bac) %>% mutate(index=1:n())
sum(abs(modelResults$.std.resid)>3)
subset(modelResults$index,abs(modelResults$.std.resid)>3) # the outliers 3 std
#81 has worse .std.resid, getting rid of it
# adjusting a few bad obs. 


###### prediction ########
corolla <- read.csv("corolla.csv",stringsAsFactors = TRUE)
corolla <- corolla[,-c(1,2,6)]

n <- length(corolla$Price)
n1 <- 900
set.seed(1000)

trainobsnum <- sample(1:n, n1)
train <- corolla[trainobsnum,]
test <- corolla[-trainobsnum,]

lmtrain <- lm(Price ~ ., data = train)
summary(lmtrain)

predictions <- predict(lmtrain, newdata = test)
head(predictions)

#test score for prediction 
mltools::mse(predictions, test$Price) #very high score
cor(predictions, test$Price) #0.9339 strong correlation








