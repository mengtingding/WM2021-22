## model 1 - life expectancy model ##################

beverages <- read.csv("BeverageSales.csv")
attach(beverages)

str(beverages)
summary(beverages)

plot(Sales ~ Temperature) # bending upward, there is a quadratic effect 

library(ggplot2)
ggplot(beverages, aes(Temperature, Sales)) + geom_point() + 
  geom_smooth(method="lm") + geom_smooth(method="loess",color="red")
# loess regression, local regression, plot as many straight lines as possible 
# to explain the data

hist(Sales) # sales has positive skewness
hist(Temperature,breaks = 5) #positive skew

lmBev <- lm(Sales ~ Temperature)
summary(lmBev) # adjusted R^2 84%, direct effect is significant 
# RSE 1013 on 40 dof

lmBevQuad <- lm(Sales ~ Temperature + I(Temperature^2))
summary(lmBevQuad)
# adjusted R^2 94% 
# RSE 618 DOF 39

lmBevCubic <- lm(Sales~poly(Temperature, 3))
summary(lmBevCubic)
# 94% adjusted R^2 did not add any more exlaination, and cubic variable is not 
# a significant variable, significant model, 
# Quadratic is better among the three 
anova(lmBev, lmBevQuad)


## log
lmBevlogx <- lm(Sales~log(Temperature))
summary(lmBevlogx)
plot(Sales~log(Temperature))

lmBevloglog <- lm(log(Sales) ~ log(Temperature))
summary(lmBevloglog)
plot(log(Sales) ~ log(Temperature)) # it helped smooth the bend

lmBevlogy <- lm(log(Sales) ~ Temperature)
summary(lmBevlogy)
plot(log(Sales) ~ Temperature) # similar effect as loglog
## can choose loglog or logy, whichever is easier to interpret

sig <- sigma(lmBevloglog);
sig

#====================== Lecture W9 2 ==================================
perceptions <- read.csv("worldPerceptions(1).csv",stringsAsFactors = TRUE)
perceptions <- perceptions[,-1]
str(perceptions)

plot(perceptions$Region)
plot(LifeExpectancy ~ Region, data=perceptions)

## make lm for qualitative variable
categorical <- lm(LifeExpectancy ~ Region, data=perceptions)
summary(categorical)
# explained 75% of variance for region

## make a lm one qualitative variable and one continuous variable
catcont <- lm(LifeExpectancy ~ GDPpercapita + Region, data=perceptions)
summary(catcont)

GDPEastAsia <- 12
catcont$coefficients[1]+catcont$coefficients[2]*GDPEastAsia + catcont$coefficients[4]
#given the GDP of east asia region is 12, our estimated life expectancy is 75.5 


## model 2 - salaries ###########
salaries <- read.csv("Salaries.csv",stringsAsFactors = TRUE)
str(salaries)

lmAge <- lm(Salary~Age, data=salaries)
summary(lmAge)
plot(Salary~Age, data=salaries) #positve and steep (strong relationship)
abline(lmAge)

lmMBA <- lm(Salary~MBA, data=salaries)
summary(lmMBA)
plot(Salary~MBA, data=salaries) #model is not significant pvalue 0.2

lmSalary <- lm(Salary~Age*MBA, data=salaries)
summary(lmSalary) #interaction is significant, 

library(ggplot2)
ggplot(salaries,aes(Age,Salary)) +geom_point()+geom_smooth(method = "lm")
MBA <- salaries$MBA
ggplot(salaries,aes(Age,Salary,color=MBA))+geom_point()+geom_smooth(method = "lm")



## MODEL 3 - MULTI-REGRESSION WITH LIFE EXPECTANCY#####################
lmML <- lm(LifeExpectancy~.-Generosity,data=perceptions)
summary(lmML)
#with region, Adjusted R^2 0.823, without region adjusted R^2 0.74
#without generosity adjsuted R^2 83%
cor(perceptions[,2:7])

