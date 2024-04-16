
#Basketball experiment
n <- 3
p <- .9
s <- 100000
simulation <- rbinom(s,n,p)
hist(simulation)

mean(simulation)
n*p
var(simulation)
n*p*(1-p)
table(simulation)/sum(table(simulation))
dbinom(3,3,.9)

# for loops, conditional statements, mapping
library(extraDistr)
library(glue) # allows to combine character with objects

MarbleGame <- function(Result2,Choice2){
  Marbles1 <- 10
  Marbles2 <- 10
  Choice1 <- rdunif(1,1,Marbles1) # create a random choice of marbles
  
  Result1 <- ifelse(Choice1%%2==0,"even","odd")
  winlose <- ifelse(Result2==Result1, "win","lose")

if (Result1 == Result2){
  Marbles2 = Marbles2 + Choice2
  Marbles1 = Marbles1 - Choice2
}else{
  Marbles2 = Marbles2 - Choice2
  Marbles1 = Marbles1 + Choice2
}

glue("I open my hand and reveal {Choice1} Marbles. 
     You {winlose} {Choice2} Marbles. 
     You have {Marbles2} left")
}

MarbleGame("even",5)
MarbleGame("odd",5)

#source()

## For loops
x <- 1:8
for(i in 1:8){
  for (j in 1:8){
    print(glue("column: {i}, Row: {j}"))
  }
}
plot(0,0, type="n",xlim=c(0,8),ylim=c(0,8),xlab="",ylab="",axes=F)
polygon(c(0,4,2),c(0,0,4),col="gold")
polygon(c(4,8,6),c(0,0,4),col="gold")
polygon(c(1,1,0,0),c(1,0,0,1),col="Red")
for (i in 1:8){
  for (j in 1:8){
    if(i%%2 != 0){
      polygon(c(i,i+1),c(),col="black")
    }
  }
}

#OCT 27

# hypergeometric
dhyper() # probability of x successes
phyper() # cumulative probability of x successes
rhyper() # generate random number from hypergeometric distribution

N = 12 # number of fuses
n = 3  # number chosen by the inspector
r = 5  # number of elements labeled success
x = 1  # find 1 defective 

dhyper(x, r,N-r,n)

N = 20 
n = 5
r = 3
x = 1

dhyper(x,r,N-r,n)

#pois

dpois(5,10) # x five arrivals, lambda = 10 per time frame
1-ppois(1,2) # two or more arrivals
ppois(1,2,lower.tail = F) # two or more arrivals

simulation <- rpois(10000,10)
hist(simulation)

polygon(c(1,1,0,0),c(1,0,0,1),col = "black")
polygon(c(2,2,0,0),c(2,1,1,2),col = "red")

plot(0,0,type="n",xlim=c(0,8),ylim=c(0,8),xlab="",ylab="",axes=F)
for (i in 1:8){
  for (j in 1:8){
    if((i+j)%%2 ==0)
      polygon(c(i,i,i-1,i-1),c(j,j-1,j-1,j),col="red")
    else
      polygon(c(i,i,i-1,i-1),c(j,j-1,j-1,j),col="black")
  }
}

# map functions
library(tidyverse)

data <- tibble(gender=list(c("W","W","M"),c("M","M"),c("W")))
for (i in data$gender){
  for (j in i){
    print(j)
  }
}

for (i in data$gender){
  print(i)
}

result <- c()
for (i in data$gender){
  count=0
  for (j in i){
    if(j=="M"){
      count = count + 1
    }
  }
  result <- c(result,count)
}
result

count_if <- function(variable, feature){
  count=0
  for(i in variable){
    if(i==feature) count = count+1
  }
  return(count)
}

map(.x=data$gender,.f=~count_if(.x,"M"))

data %>% mutate(Men=map(.x=data$gender,.f=~count_if(.x,"M"))) -> data
data
