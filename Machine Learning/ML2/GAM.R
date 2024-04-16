############part A########
library(ISLR2)
library(glmnet)
library(splines)
rm(list=ls())
attach(OJ)
dim(OJ)# print dim
class(OJ$Purchase)#print variable type of OJ$Purchase
summary(Purchase) #

##########Q02###########
set.seed(5082)
x <- model.matrix(Purchase~.,OJ)[,-1]
y <- Purchase

trainIndex <- sample(nrow(OJ),nrow(OJ)*0.8)
x.train <- x[trainIndex,]
y.train <- y[trainIndex]
x.test <- x[-trainIndex,]
y.test <- y[-trainIndex]
length(trainIndex) # Q02-1
summary(y.train) #summary() Q02-2
summary(y.test) #summary() Q02-3

############Q3###########
set.seed(5082)
grid <- 10^seq(-2,4,length=200)

lasso <- glmnet(x.train,y.train, lambda = grid,alpha=1,family="binomial")
cv.out.lasso <- cv.glmnet(x.train,y.train,lambda=grid, nfolds=12,alpha=1,family="binomial")
bestlam <- cv.out.lasso$lambda.min 
print(bestlam)#Q3-01
lasso.pred <- predict(lasso,s=bestlam,alpha=1,newx = x.test,type="class")
table(y.test,lasso.pred) #Q03-2

lasso.pred <- predict(lasso,s=bestlam,alpha=1,newx = x.test,type="coefficients")

############Midterm-B Q01##########
set.seed(5082)
library(splines)
library(ISLR2)
library(gam)
rm(list=ls())
attach(OJ) #OJ dataframe from ISLR2
#Insert your solution code below
class(LoyalCH) #Q01-1
summary(LoyalCH) #Q01-2
trainIndex <- sample(nrow(OJ),nrow(OJ)*0.75)
length(trainIndex)#Q01-3
OJ.train <- OJ[trainIndex,]
OJ.test <- OJ[-trainIndex,]
MSE <- rep(0,5)
MSE #Q02-1
for(i in 1:length(MSE)){
  GAM <- gam(LoyalCH[trainIndex]~s(SalePriceMM,df=4+i-2)+poly(DiscMM,3),data=OJ.train)
  GAM.pred <- predict(GAM,newdata=OJ.test)
  mse <- mean((GAM.pred-OJ.test$LoyalCH)^2)
  MSE[i] <- mse
}
MSE #Q02-2
which.min(MSE) #Q02-3

GAM.best <- gam(LoyalCH[trainIndex]~s(SalePriceMM,df=4+1-2)+poly(DiscMM,3),data=OJ.train)
GAM.best.pred <- predict(GAM.best, newdata=OJ.test)
mean(GAM.best.pred - OJ.test$LoyalCH)^2 #Q02-4

GAM.best2 <- gam(LoyalCH[trainIndex]~s(SalePriceMM,df=4+1-2)+poly(DiscMM,3)+sqrt(PriceCH),data=OJ.train)
GAM.best.pred2 <- predict(GAM.best2, newdata=OJ.test)
anova(GAM.best,GAM.best2)
