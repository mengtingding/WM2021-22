rm(list=ls())

test <- read.csv("test.csv",stringsAsFactors = TRUE)
train <- read.csv("train.csv",stringsAsFactors = TRUE)
summary(as.factor(train$target))
