"""recursive knapsack problem dataset 10"""
import pandas as pd
import time
import numpy as np

# Data Set 10:
import random

items = (
    ("Item 1", 382745, 825594), ("Item 2", 799601, 1677009), ("Item 3", 909247, 1676628), 
    ("Item 4", 729069, 1523970), ("Item 5", 467902, 943972), ("Item 6", 44328, 97426), 
    ("Item 7", 34610, 69666), ("Item 8", 698150, 1296457), ("Item 9", 823460, 1679693), 
    ("Item 10", 903959, 1902996), ("Item 11", 853665, 1844992), ("Item 12", 551830, 1049289), 
    ("Item 13", 610856, 1252836), ("Item 14", 670702, 1319836), ("Item 15", 488960, 953277), 
    ("Item 16", 951111, 2067538), ("Item 17", 323046, 675367), ("Item 18", 446298, 853655), 
    ("Item 19", 931161, 1826027), ("Item 20", 31385, 65731), ("Item 21", 496951, 901489), 
    ("Item 22", 264724, 577243), ("Item 23", 224916, 466257), ("Item 24", 169684, 369261),
    )
cap = 6404180

start = time.time()

df=pd.DataFrame(list(items), columns=["Name","Size","Value"])

n = len(items)
Size = df["Size"]
Value = df["Value"]
#print(df)

"""record value and weight"""

start = time.time()


df=pd.DataFrame(list(items), columns=["Name","Size","Value"])
n = len(items)
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
