library(triangle)
rm(list=ls())



## alt#1 (Fixed)----------------------------------------------------------------------------------------
pmt <- 155000
cost <- 140*1000
profit <- pmt-cost
r <- 0.005
Present_value <- c()
for (i in 1:24){
  Present_value[i] <- 1/(1+r)^i
}

sum_pv <- sum(Present_value)

#expected value 1
ev_fixed <- sum_pv*profit
ev_fixed

## alt#2 (Bonus)----------------------------------------------------------------------------------------
p_with_bonus <- 0.7
pmt2 <- 125000
cost <- 140*1000
profit2 <- pmt2-cost
present_value_notadd_bonus <- profit2*sum_pv
Bonus <- 1500000
r_year <- 0.0617
n <- 2
pv_bonus <- Bonus/(1+r_year)^2
after_bonus_pv <- present_value_notadd_bonus+pv_bonus
after_bonus_pv
#992279.9 with bonus 

#without bonus 
p_without_bonus <- 0.3
without_bonus <- profit2*sum_pv
without_bonus

#expected value Bonus
ev_bonus <- after_bonus_pv*p_with_bonus + without_bonus*p_without_bonus
ev_bonus




## alt#3 (RFP)---------------------------------------------------------------------------------------------

pmt3 <- 150000
profit3 <- pmt3-cost
present_value3 <- profit3*sum_pv


#simulate savings(in millions)


savings<-rtriangle(n=100000,a=3.2,b=12.8,c=5.6)
savings

lessthan4<-0
between4and6<-0
between6and8<-0
greaterthan8<-0
  

for (i in 1:length(savings)) {
  if(savings[i]<4){
    lessthan4<-c(lessthan4,savings[i])
  }
  else if(savings[i]>4 & savings[i]<6){
    between4and6<-c(between4and6,savings[i])
  }
  else if(savings[i]>6 & savings[i]<8){
    between6and8<-c(between6and8,savings[i])
  }
  else{
    greaterthan8<-c(greaterthan8,savings[i])
  }
}

avg_bin1 <- mean(lessthan4)
avg_bin2 <- mean(between4and6)
avg_bin3 <- mean(between6and8)
avg_bin4 <- mean(greaterthan8)

gainshareFactor1 <- 0
gainshareFactor2 <- .2
gainshareFactor3 <- .4
gainshareFactor4 <- .6

gainshareBonus3 <- .4
gainshareBonus4 <- 1.2

#
library(dplyr)
pless4 <- ptriangle(4,a=3.2,b=12.8,c=5.6)
pb46 <- ptriangle(6,a=3.2,b=12.8,c=5.6) - ptriangle(4,a=3.2,b=12.8,c=5.6)
pb68 <- ptriangle(8,a=3.2,b=12.8,c=5.6) - ptriangle(6,a=3.2,b=12.8,c=5.6)
pgreater8 <- 1-ptriangle(8,a=3.2,b=12.8,c=5.6)





#winners share for less than 4mill
winshare1 <- avg_bin1*gainshareFactor1
winshare1
#expected value 1
ev1 <- winshare1*pless4*1000000
ev1

#doesnt need to be discounted

#winners share for between 4 and 6
winshare2 <- (avg_bin2-4)*gainshareFactor2
winshare2
#discount gain sharing2
disc_winshare2 <- winshare2/(1+r_year)^n
#expected value 2
ev2 <- disc_winshare2*pb46*1000000
ev2

#winners share for between 6 and 8
winshare3 <- ((avg_bin3-6)*gainshareFactor3)+gainshareBonus3
winshare3
#discount gain sharing3
disc_winshare3 <- winshare3/(1+r_year)^n
#expected value 3
ev3 <- disc_winshare3*pb68*1000000
ev3

#winners share for greater than 8
winshare4 <- ((avg_bin4-8)*gainshareFactor4)+gainshareBonus4
winshare4
#discount gain sharing
disc_winshare4 <- winshare4/(1+r_year)^n
#expected value 4
ev4 <- disc_winshare4*pgreater8*1000000
ev4

prob_winbid <- 0.45
prob_losebid <- 1-prob_winbid
#find expected value for RFP decision
ev_rfp <- (present_value3+ev1+ev2+ev3+ev4)*prob_winbid
ev_rfp








