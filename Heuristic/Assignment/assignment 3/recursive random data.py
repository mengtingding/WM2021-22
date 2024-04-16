# -*- coding: utf-8 -*-
"""
Created on Sun Apr 10 18:04:27 2022

@author: mengt
"""
import time
import pandas as pd
import random

cap = random.randrange(70, 100)

items = []

for i in range(30):
    itemno = f"Item {i + 1}"
    itemweight = random.randrange(10, 60)
    itemval = random.randrange(1,100)
    item = tuple([itemno, itemweight, itemval])
    items.append(item)
    
items = tuple(items)


start = time.time()

df=pd.DataFrame(list(items), columns=["Name","Size","Value"])
n = len(items)
print(df)
Size = df["Size"]
Value = df["Value"]


def knapsack(size,value,n,cap):
    if (n ==0 or cap ==0):
        result=0
    elif size[n-1] > cap:
        result = knapsack(size,value,n-1,cap)
    else:
        result = max(value[n-1]+knapsack(size,value,n-1,cap-size[n-1]),knapsack(size,value,n-1,cap))
        
    return result
print(knapsack(Size,Value,n,cap))
end = time.time()
print(end-start)