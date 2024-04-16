rm(list=ls()) # Clears objects

# The dplyr package helps us with data "wrangling".  
# R "guru" Hadley Wickham created these packages.
# https://en.wikipedia.org/wiki/Hadley_Wickham

# The objective of the packages is "to identify the most 
# important data manipulation verbs and make them easy to use from R."

# When learning a new package you can download cheatsheets from
# the help menu -> cheatsheets

# Let's load the packages.
library(tidyr)
library(dplyr)
library(tidyverse)

# Tidy data is organized as observations (rows) and variables 
# (columns) and all information is contained in the dataset.

# tibble vs data frames (data structures)

# When you print a tibble, it only shows the first ten rows and all the 
# columns that fit on one screen. It also prints an abbreviated description 
# of the column type, and uses font styles and color for highlighting.

# Sub-setting a tibble always returns another tibble. Data frames might
# return vectors when sub-setting.

# Tibbles never changes an input type. They are not automatically coerced
# to characters. 

#EX:

# To read a csv file as a tibble use tidyverse and read_csv
# Column names can include spaces when using tibbles
# When referencing tibbles columns with spaces in the names you need to include
# back ticks `Column Name`
# https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html

avocado <- read_csv("avocado(3).csv")
spec(avocado) # see all the variables classified by its type
# Glimpse allows us to look at a sample of the data

glimpse(avocado)
view(avocado)
# View will lets us look at the entire data set. 
# Not recommended for larger data sets.


# The avocado data is weekly 2018 retail scan data for National retail 
# volume (units) and price. Retail scan data comes directly from retailers
# cash registers based on actual retail sales of Hass avocados. Starting in 2013, 
# the table below reflects an expanded, multi-outlet retail data set. 
# Multi-outlet reporting includes an aggregation of the following channels: 
# grocery, mass, club, drug, dollar and military. The Average Price 
# (of avocados) in the table reflects a per unit (per avocado) cost, 
# even when multiple units (avocados) are sold in bags. The Product 
# Lookup codes (PLUs) in the table are only for Hass avocados. Other varieties 
# of avocados (e.g. greenskins) are not included in this table.

# Most variables are self explanatory except for: 
#                       X4046 -> Small Hass
#                       X4225 -> Large Hass
#                       X4770 -> Extra Large Hass


###############
####DPLYR######
###############

# %>% "piping" passes the object on the left hand side as first argument
# of function on right-hand side. It makes the code more readable.
# The date is formatted as d-m-y. We might want to separate this information
# into separate columns (variables).
avocado
avocado %>% separate("Date", c("Month", "Day", "Year")) -> avocado1
avocado1
avocado1 %>% unite(col = "Date",c(Year,Month,Day),sep='-') ->avocado1
avocado1
avocado1 %>% separate(Date, c("year","Month","Day"),convert = T) -> avocado
avocado
# The date can be combined again with a different format.


# We can subset the data by selecting variables. 
# Arrange the variables in either ascending order 
# or descending order. 
# Pipes can be chained!

avocado %>% select(c(Week, year, Month, Day)) %>% arrange(Month) -> avocado2
head(avocado2)
tail(avocado2)
avocado %>% select(-year) -> avocado
avocado
# Rename variable by using the rename command 
avocado %>% rename(SmallHass = '4046',MediumHass='4225',LargeHass = '4770') -> avocado

#use backticks for names that are numeric, have spaces, etc.

# Collapse all types of Hass into a single variable called hass_avocado
# drop all other variables.
avocado %>% mutate(Hass=SmallHass + MediumHass + LargeHass) -> avocado # use mutate to create a new variable
avocado %>% transmute(Hass=SmallHass + MediumHass + LargeHass)

# Select all variables that have "Bags" in their name. Other options include:
# starts_with, ends_with, contains, etc.
avocado %>% select(contains("Bags")) 

# We can subset the data by selecting rows. You can use logicals such as:
# > greater than, < less than, == equal,!= not equal, etc.
avocado %>% filter(Month == 1) -> avocado_jan

# Create a new variable (column) called id
avocado %>% mutate(id = 1:nrow(avocado)) -> avocado 
# If you need to sample the data you can use the sample functions
avocado %>% sample_frac(0.8,replace=T) -> train

# We can list the distinct observations and distinct weeks in the train data set
train %>% distinct() -> distinct_train
# Perhaps we would like to sample without replacement

# Next we can create a test set with an anti join
test <- avocado %>% anti_join(avocado, train, by='id')

# Put it together again...
avocado3 <- bind_rows(train,test)

# Let's group the data set by avocado type and region. Next we can find
# the average price. Queries in R.
avocado %>% group_by(region) %>% summarise(region_average=mean(AveragePrice),
                                           region_max= max(AveragePrice)) ->  regional_avocado
# Drill down a bit more...
avocado %>% group_by(region,type) %>% summarise(region_average=mean(AveragePrice),
                                                region_max = max(AveragePrice)) -> regional_avocado
# Join, Set, and Binding
rm(list = ls())
(a<-tibble(x1=c("A","B",'C'),x2 = c(1,2,3)))
(b<-tibble(x1=c("A","B",'D'),x3 = c(T,F,T)))

# Create some simple data frames


# Left Join: join matching rows. Starts with a and appends b.
c <- left_join(a,b,by='x1')
# Right Join: join matching rows. Starts with b and appends a.
d <- right_join(a,b,by="x1")
# Inner Join: retain only rows in both sets
e <- inner_join(a,b,by="x1")
# Full Join: retain all values, all rows
f <- full_join(a,b,by="x1")
# Set Operations

# The intersection of two data frames

# The union of two data frames

# The set difference of two data frames



