# problem 2
a <- 1000
b <- 6000
c <- 3000
## what is the prob. that future weekly sales are between $2000 and $2500?

library(triangle)
ptriangle(2500,a=1000,b=6000,c=3000)-ptriangle(2000,a=1000,b=6000,c=3000)

## What is the probability that future weekly sales are greater than $4000?
1 - ptriangle(4000,a=1000,b=6000,c=3000)
rtriangle(2,1000,6000,3000)
