# import pulp
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize

# Problem (Initial)
# define variables
#Indexed Set:
#i = (1, 2, 3, 4); time period
#
#Decision Variables:
#Pi = production in period i
#Si = inventory (ending) of period i

P1 = LpVariable("P1", 0, 200) # 0 <= Pi <= 200 for all i
P2 = LpVariable("P2", 0, 200)
P3 = LpVariable("P3", 0, 200)
P4 = LpVariable("P4", 0, 200)
S1 = LpVariable("S1", 0, 60) # 0 <= Si <= 60 for all i
S2 = LpVariable("S2", 0, 60)
S3 = LpVariable("S3", 0, 60)

# defines the problem
prob = LpProblem("problem", LpMinimize)
# Note, LpMaximize for a maximization problem, 
# and LpMinimize for a minimization problem

# define constraints

# Equilibrium Constraints
prob += P1 == S1 + 130
prob += S1 + P2 == S2 + 160
prob += S2 + P3 == S3 + 250
prob += S3 + P4 == 150

# define objective function
prob += 15*P1 + 16*P2 + 17*P3 + 18*P4 + 1.5*S1 + 1.5*S2 + 1.5*S3


# solve the problem
status = prob.solve()
print(f"Problem")
print(f"status={LpStatus[status]}")

# print the results
for variable in prob.variables():
    print(f"{variable.name} = {variable.varValue}")
    
print(f"Objective = {value(prob.objective)}")
print(f"")

