library(rattle)
data(wine)
str(wine)
attach(wine)

library(MASS)
wine.lda <- lda(Type~., data=wine)
wine.lda # prior probability, 

## linear discriminant function  LD1 -0.403399781*Alcohol+0.165254596*Malic-0.369075256*Ash+0.154797889*Alcalinity+...
options(scipen=999)
# making predictions
wine.lda.values <- predict(wine.lda)
wine.lda.values # class, posterior probabilities, 

## create histogram
ldahist(data=wine.lda.values$x[,1],g=Type)
ldahist(data=wine.lda.values$x[,2],g=Type)
par(mar=c(1,1,1,1))
library(ggplot2)
ggplot(wine, aes(wine.lda.values$x[,1],wine.lda.values$x[,2]))+geom_point(aes(color=Type))

## split data into test and train
library(caret)
library(dplyr)
set.seed(1)
divideData <- Type %>% createDataPartition(p=.8,list=FALSE)
train <- wine[divideData,]
test <- wine[-divideData,]

# centering and scaling
preprocessing <- train %>% preProcess(method=c("center",'scale'))
traintransformed <- preprocessing %>% predict(train)
testtransformed <- preprocessing %>% predict(test)


## make our model 
model <- lda(Type~., data=traintransformed)
plot(model)

## predictions
predictions <- model %>% predict(testtransformed)
names(predictions)
mean(predictions$class==testtransformed$Type) # 1, means perfect accuracy
table(predictions$class,testtransformed$Type) # 

ldaforgraph <- cbind(traintransformed,predict(model)$x)
ggplot(ldaforgraph,aes(LD1,LD2))+geom_point(aes(color=Type))


### no centering and scaling
model <- lda(Type~.,data=train)

predictions <- model %>% predict(test)
mean(predictions$class==test$Type)
# when the prediction is low, centering and scaling usually helps




#=============== Lecture 2 ===============# QDA
# separate the data
set.seed(1000)
attach(wine)
divideData <- Type %>% createDataPartition(p=0.8,list=FALSE) # list=FALSE
train <- wine[divideData,]
test <- wine[-divideData,]

## centering and scaling
preprocessing <- train %>% preProcess(method=c("center","scale"))
traintransformed <- preprocessing %>% predict(train)
testtransformed <- preprocessing %>% predict(test)

## making models
model <- qda(Type~., data=traintransformed) # qda function has less information than lda
model

# predictions
predictions <- model %>% predict(testtransformed)
mean(predictions$class==testtransformed$Type) # a score of 1, which means perfect accuracy

## 

phonme <- read.csv("phoneme.csv",stringsAsFactors=TRUE)

phonme <- phonme[,-c(1,259)]
str(phonme)
class(phonme$g)

attach(phonme)

# dividing data
set.seed(100)
divideData <- createDataPartition(g,p=.8, list =FALSE)
test <- phonme[-divideData,]
train <- phonme[divideData,]

## centering
preprocessing <- train %>% preProcess(method=c("center","scale"))
traintransformed <- preprocessing %>% predict(train)
testtransformed <- preprocessing %>% predict(test)

## make a lda model
ldamodel<- lda(g~.,data=traintransformed)
ldamodel

## accuracy rate
predictions <- ldamodel %>% predict(testtransformed)
mean(predictions$class==testtransformed$g) # accuracy rate is 0.91
# given a proportion of .2 and a set seed of 100, our accuracy rate is 0.909
# given a proportion of .8 and a set seed of 100, our accuracy rate is 0.934
table(predictions$class, testtransformed$g)

## graph
library(ggplot2)

ldaforgraph <- cbind(traintransformed,predict(ldamodel)$x)
ggplot(ldaforgraph,aes(LD1,LD2))+geom_point(aes(color=g,shape=g))

## LDs for 5 sounds
ggplot(ldaforgraph,aes(LD1,LD3))+geom_point(aes(color=g,shape=g))
ggplot(ldaforgraph,aes(LD1,LD4))+geom_point(aes(color=g,shape=g))
ggplot(ldaforgraph,aes(LD2,LD3))+geom_point(aes(color=g,shape=g))
ggplot(ldaforgraph,aes(LD2,LD4))+geom_point(aes(color=g,shape=g))
ggplot(ldaforgraph,aes(LD3,LD4))+geom_point(aes(color=g,shape=g))

#QDA
qdamodel <- qda(g~.,data=traintransformed)

qdamodel


# make predictions and calculating accuracy
predictions <- qdamodel %>% predict(testtransformed)
mean(predictions$class==testtransformed$g) # 0.86
# given a proportion of .8 and a set seed of 100, our accuracy rate is 0.86
table(predictions$class,testtransformed$g)




