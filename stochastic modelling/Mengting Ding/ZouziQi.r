# Honor Code:
# The Pledge: "As a member of the William and Mary community, I pledge on my honor
#not to lie, cheat, or steal, either in my academic or personal life. I understand that such
#acts violate the Honor Code and undermine the community of trust, of which we are all
#stewards.
rm(list=ls())
library(glue)
### Q1.

# a
library(glue)
p = c(0.3, 0.2, 0.3, 0.15, 0.05)
d = c(100, 150, 200 ,250 ,300)

avg = sum(p*d)
avg 
glue('the expected demand is {avg}')
s = sqrt(sum((p - avg)^2 * p))
s
glue('the standard deviation is {s}')
# b

n = 175
b = 10000
sam = sample(d, b, replace = T, prob = p)
prof = sam
for(i in 1:b){
  if(sam[i] - n >= 0){
    prof[i] = n * (12 - 8.2)
  }
  else{prof[i] = sam[i]*(12 - 8.2) - (n - sam[i])*(8.2 - 3.25)}
}


names(which.max(table(prof)))


# c

glue(' the mean is {mean(prof)}')
glue('the sd is {sd(prof)}')

## Q2
# a
count = 0
k = 25
while(k > 1){
  if(k%% 2 == 1){
    k = k*3 + 1
  }
  else(k = k/2)
  count = count + 1
  print(k)
}

count
glue('{count} is the minutes would a person with inital engagement score of 25')
# b

n = 1000
start = rpois(n, 55)

timevec = rep(0, n)
for(j in 1:n){
  count = 0
  k = start[j]
  while(k > 1){
    if(k%% 2 == 1){
      k = k*3 + 1
    }
    else(k = k/2)
    count = count + 1
  }
  timevec[j] = count
}

glue('the average time after simulation is {mean(timevec)}')
