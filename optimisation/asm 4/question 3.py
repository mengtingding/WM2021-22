# question 3
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize

x11 = LpVariable("x_11",0,1,cat="Binary")
x12 = LpVariable("x_12",0,1,cat="Binary")
x13 = LpVariable("x_13",0,1,cat="Binary")
x14 = LpVariable("x_14",0,1,cat="Binary")
x15 = LpVariable("x_15",0,1,cat="Binary")

x21 = LpVariable("x_21",0,1,cat="Binary")
x22 = LpVariable("x_22",0,1,cat="Binary")
x23 = LpVariable("x_23",0,1,cat="Binary")
x24 = LpVariable("x_24",0,1,cat="Binary")
x25 = LpVariable("x_25",0,1,cat="Binary")

x31 = LpVariable("x_31",0,1,cat="Binary")
x32 = LpVariable("x_32",0,1,cat="Binary")
x33 = LpVariable("x_33",0,1,cat="Binary")
x34 = LpVariable("x_34",0,1,cat="Binary")
x35 = LpVariable("x_35",0,1,cat="Binary")

x41 = LpVariable("x_41",0,1,cat="Binary")
x42 = LpVariable("x_42",0,1,cat="Binary")
x43 = LpVariable("x_43",0,1,cat="Binary")
x44 = LpVariable("x_44",0,1,cat="Binary")
x45 = LpVariable("x_45",0,1,cat="Binary")

x51 = LpVariable("x_51",0,1,cat="Binary")
x52 = LpVariable("x_52",0,1,cat="Binary")
x53 = LpVariable("x_53",0,1,cat="Binary")
x54 = LpVariable("x_54",0,1,cat="Binary")
x55 = LpVariable("x_55",0,1,cat="Binary")

prob = LpProblem("Trip",LpMinimize)
prob+= x11+x12+x13+x14+x15 == 1     #(Baltimore 1)
prob+= x21+x22+x23+x24+x25 == 1		#(Baltimore 2)
prob+= x31+x32+x33+x34+x35 == 1		#(Baltimore 3)
prob+= x41+x42+x43+x44+x45 == 1		#(Baltimore 4)
prob+= x51+x52+x53+x54+x55 == 1		#(Baltimore 5)

prob+= x11+x21+x31+x41+x51 == 1		#(Boston 1)
prob+= x12+x22+x32+x42+x52 == 1		#(Boston 2)
prob+= x13+x23+x33+x43+x53 == 1		#(Boston 3)
prob+= x14+x24+x34+x44+x54 == 1		#(Boston 4)
prob+= x15+x25+x35+x45+x55 == 1		#(Boston 5)

prob += 18.5*x11+20*x12+24*x13+7.5*x14+13*x15+15*x21+16.5*x22+20.5*x23+4*x24+9.5*x25+9*x31+10.5*x32+14.5*x33+20*x34+27.5*x35+5.5*x41+7*x42+11*x43+18.5*x44+24*x45+24*x51+25.5*x52+5.5*x53+13*x54+18.5*x55

status = prob.solve()
print(f"Problem")
print(f"status={LpStatus[status]}")

# print the results
for variable in prob.variables():
    if variable.varValue>0:
        print(f"{variable.name} = {variable.varValue}")
    
print(f"Objective = {value(prob.objective)}")
print(f"")





