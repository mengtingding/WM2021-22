from gurobipy import Model, GRB, quicksum
model = Model("Computer purchase")
x = []
y = []
p = [800,600,400]
for i in range(3):
    x.append(model.addVar(vtype=GRB.INTEGER,lb=0,name="Vendor %s"%(i+1)))
    y.append(model.addVar(vtype=GRB.BINARY, name="binary %s"%(i+1)))
    
model.update()

for i in range(3):
    model.addConstr(x[i]>=300*y[i])
for i in range(3):
    model.addConstr(x[i] <= p[i]*y[i])

model.addConstr(sum(x[i] for i in range(3))==1200)

model.update()
# Objective
model.setObjective((250*x[0]+5000)*y[0]+(300*x[1]+4000)*y[1]+(350*x[2]+6000)*y[2],GRB.MINIMIZE)

model.optimize()

for var in model.getVars():

    print("{vn}: {val}".format(vn=var.VarName, val=round(var.x, 2)))
