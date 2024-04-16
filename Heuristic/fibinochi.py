# -*- coding: utf-8 -*-
"""
Created on Thu Mar 31 11:56:34 2022

@author: mengt
"""


def fib(number_of_terms):
    counter = 0
    first = 0
    second = 1
    temp = 0
    while counter < number_of_terms:
        #print(first)
        temp = first+second
        first = second
        second = temp
        counter = counter + 1
    return(first)
print(fib(100))

