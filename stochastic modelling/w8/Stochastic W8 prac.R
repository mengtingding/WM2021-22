#pbinom - culmulative probability
#dbinom - point probability

n <- 5 # Number of trials
p <- .17 # probability of bad quality

choose(n,2) * p^2 * (1-p)^(n-2)

dbinom(2,n,p) # f(2)
pbinom(1,n,p,lower.tail=F) # 1 - F(1)
dbinom(0,n,p) + dbinom(1,n,p) #f(0) + f(1) = F(1)

#Basketball
n <- 3
p <- 0.9
s <- 10000

simulation <- rbinom(s,n,p)
hist(simulation)

