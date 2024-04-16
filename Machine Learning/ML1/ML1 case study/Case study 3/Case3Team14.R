#Team 14
#Vanessa Guzman, Mengting Ding, Nash Kleisner, Zouzi Qi
rm(list=ls())
setwd("C:/Users/15713/Documents/machine_learning_1")

data <- read.csv("Case3.csv", stringsAsFactors = TRUE)
attach(data)

str(data)
summary(data)

test <- lm(SalePrice~.,data=data)
summary(test)

allsig <- lm(SalePrice~LotArea+OverallQual+OverallCond+
                YearBuilt+BsmtFinSF1+BsmtFinSF2+BsmtUnfSF+
                X1stFlrSF+X2ndFlrSF+BedroomAbvGr+Fireplaces+
               MSZoningFV+MSZoningRL+MSZoningRM+LandContourLow+
               LotConfigCulDSac+LandSlopeSev+NeighborhoodNoRidge+
               NeighborhoodNridgHt+NeighborhoodStoneBr+Condition1Norm+
               Condition2PosN+HouseStyle1Story+RoofMatlCompShg+RoofMatlMembran+
               RoofMatlRoll+RoofMatlTar&Grv+RoofMatlWdShake+RoofMatlWdShngl+
               Exterior1stImStucc+Exterior2ndImStucc+ExterQualGd+ExterQualTA+
               BsmtQualGd+BsmtQualTA+BsmtExposureGd+BsmtExposureNo+KitchenQualFa+
               KitchenQualGd+KitchenQualTA, data=data) #add all significant variables
summary(allsig)

#three are significant, so should we just keep it
#MSZoningFV            3.849e+04  1.492e+04   2.580 0.010037 *  
#MSZoningRH            2.913e+04  1.619e+04   1.799 0.072418 .  
#MSZoningRL            2.621e+04  1.328e+04   1.973 0.048819 *  
#MSZoningRM            2.428e+04  1.233e+04   1.969 0.049233 *  
plot(MSZoning) #c is IN the intercept
summary(significant)

#down below, should i keep or delete MSZoning, LandContour, LotConfig, LandSlope.
#Neighborhood, Condition1, Condition2, HouseStyle, Exterior1st, Exterior2nd, ExterQual,
#BsmtQual, BsmtExposure

#deleted fireplace and MSZoning
significant <- lm(SalePrice~LotArea+OverallQual+YearBuilt+
                 BsmtUnfSF+Condition1+X2ndFlrSF+BedroomAbvGr+LotConfig+LandSlope+ExterQual+
                 BsmtQual+KitchenQual, data=data)
summary(significant) #rsquared of .9066 and p-value of <2.2e-16
lmtest::bptest(significant) #extremely heteroskedastic
car::vif(significant) #error- there are aliased coefficients in the model

uno <- lm(SalePrice~LotArea)
summary(uno) #rsquared=0.09599 ; p-value: < 0.00000000000000022
hist(uno$residuals) #normal - small right skew
lmtest::bptest(uno) #v heteroskedastic 

dos <- lm(SalePrice~OverallQual)
summary(dos) #rsquared=0.645 ; p-value: < 0.00000000000000022
hist(dos$residuals) #normal - small right skew with outlier
lmtest::bptest(dos) #v hetero

tres <- lm(SalePrice~OverallCond)
summary(tres) #rsquared=0.01369 ; p-value: 0.00003034
hist(tres$residuals) #right skew
lmtest::bptest(tres) #not as hetero but still hetero

tres1 <- lm(log(SalePrice)~OverallCond)
summary(tres1) #rsquared=0.01369 ; p-value: 0.00003034
hist(tres1$residuals) #normal
lmtest::bptest(tres1) #v hetero

cuatro <- lm(SalePrice~YearBuilt)
summary(cuatro) #rsquared=0.2867 ; p-value: < 0.00000000000000022
hist(cuatro$residuals) #v skewed right
lmtest::bptest(cuatro) #not as hetero but still hetero

cinco <- lm(SalePrice~BsmtFinSF1)
summary(cinco) #rsquared=0.161 ; p-value: < 0.00000000000000022
hist(cinco$residuals) #v normal
lmtest::bptest(cinco) #p-value = 0.0000000000000002483

seis <- lm(SalePrice~BsmtFinSF2)
summary(seis) #R-squared: -0.0004284 ; p-value: 0.484
hist(seis$residuals) #v skewed

seis1 <- lm(log(SalePrice)~BsmtFinSF2)
summary(seis1) #rsquared: 7.728e-05 ; p-value: 0.7617
hist(seis$residuals) 

siete <- lm(SalePrice~BsmtUnfSF)
summary(siete) #rsquared: 0.04608 ; p-value: 0.00000000000004099
hist(siete$residuals) #she a bit right skewed
lmtest::bptest(siete) #v homo

siete1 <- lm(log(SalePrice)~BsmtUnfSF)
summary(siete1) 
hist(siete1$residuals) #v normal
lmtest::bptest(siete1) #homo

ocho <- lm(SalePrice~X1stFlrSF)
summary(ocho) #rsquared=0.3842 ; p-value: < 0.00000000000000022
hist(ocho$residuals) #v normal
lmtest::bptest(ocho) #v heteroskedastic

ocho1 <- lm(SalePrice~log(X1stFlrSF))
summary(ocho1) #rsquared=0.365 ; p-value: < 0.00000000000000022
hist(ocho1$residuals) #v normal - slight right skew
lmtest::bptest(ocho1) #v hetero

ocho2 <- lm(log(SalePrice)~log(X1stFlrSF))
summary(ocho2) #rsquared=0.3965 ; p-value: < 0.00000000000000022
hist(ocho2$residuals) #v normal
lmtest::bptest(ocho2) #hetero but not that hetero

ocho3 <- lm(log(SalePrice)~X1stFlrSF)
summary(ocho3) #rsquared=0.3828 ; p-value: < 0.00000000000000022
hist(ocho3$residuals) #pretty normal
lmtest::bptest(ocho3) #v hetero




#categories that are purely significant
purelysig <- lm(SalePrice~LotArea+OverallQual+OverallCond+YearBuilt+BsmtFinSF1+
                  BsmtFinSF2+BsmtUnfSF+X1stFlrSF+X2ndFlrSF+BedroomAbvGr+Fireplaces+
                  +RoofMatl+KitchenQual, data=data)
summary(purelysig) #r-squared of .8514 and p-value of <2.2e-16
lmtest::bptest(purelysig) #extremely heteroskedastic (p-value of <2.2e-16)
car::vif(purelysig) #no multicollinearity whatsoever - all VIFs are less than 3

test2 <- lm(log(SalePrice)~LotArea+OverallQual+BsmtFinSF1+KitchenQual, data=data)
summary(test2)
lmtest::bptest(test2)

test3 <- lm(SalePrice~LotArea+OverallQual)

#logy~logx individually
#continuous variables (not categorical)
#when there is skewness in the histogram


#use cor() function



numerouno <- lm(SalePrice~LotArea+OverallQual,data=data)
summary(numerouno)

numerodos <- lm(SalePrice~Exterior)



#keep Exterior1st
um <- lm(SalePrice~Exterior1st)
summary(um) #r=.1576 - v significant
hist(um$residuals) #v normal
lmtest::bptest(um) #homo

dois <- lm(log(SalePrice)~logExterior2nd)
summary(dois) #r=.1618 - v significant ^logy rsquare went up to .19
hist(dois$residuals) #a lil right skew ^logy normal now
lmtest::bptest(dois) #hetero ^still hetero

#very significant (50% variance explained) BUT v hetero
tres3 <- lm(SalePrice~ExterQual)
summary(tres3) #r=.512 - v significant
hist(tres3$residuals) #normal - lil right skew
lmtest::bptest(tres3) #v hetero

quatro <- lm(SalePrice~BsmtQual)
summary(quatro) #r=.4876 - v significant
hist(quatro$residuals) #normal
lmtest::bptest(quatro) #v hetero

cinco5 <- lm(SalePrice~BsmtExposure)
summary(cinco5) #r=.1454 - v significant
hist(cinco5$residuals) #lil right skew
lmtest::bptest(cinco5) #v hetero

seis6 <- lm(SalePrice~KitchenQual)
summary(seis6) #r=0.4773 - v significant
hist(seis6$residuals) #normal w an outlier on the right
lmtest::bptest(seis6) #v hetero



voumemachucar <- lm(SalePrice~LotArea+OverallQual+YearBuilt+BsmtUnfSF+
                      X2ndFlrSF+BedroomAbvGr+ExterQual+BsmtQual+KitchenQual, data=data)
summary(voumemachucar) #rsquared of .9066 and p-value of <2.2e-16
lmtest::bptest(voumemachucar) #extremely heteroskedastic
car::vif(voumemachucar) #error- there are aliased coefficients in the model


voumemachucar <- lm(log(SalePrice)~LotArea+OverallQual+KitchenQual, data=data)
summary(voumemachucar) #rsquared of .9066 and p-value of <2.2e-16
lmtest::bptest(voumemachucar) #extremely heteroskedastic
car::vif(voumemachucar)


x <- ExterQual
#vou tentar um por um
voumemachucar <- lm(log(SalePrice)~LotArea+OverallQual+KitchenQual+x, data=data)
summary(voumemachucar) #rsquared of .9066 and p-value of <2.2e-16
lmtest::bptest(voumemachucar) #extremely heteroskedastic
car::vif(voumemachucar)


#final linear model
tentar <- lm(log(SalePrice)~log(LotArea)+log(OverallQual)+RoofMatl+BsmtUnfSF, data=data)
#why we choose these 4 variables and how it affected the model - EXPLAIN
plot(tentar) #(EXPLAIN ALL FOUR PLOTS; passes the assumption for linearity
hist(tentar$residuals) #small left skew, but overall normal; passes the assumption for normality of errors
summary(tentar) #all variables are significant (p-values of less than 0.05)
#^overall model p-value: < 0.00000000000000022 (highly significant)
#we're explaining 77% of the variance in Sale Price (adjusted r-squared: 0.7747)
car::vif(tentar) #all 4 variables have VIFs less than 2 (no multicollinearity); passes the assumption for multicollinearity
lmtest::bptest(tentar) #p-value=0.03317 (model is homoskedastic); passes the assumption for heteroskedastic








###################################
#Team 14
#Vanessa Guzman, Mengting Ding, Nash Kleisner, Zouzi Qi
rm(list=ls())
#setwd("C:/Users/15713/Documents/machine_learning_1")

data <- read.csv("Case3(1).csv", stringsAsFactors = TRUE)
attach(data)

str(data)
summary(data)
final <- lm(log(SalePrice)~log(LotArea)+log(OverallQual)+RoofMatl, data=data)
final2 <- lm(log(SalePrice)~log(LotArea)+log(OverallQual)+RoofMatl+BsmtUnfSF, data=data)
#why we choose these 4 variables and how it affected the model
#We chose LotArea because log(LotArea) alone explains 18% (R^2=0.18) of the variance in log(SalePrice). 
#We chose OverallQual because log(OverallQual) alone explains 66% (R^2=0.66) of the variance in log(SalePrice).
#We chose BsmtUnfSF because it alone explains 5.5% (R^2=0.055) of the variance in log(SalePrice) and 
  #is very homoskedastic(BP-test P-value is 0.54). The overall model is significant(P-value=4.099e-14).
#We chose RoofMatl because it alone explains 1.3% (R^2=0.013) of the variance in log(SalePrice),
  #and the overall model is significant (p-value=0.001267). RoofMatl helps keep our model homoskedastic and significant. 
#Choosing these 4 variables helped our final model pass the assumptions and reach the required minimum R^2 of 71%. 

#We tried every combination possible for log of y and log of x's (continuous x's only) and found that 
#log(SalePrice), log(LotArea), log(OverallQual) gave us an acceptable model. 

plot(final) #there were no patterns in the scatterplots; passes the assumption for linearity (as well as homoskedasticity)
  #(normal Q-Q plot helps pass the assumption for normality of errors)
####????warning message????  #residual v. leverage: there were no observations outside of cook's distance
hist(final$residuals) #normal bell curve, no outliers; passes the assumption for normality of errors
summary(final) #overall model p-value: < 2.2e-16 (highly significant)
#we're explaining 73.3% of the variance in Sale Price (adjusted r-squared: 0.733)
car::vif(final) #all 4 variables have VIFs less than 2 (no multicollinearity); passes the assumption for multicollinearity
lmtest::bptest(final) #p-value=0.1075 (this is homoskedastic); passes the assumption for heteroskedasticity
#our model passes all four assumptions, indicating that it is a good fit of the data

#final linear regression equation
final$coefficients
#Sale Price = 6.56386405 + 0.22286217*log(LotArea) + 1.28729614*log(OverallQual) + 
#  1.15118902*RoofMatlCompShg + 0.97152094*RoofMatlMembran + 1.12797884*RoofMatlRoll +
#  1.04503977*RoofMatlTar&Grv + 1.13892334*RoofMatlWdShake + 1.27104251*RoofMatlWdShngl
#  -0.00002357*BsmtUnfSF

#PROVIDE THE FINAL CORRELATION
#calculation of cor(final):
Sig <- sigma(final) ; Sig #0.2111259
b0 <- final$coefficients[1] ; b0 #6.563864
b1 <- final$coefficients[2] ; b1 #0.2228622
b2 <- final$coefficients[3] ; b2 #1.287296
b3 <- final$coefficients[10]; b3 #-2.357314e-05
yhat <- exp(b0 + b1*log(LotArea) + b2*log(OverallQual) + b3*BsmtUnfSF + Sig^2/2)
loglogcor <- cor(yhat, SalePrice)^2 ; loglogcor #0.7203192
#the final correlation is 0.7203192, which indicates a strong relationship between our x's and y

#SUMMARY
#Our final linear model passed all four assumptions (as mentioned above), 
#explains 73.3% of the variance in Sale Price (adjusted r-squared=0.733), 
#and is highly significant (p-value=< 2.2e-16). This indicates that our model
#is acceptable in explaining the data.

#LotArea: Total square footage is often one of the most important aspects to 
#properties' sales price, so it makes sense that this predictor (LotArea)
#alone explains 18% of the variance in our y-variable (SalePrice). 
#OverallQual: This predictor rates the overall material and finish of a 
#house on a scale of 1-10. This is likely an important factor in determining 
#Sale Price because better quality material and finishes cost more money.
#RoofMatl: Having a roof made of better quality material is important to the 
#Sale price of the house, because roofs of better quality don't have to be replaced
#as often. This will show in the housing price because the cost of the better
#quality materials is more expensive than the cheaper materials that will be replaced
#more often. 
#BsmtUnfSF (Unfinished Square Feet of Basement Area): People most likely want
#an unfinished basement which will have a lower housing price than the similar 
#houses with a finished basement. 

#For a 1% change in LotArea, there will be a 22% increase in SalePrice.
#For a 1% change in OverallQual, there will be a 128% increase in SalePrice.
#For categorical variable RoofMatl:
  #if it is CompShg, SalePrice will be increased by 115%;
  #if it is Membran, SalesPrice will be increased by 97%;
  #if it is RoofMatlRoll, SalePrice will be increased by 112%;
  #if it is RoofMatlTar&Grv, SalePrice will be increased by 104%;
  #if it is RoofMatlWdShake, SalePrice will be increased by 113%;
  #if it is RoofMatlWdShngl, SalePrice will be increased by 127%.
#For a 1 unit change in variable BsmtUnfSF, there will be a $0.00235 decrease in SalePrice. 
####ask prof to make sure that this is a 1 unit change (even with log(y))

lm3 <- lm(log(SalePrice) ~ log(GrLivArea) +OverallQual)
summary(lm3)
