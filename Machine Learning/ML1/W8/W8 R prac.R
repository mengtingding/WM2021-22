Advertising <- read.csv("Advertising.csv")

str(Advertising)
Advertising <- Advertising[,-1]

cor(Advertising)

options(scipen=10) #disable scientific notation
lmAdvert <- lm(sales ~ TV*radio, data=Advertising)
summary(lmAdvert)

coef(lmAdvert)
## sales = 6.75 + 0.019*TV + 0.029 * radio + 0.001 TV*radio

lmAdvert2 <- lm(sales ~ TV*newspaper, data = Advertising)
summary(lmAdvert2)

car::vif(lmAdvert)

hist(lmAdvert$residuals,breaks=20)
lmtest::bptest(lmAdvert) #heteroskedastic p-value 0.002 < 0.05
plot(lmAdvert) #131 is definitely an outlier

######### corolla ############
corolla <- read.csv("corolla.csv")
lmCorolla <- lm(Price ~ Age+HP, data=corolla)
summary(lmCorolla) # adding an interaction term (adjusted R^2 0.81) does not 
# improve the model much (adjusted R^2 0.8)
## age doesn't negatively influence the price that much when consider HP
car::vif(lmCorolla)#remove interaction term when doing vif, no collinearity
hist(lmCorolla$residuals,breaks = 20) #slightly right skewed
plot(lmCorolla) #110 111 112 are pulling the residual line
lmtest::bptest(lmCorolla)  # heteroskedastic

######## cancer #########
cancer <- read.csv("cancer.csv")
cancer <- cancer[,-c(9,13)] #get rid of characteristic variables

#cancer <- na.omit(cancer)
cor(cancer)
lmCancer <- lm(TARGET_deathRate~.-PctSomeCol18_24-PctPrivateCoverageAlone-avgDeathsPerYear,data=cancer)
lmstepCancer <- step(lmCancer,direction="backward")
summary(lmCancer)
car::vif(lmCancer) #high multicollinearity 

lmCancerInter <- lm(TARGET_deathRate ~ incidenceRate * PercentMarried, data=cancer)
summary(lmCancerInter)
plot(lmCancerInter)
lmtest::bptest(lmCancerInter) #hetero
hist(lmCancerInter$residuals,breaks = 20) #quite normal

