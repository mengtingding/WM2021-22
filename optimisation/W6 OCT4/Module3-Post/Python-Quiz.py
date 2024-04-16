# import pulp
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize

# Problem (Initial)
# define variables
# xij: the number of gallons of gasoline grade i (i=1,2,3) sold to customer j (j=1,2)

x11 = LpVariable("x11", 0, None) # x11>=0
x12 = LpVariable("x12", 0, None) # x12>=0
x21 = LpVariable("x21", 0, None) # x21>=0
x22 = LpVariable("x22", 0, None) # x22>=0
x31 = LpVariable("x31", 0, None) # x31>=0
x32 = LpVariable("x32", 0, None) # x32>=0

# defines the problem
prob = LpProblem("problem", LpMinimize)
# Note, LpMaximize for a maximization problem, 
# and LpMinimize for a minimization problem

# define constraints

# Supply Constraints
prob += x11 + x12 <= 800
prob += x21 + x22 <= 900
prob += x31 + x32 <= 6000

# Demand Constraints
prob += x11 + x21 + x31 >= 1000
prob += x12 + x22 + x32 == 1500

# Blend Constraints (rewritten to put all variables on left-hand side)
prob += -x11 + x21 + 5*x31 >= 0
prob += -3*x12 -x22 + 3*x32 >= 0

# Note, if <= then <=
# If >= then >=
# If = then ==

# define objective function
prob += 2.8*x11 + 2.8*x12 + 2.9*x21 + 2.9*x22 + 3.0*x31 + 3.0*x32

# solve the problem
status = prob.solve()
print(f"Problem")
print(f"status={LpStatus[status]}")

# print the results
for variable in prob.variables():
    print(f"{variable.name} = {variable.varValue}")
    
print(f"Objective = {value(prob.objective)}")
print(f"")

