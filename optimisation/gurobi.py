# Module 0
from gurobipy import *

keys = [(i,j) for i in range(5) for j in range(4)]
vals = [11,55,88,22,22,132,66,110,77,88,33,110,22,44,66,110,55,55,44,110]
inp = dict(zip(keys,vals))

m = Model('M0')

d = {}  
for k in inp:
    d[k] = m.addVar(vtype=GRB.CONTINUOUS,name="x"+str(k))
m.update()

m.setObjective(quicksum(d[k]*inp[k] for k in inp))
m.update()

b = [1.0,2.0,1.0,2.0,1.0]
for i in range(5):
    m.addConstr(quicksum(d[(i,j)] for j in range(4)), GRB.LESS_EQUAL, b[i])
for j in range(4):
    m.addConstr(quicksum(d[(i,j)] for i in range(5)), GRB.EQUAL, 1.0)
m.update()

m.optimize()
print ("\n\nOBJECTIVE VALUE is %s  <--- REPORT THIS NUMBER" % m.objVal)