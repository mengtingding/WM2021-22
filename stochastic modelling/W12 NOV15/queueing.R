rm(list = ls())
library(queueing)

# a fast food restaurant has one drive-hrough window.
# on average, 40 customers arrive per hour at the window
# it takes an average of 1 min to serve a customer.
# assume the inter-arrival and service time are exponentially distributed

# on average how many customers are in the waiting line
ff <- QueueingModel(NewInput.MM1(lambda=40,mu=60,n=0))
summary(ff)
# on average how long does a customer spend at the restaurant
