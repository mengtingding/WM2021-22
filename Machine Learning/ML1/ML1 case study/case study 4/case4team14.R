setwd("C:/Users/15713/Documents/machine_learning_1")
rm(list=ls())
library(kernlab)
library(caret)
library(tidyverse)
library(MASS)

Data <- read.csv("Case4.csv",stringsAsFactors = TRUE)
class(Data$intubated) #making sure that this is a factor

### Part 1: Interpreting Logistic Regression Results ---------------------------

shortlogmodel <- glm(intubated~age+Gender,data=Data,family=binomial)
summary(shortlogmodel)
shortlogmodel$coefficients
exp(shortlogmodel$coefficients) 

# A one-unit increase in age is associated with an increase in the log odds of intubation by 0.014 units. (without exp)
# For every one-unit increase in age, the odds of intubation increases by a factor of 1.014. (with exp)

# The women gender is associated with -0.3 unit change in the log odds ratio of intubation when compared to men (without exp)
# Women have 0.741 times the odds of men in regards to being intubated (with exp)


### Part 2: Comparing Methods --------------------------------------------------

# Divide the data --------------------------------------------------------------
set.seed(111)
divideData <- createDataPartition(Data$intubated,p=.1,list=FALSE)
train <- Data[divideData,]
test <- Data[-divideData,]

## Logistic Regression with all the predictor variables ------------------------
logisticmodel <- glm(intubated~.,data=train,family=binomial)
plot(logisticmodel)
# Make predictions
Dataprob <- predict(logisticmodel,test,type="response")
Datapred <- ifelse(Dataprob >.5, "Yes","No")

# Produce accuracy rate of validation set
mean(Datapred==test$intubated) #0.8174609
table(Datapred, test$intubated) 
    # Datapred    No   Yes
    #     No    46373 10310
    #     Yes      48    13

# The accuracy rate of this logistic model is 81.75%.
# True Positive: We predicted that 46373 people were not intubated when they actually were not intubated
# True Negative: We predicted that 13 people were intubated when they actually were intubated
# False Positive: We predicted that 10310 people were not intubated when they actually were intubated
# False Negative: We predicted that 48 people were intubated when they actually were not intubated

A <- 46373 ; B <- 10310 ; C <- 48 ; D <- 13
sensitivity_log <- A/(A+C) ; sensitivity_log #how often did we predict positive (no) when it was actually positive (no)
# sensitivity = 0.998966
# We predicted no intubation well 
specificity_log <- D/(B+D) ; specificity_log #how often did we predict negative (yes) when it was actually negative (yes)
# specificity = 0.001259324
# We didn't predict intubation as well as we did with predicting no intubation.

# Center and Scale Data --------------------------------------------------------
preprocessing <-  train%>%preProcess(method=c("center","scale"))
traintransformed <- preprocessing%>%predict(train)
testtransformed <- preprocessing%>%predict(test)

## LDA model with all the predictor variables ----------------------------------
ldamodel <- lda(intubated~.,data=traintransformed) #We have an error message indicating
    #that variables are collinear in the data. 
par(mar=c(1,1,1,1))
plot(ldamodel)

# Make predictions
predictions <- ldamodel%>%predict(testtransformed)
names(predictions)

# Produce accuracy rate of validation set
mean(predictions$class==testtransformed$intubated) #0.8176724
table(predictions$class,testtransformed$intubated)
    #           No   Yes
    #  No    46387 10312
    #  Yes      34    11

# The accuracy rate of this LDA model is 81.77%.
# True Positive: We predicted that 46387 people were not intubated when they actually were not intubated
# True Negative: We predicted that 11 people were intubated when they actually were intubated
# False Positive: We predicted that 10312 people were not intubated when they actually were intubated
# False Negative: We predicted that 34 people were intubated when they actually were not intubated

A <- 46387 ; B <- 10312 ; C <- 34 ; D <- 11
sensitivity_lda <- A/(A+C) ; sensitivity_lda #how often did we predict positive (no) when it was actually positive (no)
# sensitivity = 0.9992676
# We predicted no intubation well 
specificity_lda <- D/(B+D) ; specificity_lda #how often did we predict negative (yes) when it was actually negative (yes)
# specificity = 0.001065582 '''
# We didn't predict intubation as well as we did with predicting no intubation.

## QDA model with all the predictor variables ----------------------------------
qdamodel <- qda(intubated~.,data=traintransformed) #Error in qda.default(x, grouping, ...) : rank deficiency in group No
qdamodel                                          #could be due to collinearity amongst variables

# Make predictions
predictions2 <- qdamodel%>%predict(testtransformed)

# Produce accuracy rate of validation set
mean(predictions2$class==testtransformed$intubated)


##  KNN model with all the predictor variables ---------------------------------
knnmodel <- train(intubated~., data=train, method="knn", preProcess=c("center","scale"))

# Find best # of K
knnmodel$bestTune #9
plot(knnmodel)

# Make predictions
knnclass <- predict(knnmodel, newdata = test)
head(knnclass) #shows in terms of levels

# Produce accuracy rate of validation set
mean(knnclass==test$intubated) #0.8052305

# Table and Confusion Matrix
table(knnclass, test$intubated)
    #  knnclass    No    Yes
    #       No   45020  9651
    #       Yes   1401   672

confusionMatrix(knnclass, test$intubated) #positive class is "no"
# From confusion matrix: 
# Accuracy : 0.8052 
# Sensitivity : 0.9698 (how well we did at predicting positives)        
# Specificity : 0.0651 (how well we did at predicting negatives)

# The accuracy rate of this KNN model is 80.52%.
# True Positive: We predicted that 45020 people were not intubated when they actually were not intubated
# True Negative: We predicted that 672 people were intubated when they actually were intubated
# False Positive: We predicted that 9651 people were not intubated when they actually were intubated
# False Negative: We predicted that 1401 people were intubated when they actually were not intubated
# Sensitivity: We predicted no intubation well.
# Specificity: We didn't predict intubation as well as we did with predicting no intubation.


## Conclusion ------------------------------------------------------------------

# instructions: select the best model(s) and describe what that means in terms 
# of the shape of the data (linear to non-parametric)

# We believe that our best model is the logistic model. Although our logistic model has a slightly
# lower accuracy rate than our LDA model, we believe that the logistic model is the
# best model. We know that logistic relies on fewer assumptions than the LDA, therefore, 
# it's a more robust model. 

####for reference:
# The accuracy rate of the logistic model is 81.75%.
# The accuracy rate of the LDA model is 81.77%.
# The accuracy rate of the QDA model is ______. (didn't work so don't include?)
# The accuracy rate of the KNN model is 80.52%.