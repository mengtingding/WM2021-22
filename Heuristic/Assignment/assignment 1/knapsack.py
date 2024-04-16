import pandas as pd
import numpy as np
import time

start = time.time()

items = (
    ("Item 1", 9, 20), ("Item 2", 1, 1), ("Item 3", 5, 11), ("Item 4", 4, 10)
    )
cap = 10
items = (
    ("Item 1", 41, 442), ("Item 2", 50, 525), ("Item 3", 49, 511), ("Item 4", 59, 593), ("Item 5", 55, 546), ("Item 6", 57, 564), ("Item 7", 60, 617), 
    )
cap = 170
#df=pd.DataFrame(list(items), columns=["Name","Size","Value"])

start = time.time()

#mat = np.array([[0 for j in range(cap+1)] for i in range(len(items)+1)]) #created a matrix filled with 0 with dimension of (length(items)+1,cap+1)
#print(mat.shape)

#Bottom up method
start = time.time()
w = []
v = []
for i in range(len(items)):
    w.append(items[i][1])
    v.append(items[i][2])
W = cap
# `T[i][j]` stores the maximum value of knapsack having weight less
# than equal to `j` with only first `i` items considered.
T = np.array([[0 for x in range(W + 1)] for y in range(len(v))])
#knapsack_item = []


# do for i'th item
for i in range(len(v)):
    for j in range(W + 1):
        if i == 0:
            if w[i] > j:
                T[i][j] = T[i][j] #if exceeding the capacity, remains 0
            else:
                T[i][j] = v[i] #while not exceeding the capacity, first row takes the value of first item
        else:
            if w[i] > j:
                T[i][j] = T[i-1][j] 
            else:
                #find the max value
                T[i][j] = max(T[i-1][j],T[i-1][j-w[i]]+v[i])
result = []
m = max(T[-1])

for i in range(len(T)-2,-1,-1):
    if m not in T[i]:
        result.append(i+1)
        m = m-v[i+1]
if m != 0:
    result.append(0)
    m=m-v[0]

weight_total = 0
print("knapsack contains following items:")
for i in range(len(result)-1,-1,-1):
    print(items[result[i]][0])
    weight_total += w[result[i]]
    
print('Knapsack value is', T[len(v)-1][W])
print("knapsack total weight is",weight_total)

end=time.time()
print("total running time in second is:",end-start)
