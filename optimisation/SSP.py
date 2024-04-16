from gurobipy import *
import pandas as pd
import numpy as np

Nodes = ['s','a','b','c','t']

Arcs = {('s','a'):5,
        ('s','b'):8,
        ('a','c'):2,
        ('b','a'):-10,
        ('c','b'):3,
        ('b','t'):4,
        ('c','t'):3}

print(Arcs)
model=Model('dual')

X = {}
for key in Arcs.keys():
    index = 'x_'+key[0]+','+key[1]
    X[key] = model.addVar(vtype=GRB.BINARY,name=index)
    
obj = LinExpr(0)
for key in Arcs.keys():
    obj.addTerms(Arcs[key],X[key])
    
model.setObjective(obj,GRB.MINIMIZE)

lhs_1 = LinExpr(0)
lhs_2 = LinExpr(0)
for key in Arcs.keys():
    if (key[0]=='s'):
        lhs_1.addTerms(1,X[key])
    elif (key[1]=='t'):
        lhs_2.addTerms(1,X[key])

model.addConstr(lhs_1==1,name='start flow')
model.addConstr(lhs_1==1,name='end flow')

for node in Nodes:
    lhs = LinExpr(0)
    if(node!='s' and node!='t'):
        for key in Arcs.keys():
            if(key[1]==node):
                lhs.addTerms(1,X[key])
            elif(key[0]==node):
                lhs.addTerms(-1,X[key])
    model.addConstr(lhs==0,name="flow conservation")
    
model.write('model_spp.lp')
model.optimize()

print(model.ObjVal)
for var in model.getVars():
    if(var.x>0):
        print(var.varName,var.x)



