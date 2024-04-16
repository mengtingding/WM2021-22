from gurobipy import Model, GRB, quicksum

model = Model("fire station")

fire = [20,30,40,25]

w = []; e=[]; n=[]; s=[]
x = [10,60,40,80]; y=[20,20,30,60]

X = model.addVar(vtype=GRB.CONTINUOUS, name="x")
Y = model.addVar(vtype=GRB.CONTINUOUS, name="y")
for i in range(4):
    w.append(model.addVar(vtype=GRB.CONTINUOUS, name ='w_%s'%(i+1)))
    e.append(model.addVar(vtype=GRB.CONTINUOUS, name ='e_%s'%(i+1)))
    n.append(model.addVar(vtype=GRB.CONTINUOUS, name ='n_%s'%(i+1)))
    s.append(model.addVar(vtype=GRB.CONTINUOUS, name ='s_%s'%(i+1)))
    
model.update()

for i in range(len(x)):
    model.addConstr(X-x[i]==w[i]-e[i])
    model.addConstr(Y-y[i]==n[i]-s[i])
    
model.update()

model.setObjective(quicksum(fire[i]*((w[i]+e[i])+(n[i]+s[i])) for i in range(4)),GRB.MINIMIZE)

model.optimize()

for var in model.getVars():

    print("{vn}: {val}".format(vn=var.VarName, val=round(var.x, 2)))
