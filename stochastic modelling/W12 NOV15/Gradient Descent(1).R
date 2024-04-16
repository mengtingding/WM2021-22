rm(list=ls()) # Clears objects
Qs <- seq(0,250,by=10) # create some products

# Define the function we want to optimize.
# The profit function.

f <-  function(Q) {
  (12*Q-0.1*Q^2+10*Q+50)
}

# This is the slope function

grad <- function(Q){
  (12-0.2*Q+10)
}

# plot the function 
plot(Qs , f (Qs), type="l",xlab="Output (Q)",ylab="Profit")
abline(h=0)

 
# gradient descent
lines (c (110,110), c (0,1260), col="red",lty=2)
text (120,1000, "Closed Form Solution",col="red",pos=4)


# Gradient Descent
Q <- 30 # initialize the first guess for x-value
Qtrace <- Q # store output values for graphing purposes (initial)
ftrace <- f(Q) # store profit values (function evaluated at x) for graphing purposes (initial)
Qgrad <- grad(Q)  # store the slopes
L <- 0.5 # learning rate 'alpha' (try 1, 8, and 12)
for (step in 1:10000) {
  Q <- Q + L*grad(Q) # gradient descent update
  Qtrace <- c(Qtrace,Q) # update for graph
  ftrace <- c(ftrace,f(Q)) # update for graph
  Qgrad <- c(Qgrad,grad(Q)) #Vector of slopes
}
#=dmt: choosing learning rate of 12, the gradient descent doesn't converge (no solution), since it took a very long step each step

lines (Qtrace , ftrace , type="b",col="blue")

text (50,500, "Gradient Ascent",col="blue",pos= 4)

# print final value of Q
print(Q)

# A quartic Function
rm(list=ls()) 
xs <- seq(-4,5,by=0.0001) 

f <-  function(x) {
  ((x-6)*(x+4)*(7*x^2+10*x+24))
}

df<- function(x){
  ((x + 4)*(7*x^2 + 10*x + 24) + (x - 6)*(7*x^2 + 10*x + 24) + (x - 6)*(x + 4)*(14*x + 10))
} #= derivatives

plot(xs,f(xs),type='l')
points(4,-2816, col="red") #Min
points(-2.571428571,-545.7725948,col="red")  #Min
points(-1,-441, col="red")
#- dmt: 3 inflection points

X <- 1  #Try -10, -1.5, -1, 1, and 10

Xs <- X
fXs <- f(X)

L <- 0.0001 
for (step in 1:10000) {
  X <- X - L*df(X)
  Xs<-c(Xs,X)
  fXs<-c(fXs,f(X))
}

lines ( Xs , fXs , type="b",col="blue")

print(X)
print(f(X))
df(X)

# in order to not stuck in one of the local min/max, multiselect starting point

