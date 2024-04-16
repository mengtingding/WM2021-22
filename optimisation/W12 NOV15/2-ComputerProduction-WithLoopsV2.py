from gurobipy import *
m = Model("Aggregate")

regvars = []
for i in range(6):
    regvars.append(m.addVar(vtype=GRB.CONTINUOUS, name = "r"+str(i), lb = 0.0, ub = 160.0))
overvars = []
for j in range(6):
    overvars.append(m.addVar(vtype=GRB.CONTINUOUS, name = "r"+str(i), lb = 0.0, ub = 50.0))                
invvars = []
for k in range(5):
    invvars.append(m.addVar(vtype=GRB.CONTINUOUS, name = "r"+str(i), lb = 0.0))                
    
m.update()

demand = [105.0,170.0,230.0,180.0,150.0,250.0]
m.addConstr(regvars[0]+overvars[0]-invvars[0], GRB.EQUAL, demand[0], "Week 1")
for i in range(1,5):
    m.addConstr(regvars[i]+overvars[i]+invvars[i-1]-invvars[i], GRB.EQUAL, demand[i], "Week " + str(i+1))
m.addConstr(regvars[5]+overvars[5]+invvars[4], GRB.EQUAL, demand[5], "Week 6")
    
m.update() 

obj_func = [190.0,260.0,10.0]
m.setObjective(obj_func[0]*sum(regvars)+obj_func[1]*sum(overvars)+obj_func[2]*sum(invvars),GRB.MINIMIZE)
m.update()

m.optimize()

for i in range(len(regvars)-1):
    print("Ideal production volume in units for Week %s is %s regular production and %s overtime production with a leftover inventory of %s" % (i+1, regvars[i].x, overvars[i].x, invvars[i].x))
print("Ideal production volume in units for Week 6 is %s regular production and %s overtime production with no leftover inventory." % (regvars[5].x, overvars[5].x))