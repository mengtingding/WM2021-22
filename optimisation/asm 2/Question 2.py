from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
import pandas as pd

x1 = LpVariable("x1",0,150)
x2 = LpVariable("x2",0,200)
x3 = LpVariable("x3",100,None)

# define problem 
prob = LpProblem("Wood", LpMaximize)

# define constraints
prob += 1.1*x1+1.2*x2+1.3*x3 <= 700 #cutting 
prob += 1.4*x1+1.5*x2+1.6*x3 <= 600 #lamination
prob += 1.7*x1+1.8*x2+1.9*x3 <= 800 #finishing 
prob += x1+x2+x3 >= 400

#objective
prob  += 30*x1+20*x2+10*x3

status = prob.solve()
print(f"")
print(f"status = {LpStatus[status]}")
print(f"Objective={value(prob.objective)}")

#print results
for v in prob.variables():
    print(v.name, "=", v.varValue,"\tReduced Cost =",v.dj )

print(f"")

# Printing Shadow Prices and slacks
o = [{'name':name, 'shadow price':c.pi, 'slack':c.slack}
     for name, c in prob.constraints.items()]
print(pd.DataFrame(o))
print(f"")