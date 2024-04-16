from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize

## Qestion 2
y1 = LpVariable("y1",0,1,cat="Binary")
y2 = LpVariable("y2",0,1,cat="Binary")
y3 = LpVariable("y3",0,1,cat="Binary")
y4 = LpVariable("y4",0,1,cat="Binary")
b = LpVariable("b",0,1,cat="Binary")
x11 = LpVariable("x_11",0,cat="Integer")
x12 = LpVariable("x_12",0,cat="Integer")
x13 = LpVariable("x_13",0,cat="Integer")
x14 = LpVariable("x_14",0,cat="Integer")
x21 = LpVariable("x_21",0,cat="Integer")
x22 = LpVariable("x_22",0,cat="Integer")
x23 = LpVariable("x_23",0,cat="Integer")
x24 = LpVariable("x_24",0,cat="Integer")
x31 = LpVariable("x_31",0,cat="Integer")
x32 = LpVariable("x_32",0,cat="Integer")
x33 = LpVariable("x_33",0,cat="Integer")
x34 = LpVariable("x_34",0,cat="Integer")
x41 = LpVariable("x_41",0,cat="Integer")
x42 = LpVariable("x_42",0,cat="Integer")
x43 = LpVariable("x_43",0,cat="Integer")
x44 = LpVariable("x_44",0,cat="Integer")

prob = LpProblem("air conditioner",LpMinimize)

prob += x11+x21+x31+x41 == 100000
prob += x12+x22+x32+x42 == 150000
prob += x13+x23+x33+x43 == 110000
prob += x14+x24+x34+x44 == 90000
prob += x13 >= 50000*b
prob += x23 >= 50000*(1-b)
prob += x11+x12+x13+x14 <= 150000*y1
prob += x21+x22+x23+x24 <= 150000*y2
prob += x31+x32+x33+x34 <= 150000*y3
prob += x41+x42+x43+x44 <= 150000*y4

prob +=6000000*y1+206*x11+225*x12+230*x13+290*x14+5500000*y2+225*x21+206*x22+221*x23+270*x24+5800000*y3+230*x31+221*x32+208*x33+262*x34+6200000*y4+290*x41+270*x42+262*x43+215*x44

status = prob.solve()
print(f"Problem")
print(f"status={LpStatus[status]}")

# print the results
for variable in prob.variables():
    print(f"{variable.name} = {variable.varValue}")
    
print(f"Objective = {value(prob.objective)}")
print(f"")