library(caret)
library(dplyr)

data("iris")
str(iris)

## split
set.seed(123)
divideData <- createDataPartition(iris$Species,p=.75,list=FALSE)
train <- iris[divideData,]
test <- iris[-divideData,]

##knn - nonparametric technique, if the predcition is higher for knn, then the data is significantly nonlinear
set.seed(123)
knnmodel <- train(Species~.,method="knn",data=train,tuneLength=7)
knnmodel
knnmodel$bestTune

set.seed(123)
knnmodel <- train(Species~.,method="knn",data=train,tuneGrid=expand.grid(k=c(5,11,21,25)))
knnmodel
knnmodel$bestTune #11 still gives out the highest accuracy

## k-fold example
trainControl <- trainControl(method="LOOCV")
set.seed(123)
LOOCVmodel <- train(Species~.,method="knn",data=train,trControl=trainControl)
LOOCVmodel$bestTune # 9
plot(LOOCVmodel) # accuracy is the same all the way through

newpred <- predict(LOOCVmodel,newdata=test)
mean(newpred==test$Species) 
confusionMatrix(newpred,test$Species)

### k fold
traincontrol <- trainControl(method="cv",number =10)
set.seed(123)
knnmodelkfold <- train(Species~.,method="knn",data=train,trControl=trainControl)
newpred <- predict(knnmodelkfold,newdata=test)
mean(newpred==test$Species)
confusionMatrix(newpred,test$Species)

### lda - both knn and lda are pretty good, therefore both works
traincontrol <- trainControl(method="cv",number =10)
set.seed(123)
ldamodel <- train(Species~.,method="lda",data=train,trControl=trainControl)
newpred <- predict(ldamodel,newdata=test)
mean(newpred==test$Species)
confusionMatrix(newpred,test$Species) #0.97

### Qda 0.944, qda is more rigid on meeting the assumptions than lda
traincontrol <- trainControl(method="cv",number =10)
set.seed(123)
qdamodel <- train(Species~.,method="qda",data=train,trControl=trainControl)
newpred <- predict(qdamodel,newdata=test)
mean(newpred==test$Species)
confusionMatrix(newpred,test$Species) #0.97

# bootstrap sample 
library(ISLR)
data("Auto")
traincontrol <- trainControl(method="boot",number=100)
set.seed(1)
bootmodel <- train(mpg~horsepower, data=Auto,method="lm",trControl=trainControl)

#install.packages("boot")
library(boot)
bootfn <- function(data, index){
  return(coef(lm(mpg~horsepower,data=data,subset=index)))
}

bootfn(Auto,1:392)
dim(Auto) #392,9
bootcorr <- boot(Auto,bootfn,1000)
summary(bootcorr)
plot(bootcorr)

