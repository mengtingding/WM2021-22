# The Walton Bookstore

# Inputs
calendar_cost<-7.5  # The cost of acquiring calendars
selling_price<-10   # The price Walton can sell the calendars
refund<-2.5         # Unsold calendars can be returned for a refund

# Decision Variable
order<-200          # The decision variable

#################################################################

# Let's solve using the point estimate.

demand<-round(runif(10000,100,300))
#demand<-round(rnorm(10000,200,50))
(mean_demand<-round(mean(demand)))  # Let's use mean demand as our estimate

(revenue<-min(order,mean_demand)*selling_price)
(total_cost<-order*calendar_cost)
(total_refund<- if (order>mean_demand) (order-mean_demand)*refund else 0)
(total_profit<-revenue-total_cost+total_refund)

#################################################################

# Let's see how our model behaves as our order varies...

orders<-seq(50,500,50)
profits<-c()

for (i in 1:length(orders)){
  (revenue<-min(orders[i],mean_demand)*selling_price)
  (total_cost<-orders[i]*calendar_cost)
  (total_refund<- if (orders[i]>mean_demand) (orders[i]-mean_demand)*refund else 0)
  (profits[i]<-revenue-total_cost+total_refund)
}

plot(orders,profits, type="o", pch=19)

# If we order too few, then we miss selling opportunities. If we order too
# much, then we increase our total cost and we have to sell at a lower price.


# We have summarized our demand uncertainty with a point estimate. 
# Let's see how our model behaves as our demand varies (distribution).

demands<-seq(50,500,50)
profits<-c()

for (i in 1:length(demands)){
  (revenue<-min(order,demands[i])*selling_price)
  (total_cost<-order*calendar_cost)
  total_refund<- max(order-demands[i],0)*refund
  (profits[i]<-revenue-total_cost+total_refund)
}

plot(demands,profits, type="o", pch=19)

# Profit is constant for demand above 200. Why? Is our expected profit 
# really equal to 500? What are the real expected profits?

#############################################################

#Using the distribution of demands to estimate expected profits

profits<-c()
demands<-round(runif(1000000,100,300))
#demands<-round(rnorm(1000000,200,50))

for (i in 1:length(demands)){
  (revenue<-min(order,demands[i])*selling_price)
  (total_cost<-order*calendar_cost)
  (total_refund<- max(order-demands[i],0)*refund)
  (profits[i]<-revenue-total_cost+total_refund)
}

mean(profits)
sd(profits)

hist(profits, breaks=seq(min(profits),500,50), col="green3")

# Flaw of Averages: Plans based on assumptions about average 
# conditions are usually inaccurate.



################################################################
# Can we find the optimal number of calendars to order?
rm(list=ls())

# Inputs
calendar_cost<-7.5  # The cost of acquiring calendars
selling_price<-10   # The price Walton can sell the calendars
refund<-2.5         # Unsold calendars can be returned for a refund

# Decision Variable
order<-seq(0,500,50)
#order<-seq(100,300,25)
#order<-seq(160,180,5)
expected_profits<-c()
sd_profits<-c()

for (j in 1:length(order)){
  profits<-c()
  demands<-round(runif(1000000,100,300))
  #demands<-round(rnorm(1000000,200,50))
  
  for (i in 1:length(demands)){
    (revenue<-min(order[j],demands[i])*selling_price)
    (total_cost<-order[j]*calendar_cost)
    (total_refund<- max(order[j]-demands[i],0)*refund)
    (profits[i]<-revenue-total_cost+total_refund)
  }
  expected_profits[j]<-mean(profits)
  sd_profits[j]<-sd(profits)
}

Table<-data.frame(order,expected_profits,sd_profits)
plot(y=Table$expected_profits,x=Table$order,pch=21,bg="blue")

library(glue)
glue("After simulation, ordering {Table$order[which.max(Table$expected_profits)]} 
  calendars yields the best expected profits of {round(max(Table$expected_profits),2)}
  and SD of {round(Table$sd_profits[which.max(Table$expected_profits)],2)}")
        




