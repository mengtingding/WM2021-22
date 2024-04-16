print('The Pledge: "As a member of the William and Mary community, I pledge on my honor not to lie, cheat, or steal, either in my academic or personal life.
      I understand that suchacts violate the Honor Code and undermine the community of trust, of which we are all stewards."') 
library(glue)
# 1)
cost <- 8.2
price <- 12
refund <- 3.25

# a)
demand <- c(100,150,200,250,300)
p <- c(0.3,0.2,0.3,0.15,0.05)
expected <- c()
for (i in 1:length(demand)){
  expected[i] <- demand[i]*p[i]
}
expected_demand<- sum(expected)
E_x_sq <- 0.3*100^2+0.2*150^2+200^2*0.3+0.15*250^2+300^2*0.05
EX_sq <- expected_demand^2
sd <- sqrt(E_x_sq-EX_sq)

### answering the question using glue.
glue("The expected demand is {expected_demand} and sd is {sd}.")
#b)
nrep <- 10000
demand <- sample(c(100,150,200,250,300),nrep,replace = TRUE, prob = c(0.3,0.2,0.3,0.15,0.05))
copies <- rep(175,nrep)
unsold <- c()
for(i in 1:nrep){
  unsold[i] <- max(copies[i] - demand[i],0)
}
refund_revenue <- c() # unsold*refund
for (i in 1:nrep){
  refund_revenue[i] <- refund*unsold[i]
}
total_revenue <- c()
for(i in 1:nrep){
  total_revenue[i] <- refund_revenue[i] + min(copies[i],demand[i]) * price #??????demand???copies???,????????????175???,??????demand???copies???,????????????demand
}
profit <- c()
for(i in 1:nrep){
  profit[i] <- total_revenue[i] - cost*copies[i]
}
table(profit)
# The most likely profit would be $965
nrep <- 10000
printed <- 175
refund <- 3.25
price <- 12
cost <- 8.2
demand<-sample(c(100,150,200,250,300),nrep,replace=TRUE,prob = c(0.3,0.2,0.3,0.15,0.05))
total_copies<-rep(printed,nrep)

unsold_copies<-c()
for (i in 1:nrep){
  unsold_copies[i]=max(total_copies[i]-demand[i],0)
}

refund_eligible<-c()
for (i in 1:nrep){
  refund_eligible[i]=unsold_copies[i]
}
refund_revenue<-refund_eligible*refund

total_revenue<-c()
for (i in 1:nrep){
  total_revenue[i]=min(total_copies[i],demand[i])*price
}

total_cost<-printed*cost
profit<-total_revenue+refund_revenue-total_cost

expected_profits<-mean(profit)
sd_profits<-sd(profit)




# c)
average_profit <- mean(profit)
sd_profit <- sd(profit)
glue("The average profit is {average_profit} and the standard deviation of profit is {sd_profit}.")

# 2)

# a)
score <- 25
minute <- 0

while(score > 1){
  minute = minute+1
  if(score%%2==0){
    score=score/2}else{
    score = score*3+1}
}

glue("A person with initial engagement score of 25 has {minute} minutes to be engaged.")

# b)
simulation <- rpois(1000,55)
average_time <- mean(simulation)
glue("The average time spent on the website for this simulation is {average_time}.")

for (i in 1:1000){
  sim <- rpois(1,55)
  
}
