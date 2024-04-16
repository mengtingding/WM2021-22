###########k nearest neighbor###########
# naive rule as a baseline for evaluation of performance for more complicated classifiers

# classification matrix (confusion matrix for classification)
library(caret)
library(dplyr)

mower <- read.csv("LawnMowers.csv",stringsAsFactors = TRUE)
class(mower$Ownership)


### split data set
set.seed(123)
dvideData <- createDataPartition(mower$Ownership,p=.5, list=FALSE)
train <- mower[dvideData,]
test <- mower[-dvideData,]

## visualization
plot(Lot_Size~Income, data=train, pch=ifelse(train$Ownership=="Owner",1,3))
 

## make model
knnfit <- train(Ownership~., data=train, method="knn", preProcess=c("center","scale"))
plot(knnfit)
knnfit$bestTune

## make prediction
knnclass <- predict(knnfit, newdata = test)
head(knnclass)

## calculate accuracy rate
table(knnclass,test$Ownership)
1-7/24 # accuracy rate
7/24 # error rate
mean(knnclass==test$Ownership)

confusionMatrix(knnclass,test$Ownership)

########################33
library(mlbench)
data("PimaIndiansDiabetes2")
library(caret)
library(dplyr)
library(ggplot2)

PimaIndiansDiabetes2 <- na.omit(PimaIndiansDiabetes2)

## inspect the data
class(PimaIndiansDiabetes2$diabetes)

## visualize data
ggplot(PimaIndiansDiabetes2,aes(glucose,mass, color=diabetes)) + geom_point()

set.seed(123)
divideData <- createDataPartition(PimaIndiansDiabetes2$diabetes,p=.8,list=FALSE)
train <- PimaIndiansDiabetes2[divideData,]
test <- PimaIndiansDiabetes2[-divideData,]

### make the model on the training data

knnfit <- train(diabetes~., data=train,method="knn",preProcess=c("center","scale"))

### find the best # of k
knnfit$bestTune
plot(knnfit)

### make predictions
knnclass <- predict(knnfit,newdata=test)
head(knnclass)

### confusion matrix
confusionMatrix(knnclass, test$diabetes)
mean(knnclass==test$diabetes)
A <- 42; B <- 12;C <- 10;D <- 14
sensitivity <- A/(A+C)
sensitivity # true pos rate
specificity <- D/(B+D) 
specificity # true neg rate


#spam model########
library(kernlab)
data(spam)
set.seed(123)
divideData <- createDataPartition(spam$type,p=.3,list=FALSE)
train <- spam[divideData,]
test <- spam[-divideData,]

spamfit <- train(type~.,data=train,method="knn",preProcess=c("center","scale"))

## predictions
predknn <- predict(spamfit,newdata=test)
confusionMatrix(predknn,test$type)

spamlogisticmodel <- glm(type~.,data=train, family = binomial)

spamprob <- predict(spamlogisticmodel,test,type="response")
spampred <- ifelse(spamprob>.5,"spam","nonspam")

mean(spampred==test$type)
#test accuracy rate is 0.93
table(spampred,test$type)
# logistic regression did better on predicting 

summary(spamlogisticmodel)
exp(spamlogisticmodel$coefficients)
