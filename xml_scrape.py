# -*- coding: utf-8 -*-

import requests
from lxml import objectify

num_periods = 5 
parameter = 'tavg'
state_id = 44
month_num = '08'
year = '2016'

my_wm_username = 'mding'

URL_template = 'https://www.ncdc.noaa.gov/cag/statewide/rankings/%s-%s-%s%s/data.xml'

URL = URL_template % (state_id,parameter,year,month_num)
#https://www.ncdc.noaa.gov/cag/statewide/rankings/44-tavg-201608/data.xml
response = requests.get(URL).content

#put your code here and use it to populate the variables below with the 
#appropriate values from the XML from the web page
root = objectify.fromstring(response)
Value = root["data"][num_periods-1]["value"]
mean = root["data"][num_periods-1]["mean"]
departure = root["data"][num_periods-1]["departure"]
lowRank = root["data"][num_periods-1]["lowRank"]
highRank = root["data"][num_periods-1]["highRank"]

print(my_wm_username)
print(Value)
print(mean)
print(departure)
print(lowRank)
print(highRank)















