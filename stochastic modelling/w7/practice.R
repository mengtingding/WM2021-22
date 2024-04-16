setwd("C:/Users/mengt/Desktop/S1/machine learning I")

set.seed(1)
x <- rnorm(1000)
x
mean(x)
sd(x)
hist(x)


#install.packages('mltools')
library(mltools)

actual <- c(1,2,9.5)
pred <- c(.9,2.1,10)

sumsquare <- (1-0.9)^2 +(2-2.1)^2 + (9.5-10)^2
mse <- sumsquare/length(actual)
mse

mse(pred, actual)






