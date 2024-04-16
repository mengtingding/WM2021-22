#import pulp
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
import pandas as pd
# Define variables
x1 = LpVariable("x1")
x2 = LpVariable("x2")
x3 = LpVariable("x3")
x4 = LpVariable("x4")
x5 = LpVariable("x5")
x6 = LpVariable("x6") #no lower or upper bound

x7p = LpVariable("x7 positive",0,None)
x7n = LpVariable("x7 negative",0,None)

x8p = LpVariable("x8 positive",0,None)
x8n = LpVariable("x8 negative",0,None)

x9p = LpVariable("x9 positive",0,None)
x9n = LpVariable("x9 negative",0,None)

x10p = LpVariable("x10 positive",0,None)
x10n = LpVariable("x10 negative",0,None)

x11p = LpVariable("x11 positive",0,None)
x11n = LpVariable("x11 negative",0,None)

x12p = LpVariable("x12 positive",0,None)
x12n = LpVariable("x12 negative",0,None)

x13p = LpVariable("x13 positive",0,None)
x13n = LpVariable("x13 negative",0,None)

#define problem
prob = LpProblem("minimum of sum absolute of error",LpMinimize)

#Define problem constraints
prob += 4*x1+x2-x3+2*x4+3*x5+6*x6+x7p-x7n==100
prob += 3*x1 + 2*x2 + x3 + 4*x5 + x6 + x8p - x8n == 80 
prob += x1 + x2 + x3 + x4 + x5 + x6 + x9p - x9n == 60
prob += 2*x1 + 3*x2 + 5*x3 - 2*x4 + 4*x6 + x10p - x10n == 120
prob += x2 + x3 + 3*x4 + x5 + 2*x6 + x11p - x11n == 40
prob += 3*x1 + 5*x2 + 2*x3 + x4 - 2*x5 + x6 + x12p - x12n == 90
prob += 3*x1 - 5*x2 - 7*x3 + x4 + 9*x5 +x6 + x13p - x13n == 30

#Set objective
prob += x7p+x7n+ x8p+x8n + x9p+x9n + x10p+x10n + x11p+x11n+ x12p+x12n + x13p+x13n

#Solve
status = prob.solve()
print("min sum abs error")
print(f"")
print(f"status = {LpStatus[status]}")
print(f"Objective={value(prob.objective)}")

#print results
for v in prob.variables():
    print(v.name, "=", v.varValue)

o = [{'name':name, 'shadow price':c.pi, 'slack':c.slack}
     for name, c in prob.constraints.items()]
print(pd.DataFrame(o))
print(f"")