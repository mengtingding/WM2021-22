# -*- coding: utf-8 -*-
"""
Created on Wed Jun 21 11:02:01 2017

@author: jrbrad
"""

import requests
from bs4 import BeautifulSoup as bsoup
    
my_wm_username = 'mding'
search_url = 'http://publicinterestlegal.org/county-list/'
response = requests.get(search_url, headers={
            "User-Agent": "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"}).content
            
# Put your program here
parsed_html = bsoup(response,"lxml")
table = parsed_html.find_all('tr')

my_result_list = []
for row in table:
    new_row = []
    for j in row.find_all("td"):
        new_row.append(j.text)
    my_result_list.append(new_row)
    
print(my_wm_username)
print(len(my_result_list))
print(my_result_list)
