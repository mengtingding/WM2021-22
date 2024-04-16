library(tidyverse)
rm(list=ls())

Avocado <- read_csv("avocado.csv")
class(Avocado)
Avocado <- rename(Avocado, Week = ...1)

library(lubridate)
Avocado$Date <- as.Date(parse_date_time(Avocado$Date,"mdy"))
RegionalAvocado <- Avocado[Avocado$region %in% c( "West", "Southeast", "SouthCentral", 
                                                  "Northeast", "Midsouth", 
                                                  "Plains", "GreatLakes" ),]


RegionalAvocado <- RegionalAvocado %>% group_by(region,type) %>% arrange(RegionalAvocado$Date, .by_group = TRUE)

RegionalAvocado <- RegionalAvocado %>% group_by(region,type) %>% arrange(RegionalAvocado$Date, .by_group = TRUE) %>% mutate(LagAveragePrice = lag(AveragePrice))

RegionalAvocado <- RegionalAvocado %>% group_by(region,type) %>% arrange(RegionalAvocado$Date, .by_group = TRUE) %>% mutate(Pchange = AveragePrice-LagAveragePrice)

AvocadoPchange <- RegionalAvocado %>% mutate(Direction = if_else(Pchange>0,"Up","Down"))
#AvocadoPchange <- cbind(RegionalAvocado,Direction)
#AvocadoPchange <- rename(AvocadoPchange, Direction = ...17)

AvocadoPchange <- na.omit(AvocadoPchange)

AvocadoMean <- AvocadoPchange %>% group_by(region,type) %>% summarise_at(vars(Pchange),list(MeanPchange=mean))

StdevPchange <- AvocadoPchange %>% group_by(region,type) %>% summarize_at(vars(Pchange),funs(AvocadoStdev=sd)) 

SummaryTable <- merge(AvocadoMean,StdevPchange,by=c("region","type"))


AvocadoTop3 <- AvocadoPchange %>% select("Total Volume","type","region") 
AvocadoTop3 <- AvocadoTop3 %>% arrange(desc(AvocadoTop3$`Total Volume`)) %>% group_by(region,type) %>% slice(1:3)




