x <- 5
y = 10
z <- x^2 + y

rm(z)
ls()
#CashOnHand #Pascal
#cashOnHand #Camel
#cash.on.hand #dot
#cash_on_hand #snake

#vectors
Name <- c('Joe','Monica',"Evelyn",'Ethan','Bob')
Name

Number <- c("1",'2','3')
Number <- as.numeric(Number)
sum(Number)

mood <- c("S","S","H","H","S")
mood <- factor(mood, levels = c("S","H"),labels = c("Sad","Happy"))
Loyal <- sample(c(T,F),5,T)
class(Loyal)

mood[3]
Name[1:3]
Name[c(1,4,5)]
Name[-5]

Name[c(T,T,F,T,F)]

library(tidyverse)
library(tidyr)
xx <- tibble(2,'g',T)
