setwd("C:/Users/mengt/Desktop/S1/machine learning I/data")

case2 <- read.csv("Case2.csv")
library(ggplot2)
library(dplyr)
library(broom)
## dependent variable - FTRetentionRate, explore 3 simple linear 
## relationships, comment on positive, negative, no relationship 
## include residual plots. 

str(case2)
lmtuition <- lm(FTRetentionRate ~ TuitionAndFees, data = case2)
summary(lmtuition)
# positive relationship
plot(case2$TuitionAndFees,case2$FTRetentionRate)

## residual plot
hist(lmtuition$residuals) # a little left skewed according to the histogram
(mean(lmtuition$residuals)) # mean of residual is about 0

## assumption testing
lmtest::bptest(lmtuition) # p value < 0.05, did not pass, the null hypothesis is homo, alternative is hetero
# the homoskedasticity test therefore, fail the assumption of homoskedasticity

#cor(case2$FTRetentionRate,case2$TuitionAndFees)


  
