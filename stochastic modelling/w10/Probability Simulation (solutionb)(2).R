
# 1

nrep<-10000
count<-0  #Favorable

for (i in 1:nrep){
  x<-sample(c("W","W","M","M","M"),size=5,replace=FALSE,prob=rep(1/5,5))
  match<-which(x=="W")
  if (match[1]==2 & match[2]==4) count=count+1
}

(probability<-count/nrep)


#2 

nrep =100000
count = 0
for(i in 1:nrep){
  x=sample(6,replace=TRUE)
  if(length(unique(x))==6) count = count+1
}

(count/nrep)


#3

nrep =100000
count = 0
x = c(rep(0,40), rep(1,10))
for(i in 1:nrep){
  y=sample(x)
  positions = which(y==1)
  difference=diff(positions)
  if (min(difference)>1) count=count+1
}

print(count/nrep)

#4
g<-function(){
nrep = 100000
count = 0 
for (i in 1:nrep){
  x= sample(1:6,5, replace=TRUE)
  if (sum(x[1:3])==3|
      sum(x[2:4])==3|
      sum(x[3:5])==3) count = count+1
}
return(count/nrep)
}

system.time(g())
#print(count/nrep)


#BUSINESS PROBLEM
rm(list=ls())

# Inputs
fixed_cost<-15000   # The fixed cost of producing textbooks
variable_cost<-20   # The variable cost per textbook produced
price<-190          # Price at which we can sell the textbooks
refund<-45          # The refund for unsold textbooks

# Decision Variable
printed<-8000



nrep<-10000
  # Model
demand<-sample(c(3000,4000,5000,6000,8000,10000),nrep,replace=TRUE,prob = c(0.2,0.35,0.25,0.1,0.05,0.05))
total_copies<-rep(printed,nrep)
  
unsold_copies<-c()
for (i in 1:nrep){
    unsold_copies[i]=max(total_copies[i]-demand[i],0)
  }
  
refund_eligible<-c()
for (i in 1:nrep){
    refund_eligible[i]=ifelse(unsold_copies[i]>1000,1000,unsold_copies[i])
  }
refund_revenue<-refund_eligible*refund
  
total_revenue<-c()
for (i in 1:nrep){
    total_revenue[i]=min(total_copies[i],demand[i])*price
  }
  
total_cost<-printed*variable_cost+fixed_cost
profit<-total_revenue+refund_revenue-total_cost
  
expected_profits<-mean(profit)
sd_profits<-sd(profit)


# Answer
library(glue)
glue("After simulation, printing {printed} textbooks yields an 
     expected profit of {expected_profits} and SD of {sd_profits}")

hist(demand)
hist(profit)
glue("The publisher can be 90% certain that actual profit is 
     between {sort(profit)[0.05*nrep]} and 
     {sort(profit)[0.95*nrep]}")
