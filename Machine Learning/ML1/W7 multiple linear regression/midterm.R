########[Mengting Ding]############


#################Loading And Evaluating Data#################
##Load the Credit dataset from the ISLR library
library(ISLR)
data("Credit")

##Use 2 descriptor functions to evaluate what all is inside the Credit dataset
str(Credit)
summary(Credit)

##Remove columns 1,8,9,10 and 11 from the dataset
Credit <- Credit[,-c(1,8,9,10,11)]

#################Multiple Linear Regression to Explain#################
##Using multiple linear regression, create a linear model that predicts Balance. 
##You may use the step equation to help you determine the best model. 
##However, ensure to eliminate any noise variables, and explain the most variance 
##through the smallest number of predictors.
lmCr_step <- step(lm(Balance~.,data=Credit),direction = "backward")
summary(lmCr_step)
car::vif(lmCr_step)
#backward model: lmCr <- lm(Balance~Income+Limit+Rating+Cards+Age, data = Credit), adjusted R^2=0.877
lmCr <- lm(Balance~Income+Limit+Cards+Age, data = Credit) #lm removed Rating adjusted 0.875
summary(lmCr)

##In creating a model eliminate additional variable(s) based on your multicollinearity findings. 
##There is no need to check other assumptions for this assignment, just multicollinearity.
car::vif(lmCr) #Limit and Rating have very high VIF

##Answer - Did you remove any variables due to multicollinearlity? Why or why not?
# I removed Rating factor because in the original backward linear model, vif for 
# Rating and Limit are very high means there is multicollinearity, however after removing
# Rating and Limit both, adjusted R^2 dropped sharply from 0.877 to 0.225. Adding either one of 
# Rating or Limit back would increase adjusted R^2 to 0.875 and reduce vif of all factors to less than 5
# showing that there is no multicollinearity. 

##Provide your final regression equation: 
lmCr <- lm(Balance~Income+Limit+Cards+Age, data = Credit)
summary(lmCr)
##Answer - what is your interpretation of the final linear model?
# The multiple linear model is Balance = -399.6-7*Income+26.28*Limit+21.42*Cards-88.76*Age
# As income increases 1 unit, balance would decrease 7 units.
# As limit increases 1 unit, balance will decrease 26.28 units.
# As Cards increases 1 unit, balance will increase 21.42 units.
# As age increases 1 unit, balance will decreases 88.76 units. 
# ======= should also remove age as it is not significant in the model.
#################Multiple Linear Regression to Predict#################
##Using the Credit dataset with the same columns subtracted from the initial instructions (columns 1,8,9,10 and 11),
##separate the data into 2 groups, testing and training. 
##Put 300 data points in the training group and the rest in the testing group. 
##Stabilize the set seed before running a random sample function with a number of your choice. 
set.seed(123)
data("Credit")
Credit <- Credit[,-c(1,8,9,10,11)]
n <- length(Credit$Balance)
n1 <- 300
trainobsnum <- sample(1:n, n1)
train <- Credit[trainobsnum,]
test <- Credit[-trainobsnum,]
##Using all the variables predicting Balance, create a linear model using the training/testing technique we learned in class.
##Use a function to predict the accuracy of the model using the newdata by evaluating the correct correlation.
lmtrain <- lm(Balance ~ ., data = train)
summary(lmtrain)

predictions <- predict(lmtrain, newdata = test)
cor(predictions, test$Balance)

##Answer - Provide the correlation found and an interpretation on how well the model did at making predictions. 
# The correlation is 0.945 between the prediction and the observed data, which means that there is a strong 
# correlation and the prediction does well on making predictions.
