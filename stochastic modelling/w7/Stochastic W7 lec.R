Bonus <- c(10,6,3,0)
probs <- c(0.15,0.25,0.4,0.2)
sum(probs)
freq.dist <- data.frame(Bonus, probs)

(ev <- sum(Bonus * probs))
mean(Bonus)

(Var.bonus <- sum(probs * (Bonus-ev)^2))
(stdv <- sqrt(Var.bonus))

(sum(probs * Bonus^2) - ev^2)

## portfolio
Bitcoin <- c(13.18,-0.726,0.872,3.082)
SaP <- c(0.209,-0.052,0.313,0.173)
investment <- data.frame(Bitcoin, SaP)

alpha <- 0.5
port_return <- alpha * mean(Bitcoin) + (1-alpha) * mean(SaP)
(port_risk <- sqrt(alpha^2 * var(Bitcoin) + (1-alpha)^2 * var(SaP) + 
    2 * alpha*(1-alpha)*cov(Bitcoin,SaP)))

(sharpe <- port_return/port_risk)

library(extraDistr)
rdunif(1,1,6)
