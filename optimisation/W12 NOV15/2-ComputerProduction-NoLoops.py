import pandas as pd
from gurobipy import *
m=Model('Computer Production')

#Decision Variables
r=[m.addVar(vtype=GRB.CONTINUOUS, name="regular capacity during week "+str(i+1), lb=0.0, ub=160.0) for i in range(6)]
o=[m.addVar(vtype=GRB.CONTINUOUS, name="overtime capacity during week "+str(i+1), lb=0.0, ub=50.0) for i in range(6)]
inv=[m.addVar(vtype=GRB.CONTINUOUS, name="inventory during week "+str(i+1), lb=0.0) for i in range(5)]
m.update()

#Constraints
m.addConstr(r[0]+o[0]-inv[0], GRB.EQUAL, 105)
m.addConstr(r[1]+o[1]+inv[0]-inv[1], GRB.EQUAL, 170)
m.addConstr(r[2]+o[2]+inv[1]-inv[2], GRB.EQUAL, 230)
m.addConstr(r[3]+o[3]+inv[2]-inv[3], GRB.EQUAL, 180)
m.addConstr(r[4]+o[4]+inv[3]-inv[4], GRB.EQUAL, 150)
m.addConstr(r[5]+o[5]+inv[4], GRB.EQUAL, 250)
m.update()

#Objective
m.setObjective(190*sum(r)+260*sum(o)+10*sum(inv), GRB.MINIMIZE)
m.optimize()

for var in m.getVars():
    print("The optimal value for %s is %s" %  (var.varName, round(var.x,2)))
print("Having these values will minimize the total cost at $%s0" % m.objVal)