data("cars")
str(cars)
summary(cars)

lmcar <- lm(cars$dist~cars$speed)
summary(lmcar)

plot(dist~speed, data=cars)
abline(lmcar,col="red")

speed <- 10
-17.5791 + 3.9324 * speed
confint(lmcar, level=.95)
s 







Ad <- read.csv("Advertising.csv")

str(Ad)
summary(Ad)
pairs(Ad)

# make regression object
options(scipen = 999)
attach(Ad)
lmAd <- lm(sales~TV, data = Ad)
summary(lmAd)

plot(sales~TV, data=Ad)
abline(lmAd, col="purple")

coef(lmAd)

tv <- 150
7.03259355 + 0.04753664 * tv

confint(lmAd)
6.12971927 + 0.04223072 * tv # lower bound
7.93546783 + 0.05284256 * tv # upper bound of CI, given tv at 150, we estimate sales at an upper
#bound of 15861.95
## [12.46433,15.86185] 95% CI

predict(lmAd, data.frame(TV=150))

hist(lmAd$residuals)
mean(lmAd$residuals)
par(mfrow=c(2,2))

plot(lmAd)
plot(Ad$TV, Ad$sales)
abline(lmAd)
#heteroskedasticity test
install.packages("lmtest")

par(mfrow=c(1,1))
lmtest::bptest(lmAd)
#The p value more close 0, the more heteroskedasticity it is
# violation of homoskedasticity assumption 


## corolla
corolla <- read.csv("corolla.csv")
summary(corolla)

# clean the dataseet
corolla$Fuel_Type <- as.factor(corolla$Fuel_Type)
class(corolla$Fuel_Type)
Model <- as.factor(Model)
class(Model)

hist(Price)
plot(Price ~ Age)
plot(Price ~ KM)


fix(corolla)
summary(corolla)
plot(corolla$Price~corolla$cc)
## generate an example
