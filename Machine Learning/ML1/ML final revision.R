"Machine Learning I revision 

#================

Week 4

## Supervised vs unsupervised modelling and prediction 

Supervised: algorithms learn from a labeled dataset and providing an answer which can be evaluated from the training set. 

* regressions (quantitative)
* 
  
  Unsupervised: unlabeled dataset

- classifications (qualitative)
- knn
- LDA, QDA



### reducible error vs irreducible error

- accuracy of predictions depends on these 2 types of errors
- reducible errors are the errors can be reduced (or accuracy can be improved) by using appropriate ML technique
- irreducible errors are due to the variabilities of the predictions ($\epsilon$ term), 

### Estimating $f$ 

* linear vs non-linear
* parametric vs non-parametric

### 6 V's in data

Volume, Variety, Velocity, Variability, Veracity, Value

Reliability - data is accurate and consistent 

Validity - correctly measures what is supposed to be measured

Uncertainty - imperfect knowledge of future

Problems:
  
- third variables (omitted variables) problem
- confounding variables
- directionality problems ( when model Y~X while it should be X~Y)
- selection bias: 

  #=====================

Week 5

Intro to R

R - dynamically typed language, open source

### Assessing model accuracy

bias-variance trade-off

#===============

Week 6

Simple linear regression 

explanatory models vs predictive models

**explanatory model:**  maximize the amount of information explained (how well the model approximates the data)

assumptions: normal distribution 

predictive model: training set and testing set, performance measured by predictive accuracy 

ANOVA analysis - whether variation of Y is due to varying levels of X

adjusted R^2 - sample size & number of X variables 

Linear assumptions:
  
linearity, normality of errors, independence of errors, homoscedasticity

#===================

Week 7 

8 multiple linear regression 

deciding on important variables: VIF, corr(), 

forward selection, backward selection, mixed selection

9 interaction effect 

midterm

#================

Week 9

10 nonlinear

log transformation

log-log regression: can't use adjusted R^2 on log(y), compute the correlation between y and y_hat 

explanation on different models 

log-log: 1% increase in x will change y by percent change

semi-log: y = b0 + b1*log(x), b1 * 0.01 measures the approximate change in y_hat when x increases by 1%

exponential: log(y) = b0+b1*x, y=exp(b0+b1 * x): b1*100 measures the approximate percentage change in y_hat when x increases by 1 unit. 

11 categorical 

explaining categorical variables in log (y) transformation. 

i.e. log(write) = 3.135+0.11female+0.006read+0.007math

0.11 = mean(female)/mean(male), writing score will be 11% higher for the female student than for the male students

Week 10 

13 logistic regression 

odds for A = P(A)/(1-P(A))

exp(coef(logistic reg))

prob of A in logistic regression = exp(b0+b1)/(1+exp(b0+b1))

confusionMatrix

mean(pred == test$Y) - prediction accuracy

less assumptions: no normal distribution, no linear relationship,  no homoscedasticity

assumptions: linearity for continuous X, no multicollinearity (VIF), no strong influential outliers, error term independency 

week 11

14 LDA - classification method

missing values are omitted, sample size, approximately equal sample size,

assumptions: no influential outliers, multivariate normality, multicollinearity, homoscedasticity, independence

week 12

15 KNN - non-parametric

confusion matrix and validating set

accuracy measures

finding the best k

16 compare methods

sensitivity = A/(A+C); specificity = D/(B+D)

positive predicted value = A/(A+B); negative predicted value = D/(C+D)

prevalence = (A+C)/(A+B+C+D); detection rate = A/(A+B+C+D)

detection prevalence = (A+B)/(A+B+C+D)

balanced accuracy = (sensitivity + specificity)/2

QDA performs better than KNN with limited training observations 

week 13

week 14

16 resampling

 MAE: mean absolute error - robust

MSE: mean squared error

RMSE: root mean square error

MAPE: mean absolute percentage error - robust

**Type of resampling** 

Validation set: only a subset is used, introduce bias by systematically misestimating the test error rate for the model fit on the entire data set, test error rate can be highly variable

CV: LOOCV (far less bias that validation set, no randomness in training set, RMSE, low bias but high variance), K-fold (less variance than LOOCV,  gives more accurate estimates of test error rate over LOOCV)

Determine k in k-fold: choose 5 or 10, if k is chosen that not evenly split the dataset, one group will contain a remainder of the examples

17 bootstrap - quantify uncertainty

sampling with replacement

library(boot), traincontrol



week 15















