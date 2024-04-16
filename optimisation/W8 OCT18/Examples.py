# Import pulp
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
import pandas as pd

# Problem 1
# Define Variables
S0000 = LpVariable("S0000", 0, None)
S0400 = LpVariable("S0400", 0, None)
S0800 = LpVariable("S0800", 0, None)
S1200 = LpVariable("S1200", 0, None)
S1600 = LpVariable("S1600", 0, None)
S2000 = LpVariable("S2000", 0, None)

# Define Problem
prob = LpProblem("Problem", LpMinimize)

# Define Problem Constraints

prob += S0000 + S2000 >= 90	 #[Ensuring capacity for 0000 to 0400]
prob += S0000 + S0400 >= 215 #[Ensuring capacity for 0400 to 0800]
prob += S0400 + S0800 >= 250 #[Ensuring capacity for 0800 to 1200]
prob += S0800 + S1200 >= 165 #[Ensuring capacity for 1200 to 1600]
prob += S1200 + S1600 >= 300 #[Ensuring capacity for 1600 to 2000]
prob += S1600 + S2000 >= 125 #[Ensuring capacity for 1600 to 2000]
# (Note the above constraints satisfy the maintenance worker requirements for each 4 hour period.)

#Set Objective Function
prob += S0000 + S0400 + S0800 + S1200 + S1600 + S2000

#Solve
status = prob.solve()
print("Problem 1")
print(f"status={LpStatus[status]}")

# Print Results
for variable in prob.variables():
    print(f"{variable.name} = {variable.varValue}")
print(f"")    
print(f"Objective = {value(prob.objective)}")
print(f"")

# Printing Reduced Costs
for v in prob.variables():
    print (v.name, "=", v.varValue, "\tReduced Cost =", v.dj)
print(f"")

# Printing Shadow Prices and slacks
o = [{'name':name, 'shadow price':c.pi, 'slack':c.slack}
     for name, c in prob.constraints.items()]
print(pd.DataFrame(o))
print(f"")

########################################################################
########################################################################


#Problem 2
#Define Variables
A1 = LpVariable("A1", 0, None)
A2 = LpVariable("A2", 0, None)
A3 = LpVariable("A3", 0, None)
A4 = LpVariable("A4", 0, None)
B1 = LpVariable("B1", 0, None)
B2 = LpVariable("B2", 0, None)
B3 = LpVariable("B3", 0, None)
B4 = LpVariable("B4", 0, None)

# Define Problem
prob = LpProblem("Problem", LpMaximize)

#Define Problem Constraints
prob += A1 + A2 + A3 + A4 <= 3500  #[Vineyard A’s Supply Constraint]
prob += B1 + B2 + B3 + B4 <= 3100  #[Vineyard B’s Supply Constraint]
prob += A1 + B1 <= 1800  #[Restaurant 1’s Demand Constraint]
prob += A2 + B2 <= 2300  #[Restaurant 2’s Demand Constraint]
prob += A3 + B3 <= 1250  #[Restaurant 3’s Demand Constraint]
prob += A4 + B4 <= 1750  #[Restaurant 4’s Demand Constraint]

#Set Objective Function
prob += 39*A1 + 36*A2 + 34*A3 + 32*A4 + 32*B1 + 36*B2 + 37*B3 + 29*B4

#Solve
status = prob.solve()
print("Problem 2")
print(f"status={LpStatus[status]}")

# Print Results
for variable in prob.variables():
    print(f"{variable.name} = {variable.varValue}")
print(f"")    
print(f"Objective = {value(prob.objective)}")
print(f"")

# Printing Reduced Costs
for v in prob.variables():
    print (v.name, "=", v.varValue, "\tReduced Cost =", v.dj)
print(f"")

# Printing Shadow Prices
o = [{'name':name, 'shadow price':c.pi, 'slack':c.slack}
     for name, c in prob.constraints.items()]
print(pd.DataFrame(o))
print(f"")