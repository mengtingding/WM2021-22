# -*- coding: utf-8 -*-
"""
Created on Mon Feb 20 16:34:07 2017

@author: jrbrad
"""

def my_sum(a_list):
    result = 0
    for y in a_list:
        result += y
    return result
    
x = [0,1,2,3,4,5]
print(my_sum(x))

x = [6,7,8,9,10]
print(my_sum(x))