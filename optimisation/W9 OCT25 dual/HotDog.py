# Import pulp
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
import pandas as pd

# Define Variables
Beef = LpVariable("Beef", 0, None)
Pork = LpVariable("Pork", 0, None)
Chicken = LpVariable("Chicken", 0, None)
Turkey = LpVariable("Turkey", 0, None)

# Define Problem
prob = LpProblem("Problem", LpMinimize)

# Define Problem Constraints

prob += 640*(Beef) + 1055*(Pork) + 780*(Chicken) + 528*(Turkey) <= 100	#[Calorie constraint]
prob += 32.5*(Beef) + 54*(Pork) + 25.6*(Chicken) + 6.4*(Turkey) <= 6	#[Fat constraint]
prob += 210*(Beef) + 205*(Pork) + 220*(Chicken) + 172*(Turkey) <= 27	#[Cholesterol constraint]
prob += Beef >= 0.25*(Beef + Pork + Chicken + Turkey)			#[Beef must be ≥25% of total weight]
prob += Pork >= 0.25*(Beef + Pork + Chicken + Turkey)			#[Pork must be ≥25% of total weight]
prob += Beef + Pork + Chicken + Turkey >= 2/16				#[Hot Dog must be at least 2 ounces]

#Set Objective Function
prob += 0.76*(Beef) + 0.82*(Pork) + 0.64*(Chicken) + 0.58*(Turkey)

#Solve
status = prob.solve()
print("Hot Dog Problem")
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

########################################################################
########################################################################