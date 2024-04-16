from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
arcs= {'12':400,"13":950,"14":800,
    "25":1800,"26":900,
    "35":1100,"36":600,
    "46":600,"47":1200,
    "65":900,"67":1000,"58":400,"68":1300,"78":600}
nodes = [1,2,3,4,5,6,7,8]
prob = LpProblem("Truck",LpMinimize)

x12 = LpVariable("x12",0,1,cat="Binary")
x13 = LpVariable("x13",0,1,cat="Binary")
x14 = LpVariable("x14",0,1,cat="Binary")

x25 = LpVariable("x25",0,1,cat="Binary")
x26 = LpVariable("x26",0,1,cat="Binary")

x35 = LpVariable("x35",0,1,cat="Binary")
x36 = LpVariable("x36",0,1,cat="Binary")

x46 = LpVariable("x46",0,1,cat="Binary")
x47 = LpVariable("x47",0,1,cat="Binary")

x65 = LpVariable("x65",0,1,cat="Binary")
x67 = LpVariable("x67",0,1,cat="Binary")
x68 = LpVariable("x68",0,1,cat="Binary")

x58 = LpVariable("x58",0,1,cat="Binary")
x78 = LpVariable("x78",0,1,cat="Binary")

X= {'12':x12,"13":x13,"14":x14,
    "25":x25,"26":x26,
    "35":x35,"36":x36,
    "46":x46,"47":x47,
    "65":x65,"67":x67,"58":x58,"68":x68,"78":x78}
prob += x12+x13+x14 == 1
prob += x58+x68+x78 == 1
#prob += x25+x26-x65-x67== 0
#prob += x35+x36-x65-x67== 0
#prob += x46+x47-x65-x67 == 0
prob += x12-x25-x26 ==0
prob += x13-x35-x36 ==0
prob += x14-x46-x47 ==0
prob += x25+x35+x65-x58 ==0
prob += x26+x36+x46-x65-x67-x68 ==0
prob += x47+x67-x78 ==0

prob += sum(arcs[key]*X[key] for key in arcs.keys())

status = prob.solve()
print(f"Problem")
print(f"status={LpStatus[status]}")

# print the results
for variable in prob.variables():
    if variable.varValue >0:
        print(f"{variable.name} = {variable.varValue}")
    
print(f"Objective = {value(prob.objective)}")
print(f"")