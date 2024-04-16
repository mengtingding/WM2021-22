# question 1
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize

prob = LpProblem("Ambulance",LpMaximize)

x13 = LpVariable("X13",0,1,cat="Binary")
x23 = LpVariable("x23",0,1,cat="Binary")

x14 = LpVariable("x14",0,1,cat="Binary")
x24 = LpVariable("X24",0,1,cat="Binary")

x15 = LpVariable("x15",0,1,cat="Binary")
x25 = LpVariable("x25",0,1,cat="Binary")

x16 = LpVariable("x16",0,1,cat="Binary")
x26 = LpVariable("x26",0,1,cat="Binary")

x17 = LpVariable("x17",0,1,cat="Binary")
x27 = LpVariable("x27",0,1,cat="Binary")

x18 = LpVariable("X18",0,1,cat="Binary")
x28 = LpVariable("x28",0,1,cat="Binary")

prob += x13+x14+x15+ x16+ x17+ x18 == 1
prob += x23+x24+x25+ x26+ x27+ x28 == 1
prob += x13+x23 <= 1
prob += x14+x24 <= 1
prob += x15+x25 <= 1
prob += x16+x26 <= 1
prob += x17+x27 <= 1
prob += x18+x28 <= 1

prob += 35*(x13+x23)+20*(x14+x24)+15*(x15+x25)+50*(x16+x26)+35*(x17+x27)+60*(x18+x28)

status = prob.solve()

print(f"Problem")
print(f"status={LpStatus[status]}")

# print the results
for variable in prob.variables():
    if variable.varValue > 0:
        print(f"{variable.name} = {variable.varValue}")
    
print(f"Objective = {value(prob.objective)}")
print(f"")


