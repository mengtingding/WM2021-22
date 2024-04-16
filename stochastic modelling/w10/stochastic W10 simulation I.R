library(extraDistr)
## rolling dice
dice_roll <- function(){
  choice1 <- rdunif(1,min=1,max=6)
  choice2 <- rdunif(1,min=1,max=6)
  results <- choice1 + choice2
  if(results== 6 | results==7){
    ans <-"Draw"
  } 
  else if (results<6){
  ans <- "You Win"
  }
  else{
  ans <- "You lose"
  }
  return(ans)
}

## simulating several tosses
dice_roll_results <- function(times){
  results <- c()
  for(i in 1:times){
    results[i] <- dice_roll()
  }
  return(results)
}

dice_roll_results(100)
nreps <- c(100,200,500,1000,5000,10000,20000)

probabilities<- c()
for(i in nreps){
  result<- dice_roll_results(i)
  prob <- sum(result =="You Win")/i
  probabilities <- c(probabilities, prob)
}
plot(probabilities)
abline(h=0.2778,col="black", lty=2)

##############################
# Casino 
" Assume that 100 people arrive at the casino on average per day and accept the 
  following gamble: An entry fee of $10,000 dollars. Each admitted person plays 
  the game in 1) once and then leaves the casino. The casino will pay $1,000,000 
  to the participants (to be divided equally between the people who attended) if 
  more than 25 win the dice roll game. Assume that the casino has no costs and 
  only consider the revenues provided by the event. "

# number of people, results, number of people who won, 

library(tidyverse)
count_results <- function(x){
  count <- 0
  for(i in x){
    if (i=="You win"){
      count = count+1
    }
  }
  return(count)
}


number_days <- 3000
simulation <- tibble(people = rpois(number_days,100))
simulation %>% mutate(results=map(.x=people,.f=~dice_roll_results(.x))) %>% 
  mutate(people_who_won=map_dbl(.x=results,.f=~count_results(.x))) %>% 
  mutate(people_won=case_when(people_who_won>25~1,
                              people_who_won<=25~0)) %>% 
  mutate(casino_won = case_when(people_who_won > 25 ~0,
                                people_who_won <=25 ~1)) %>% 
  mutate(profit_per_person=people_won*1000000/people_who_won) %>% 
  mutate(profit_casino = people*10000-people_won*1000000) -> simulation


library(glue)



####################################
################
##Simulation 2##
#-############-#

# estimate probabilities
"1)	Three men and two women sit in a row of chairs in random order.
Use simulation to estimate the probability that men and women 
alternate. for(), sample(), which(), if()."

n = 100000
count = 0
results <- c()
for (i in 1:n) {
  x <- sample(c("M","M","M","W","W"),5, replace=FALSE)
  if(all(x==c("M","W","M","W","M"))) count = count+1
}

print(count/n)

nrep <- 100000
count <- 0

for (i in 1:nrep){
  x<- sample(c("M","M","M","W","W"),5,replace=FALSE, prob = rep(1/5,5))
  match <- which(x=="W")
  if(match[1]==2 & match[2]==4) count=count+1
}
# which() function gives out the position of the matching condition
print(count/nrep)

# 2) all six faces appear exactly one in six tosses
n <- 100000
count = 0
dice <- c(1:6)
for (i in 1:n){
  x <- sample(dice, 6, replace=TRUE)
  if(length(unique(x))==6) count = count+1
}
print(count/n)
#================================# 
for(i in 1:nrep){
  x=sample(6,replace=TRUE)
  if(length(unique(x))==6) count = count+1
}

# 3) A waiting line consists of 40 men and 10 women arranged in
# random order. Use simulation to estimate the probability that 
# no two women in line are adjacent to one another. for(), 
# sample(), which(), diff()
# let men be 0 and women be 1, no 2 women adjacent to each other
# means that the position difference need to be larger than 1
# if the minimum of the vector is > 1, then all of them > 1
n <- 100000
count = 0
for (i in 1:n){
  x = sample(c(rep("W",10),rep("M",40)))
  pos <- which(x=="W")
  if(min(diff(pos))>1) count=count+1
}
print(count/n)

# 4) you roll a fair die five times, estimate the probability
# you will see a string of three or more ones. for(), sample(), sum()
# 1's are adjacent to each other
n <- 100000
count = 0
c = 0
for(i in 1:n){
  x =sample(1:6,5,replace=TRUE)
  if(sum(x[1:3])==3|
     sum(x[2:4])==3|
     sum(x[3:5])==3) {
    count =count+1
    }
}
print(count/n)
# length(which(x=="1"))>=3
for(i in 1:n){
  x =sample(1:6,5,replace=TRUE)
  if(length(which(x=="1"))>=3) {
    c =c+1
  }
}
print(c/n)
#==============================================================================#
# Business problem 
# A new edition of a very popular textbook will be published a year from 
# now. The publisher estimates that demand for the next year is governed 
# by the probability distribution in Table 1. A production run incurs a 
# fixed cost of $15000 plus a variable cost of $20 per book printed. Books
# are sold for $190 per book. Up to 1000 of any leftover books can be sold
# to Barnes and Noble for $45 per book. The publisher is interested in 
# printing 8000 copies of the book. Use simulation with 100000 
# replications to find the expected profit and standard deviation. 
# The publisher can be 90% certain that the actual profit associated with 
# remaining sales of the current edition will be between what 2 values?
Fcost <- 15000
Vcost <- 20
p <- 190
refund <- 45
printed <- 8000

nrep <- 100000
demand <- sample(c(3000,4000,5000,6000,8000,10000),nrep,replace=TRUE,prob = c(0.2,0.35,0.25,0.10,0.05,0.05))
total_copies <- rep(printed, nrep)

unsold <- c()
for(i in 1:nrep){
  unsold[i] <- max(total_copies[i]-demand[i],0) # demand ???10000 > 8000
}

eligible_refund <- c() # only takes max 1000
for(i in 1:nrep){
  eligible_refund[i] <- ifelse(unsold[i]>1000, 1000, unsold[i])
}
refund_revenue <- eligible_refund * refund

total_revenue <- c()
for(i in 1:nrep){total_revenue[i] <- min(demand[i],printed)*p}

profit <- c()
for(i in 1:nrep){
  profit[i] <- total_revenue[i] + refund_revenue[i] - Fcost - Vcost*printed
}

#
expected_profit <- mean(profit)
sd_profit <- sd(profit)

library(glue)
glue("After simulation, printing {printed} textbooks yields an 
     expected profit of {expected_profits} and SD of {sd_profits}")

hist(demand)
hist(profit)
glue("The publisher can be 90% certain that actual profit is 
     between {sort(profit)[0.05*nrep]} and 
     {sort(profit)[0.95*nrep]}") #range 5% - 95% (90% interval)