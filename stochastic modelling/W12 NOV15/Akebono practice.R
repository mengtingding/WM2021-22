#condition probability: P(great) = 10%, P(OK) = 60%, P(Bad) = 30%

#P_great(x) ~ poi(7) fish/day
#P_ok(x) ~ poi(4)
#P_bad(x) ~ poi(2)

# P(0 yellowfin) = 25%, P(25% yellowfin) = 50%, P(35% yellowfin) = 25%

# Question 1
#How many fish are caught of each type on average (daily)? 
avg_yellow <- 0.5*(7*0.25*0.1+4*0.25*0.6+2*0.35*0.3)+0.25*(0.1*7*0.35+0.6*4*0.35+0.3*2*0.35)
avg_blue <- 0.75*(7*0.1+4*0.6+2*0.3)+0.5*(7*0.75*0.1+4*0.6*0.75+2*0.3*0.75)+0.75*(7*0.65*0.1+4*0.6*0.65+0.65*2*0.3)
### sampling conditions
for (i in 1:10000){
  condition<- sample(c("great","OK","bad"),prob = c(0.1,0.6,0.3),replace=TRUE)}
#Create a histogram of the daily catch. 
sim1 <- rpois(10000,7)
sim2 <- rpois(10000,4)
sim3 <- rpois(10000,2)
hist(0.1*sim1+0.6*sim2+0.3*sim3)
#What is the probability that no fish are caught in a day?




## Weight - normally distributed
# E(Yellow) = 30 lb, E(Blue) = 35 lb
# sd = 18 lb, 

## proportion of edible yield for ok fish ~ Beta distribution, 
## alpha = 70, beta=30
## Great increased 10%, Bad decreased by 25%