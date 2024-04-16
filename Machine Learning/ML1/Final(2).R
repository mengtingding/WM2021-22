####################################################################################################################
########################### Mengting Ding ###########################
####################################################################################################################


####################################################################################################################
#####Place a command to remove all variables from your environment at the very beginning of your script#############
rm(list = ls())

####################################################################################################################
##########Predicting Vowel#########################################################################################
## Do NOT include the following commands in your code: install.packages, view or fix commands, and commands resetting your working directory in your final code.
## Ensure you are able to run your code from start to finish without changing place in your code and that your numbers match what you put in comments.


##Load the mlbench library along with other libraries you need to solve this problem.
## You should have the mlbench package from one of the other lectures. 
## If you do not have the mlbench package, install the package and then comment out the line.
## Load the Vowel dataset out of the mlbench library and add any commands you want to get to know the dataset.
library(mlbench)
library(caret)
library(dplyr)
library(rattle)
library(MASS)
data("Vowel")
str(Vowel)
summary(Vowel)
####################################################################################################################
##Goal is to classify Class by including at all other variables in the Vowel dataset.
####################################################################################################################

####################################################################################################################
##Splitting the Data
## Set the seed to a number of your choice
## Set Data Partition to subset 75% of the data for the train group and 25% for the test group. 
## Use the preprocess function to center and scale your data and execute on both train and test datasets.
set.seed(10)
DivideData <- createDataPartition(Vowel$Class,p=0.75,list=FALSE)
train <- Vowel[DivideData,]
test <- Vowel[-DivideData,]
preprocessing <- train %>% preProcess(method=c("center",'scale'))
traintransformed <- preprocessing %>% predict(train)
testtransformed <- preprocessing %>% predict(test)

####################################################################################################################
##Model 1: LDA
## Using the validation set approach, make a lda model with the training dataset that you just transformed. 
## Make predictions with the ldamodel using the transformed test data.
## Calculate the accuracy rate and produce a confusion matrix, saving your mean function calculating accuracy to a variable called ldaaccuracy

ldamodel <- lda(Class~.,data=traintransformed)
predlda <- predict(ldamodel,testtransformed)
ldaaccuracy <- mean(predlda$class==testtransformed$Class)
ldaaccuracy
confusionMatrix(predlda$class,testtransformed$Class)
####################################################################################################################
## Answer the following question: 
## 1) What is the accuracy rate you found? 
#The accuracy rate is 0.583.

####################################################################################################################
###Model 2: QDA
### Using the validation set approach, make a qda model. Calculate the new accuracy rate using the same centered and scaled data from above.  
### In doing so, make predictions with the qdamodel using the transformed test data.
### Calculate the accuracy rate and produce a confusion matrix, saving your mean function calculating accuracy to a variable called qdaaccuracy.

qdamodel <- qda(Class~.,data=traintransformed)
predqda <- predict(qdamodel,testtransformed)
qdaaccuracy <- mean(predqda$class==testtransformed$Class)
confusionMatrix(predqda$class,testtransformed$Class)

####################################################################################################################
## Answer the following questions: 
## 2) What is the accuracy rate of the qda model? 
## 3) Where did you misclassify observations?
# the accuracy rate of the qda model is 0.971, it misclassified one hid to hId.

####################################################################################################################
########Model 3: KNN
### Set a new seed before train function asked below. 
### Using the validation set approach, make a KNN Model with training data using train function with the method defaulting to bootstrap. Center and scale your data within your train function. 
### In doing so, make predictions with the knnmodel using the centered and scaled data data.
### Calculate the accuracy rate and produce a confusion matrix, saving your mean function calculating accuracy to a variable called knnaccuracy.
set.seed(1)
knnmodel <- train(Class~., data=traintransformed)
knnclass <- predict(knnmodel,testtransformed)
confusionMatrix(knnclass, testtransformed$Class)

####################################################################################################################
### Answer the question: 
## 4) What is the best number of nearest neighbors to maximize accuracy (5, 7, or 9)? Save your function calculating this answer to a variable called bestTune.
bestTune <- knnmodel$bestTune
bestTune
# the best number of k is 12.

## Answer the following questions: 
### 5) What is your model accuracy given the best K? Save your mean function calculating this answer to a variable called knnaccuracy.
knnaccuracy<-mean(knnclass==testtransformed$Class)
knnaccuracy
# the knn model's accuracy rate is 0.926
####################################################################################################################
### Compare the results of each technique (ldaaccuradcy, qdaaccuracy, and knnaccuracy). 
####################################################################################################################
## 6) Answer - Which technique gave you the best accuracy rate? 
# comparing the accuracy rate, qda model gives out the best accuracy rate of 0.971.

####################################################################################################################
########Model 4: K-Fold using most accurate model
### On the best model that gave you the highest accuracy rate, execute a k-fold validation technique with k set to 10. Reset the seed before running. 
## Answer the following questions:
##   7) What is your k-Fold accuracy rate with your same training group as above?
##   8) What is your new test accuracy rate and how does it compare to the test you did above.

traincontrol <- trainControl(method="cv",number=10)
set.seed(1)
modelkfold <- train(Class~.,method="qda",data=traintransformed,trControl=traincontrol)
newpred <- predict(modelkfold,newdata=testtransformed)
mean(newpred==testtransformed$Class) #0.971
confusionMatrix(newpred,testtransformed$Class)

# the newest test accuracy rate is 0.971 which is the same compared to the qda above. 

## Last question - what does your findings tell you about the overall shape of the data?
# QDA model does better among all the models means that the data may not have a linear relationship. 

## After you finish writing your code and editing your file, submit your .R file directly to Blackboard. 

