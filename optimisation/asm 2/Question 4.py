#import pulp
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
import pandas as pd
# Define variables
w1 = LpVariable("w1", 0)
w2 = LpVariable("w2", 0)
w3 = LpVariable("w3", 0)
w4 = LpVariable("w4", 0)
w5 = LpVariable("w5", 0)
w6 = LpVariable("w6", 0) 

x1 = LpVariable("x1",0)
x2 = LpVariable("x2",0)
x3 = LpVariable("x3",0)
x4 = LpVariable("x4",0)

y1 = LpVariable("y1",0)
y2 = LpVariable("y2",0)

prob = LpProblem("portfolio",LpMaximize)

prob += w1 + x1 + y1 == 10000
prob += w2 + x2 + y2 == 1.051*w1
prob += w3 + x3 == 1.051*w2
prob += w4 + x4 == 1.051*w3 + 1.162*x1
prob += w5 == 1.051*w4 + 1.162*x2
prob += w6 == 1.051*w5 + 1.162*x3 + 1.285*y1

prob += 1.051*w6 + 1.162*x4 + 1.285*y2

status = prob.solve()
print(f"")
print(f"status = {LpStatus[status]}")
print(f"Objective={value(prob.objective)}")

#print results
for v in prob.variables():
    print(v.name, "=", v.varValue,"\tReduced Cost =",v.dj)

o = [{'name':name, 'shadow price':c.pi, 'slack':c.slack}
     for name, c in prob.constraints.items()]
print(pd.DataFrame(o))
print(f"")