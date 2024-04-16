library(ISLR)
data("Default")
str(Default)
library(ggplot2)

ggplot(Default, aes(balance, income, group=default))+
  geom_point(aes(shape=default, color=default))

library(caret)
set.seed(1)
divideData <- createDataPartition(Default, p=.8,list=FALSE)
train <- Default[divideData,]
test <- Default[-divideData,]

logisticreg <- glm(default~balance, family = binomial, data=train)
summary(logisticreg)
# balance is a significant predictor
logisticreg$coefficients
#moves log odds to odds
exp(coef(logisticreg))
# move odds to probability
b0 <- logisticreg$coefficients[1]; b0
b1 <- logisticreg$coefficients[2]; b1
probdefault <- exp(b0+b1)/(1+exp(b0+b1)); probdefault

log(probdefault/(1-probdefault)) 

b0+b1

prob <- ifelse(Default$default=="Yes", 1,0)
ggplot(Default,aes(balance,prob)) +geom_point(alpha=.1)+
  geom_smooth(method = "glm", method.args=list(family=binomial)) 



# making predictions
x <- 1500
predict(logisticreg, data.frame(balance=x),type="response")
exp(b0+b1*x)/(1+exp(b0+b1*x))
# use either predict or exp(b0+b1*x)/(1+exp(b0+b1*x))
###############
### calculate test error and accuracy rate
probs <- predict(logisticreg, test, type = "response")
pred <- ifelse(probs > .5, "Yes","No")
table(pred,test$default)

mean(pred!=test$default) ## test error rate 0.029
(6+52)/1999
mean(pred==test$default) ## 0.971 test accuracy rate
## 1- test error rate

### training accuracy and error rate
probs <- predict(logisticreg, train, type = "response")
pred <- ifelse(probs>.5, "Yes","No")
table(pred, train$default)

mean(pred!=train$default) ## training error rate 0.027
mean(pred==train$default) ## test accuracy rate 0.973


## multiple logistic regression example
multilog <- glm(default ~ student + balance, family=binomial, data=train)
summary(multilog)

exp(multilog$coefficients)

probs <- predict(multilog,test,type="response")
pred <- ifelse(probs > .5, "Yes","No")
table(pred,test$default)

mean(pred!=test$default) # test error rate 0.0275
mean(pred==test$default) # test accuracy rate 0.9725


### assumptions for logistic regression
# assumption 1 linearity of the Logit (assumption 1 violated as non-linearity)
attach(Default)
plot(balance, log(balance))

interaction <- balance*log(balance)
checkinteract <- glm(default~interaction, family=binomial,data=Default)
summary(checkinteract)

# assumption 2 absence of multicollinearity (scores are low, no multicollinearity)
car::vif(multilog)

# assumption 3 lack of strong influence of outliers
library(broom)
library(tidyverse)
modelResults <- augment(multilog) %>% mutate(index=1:n())
ggplot(modelResults, aes(index,.std.resid)) + geom_point(aes(color=default))
ggplot(modelResults, aes(index,.cooksd)) + geom_point(aes(color=default))

# assumption 4 Independent errors
library(caret)
library(mlbench)
data(BreastCancer)

BreastCancer <- BreastCancer[,-1]
BreastCancer <- na.omit(BreastCancer)

set.seed(123)
divideData <- createDataPartition(BreastCancer)
train <- BreastCancer[divideData,]
test <- BreastCancer[-divideData,]

model <- glm(class~.,data=train,family=binomial)
summary(model)

## test accuracy
prob <- predict(model,teest,type="response")
pred <- ifelse(prob>.5,"malignant","benign")
mean(pred==test$Class) #0.92

