from gurobipy import *
m=Model('Schedule')

#Decision Variables
mon=m.addVar(vtype=GRB.INTEGER, name='Monday', lb=0.0)
tues=m.addVar(vtype=GRB.INTEGER, name='Tuesday', lb=0.0)
wed=m.addVar(vtype=GRB.INTEGER, name='Wednesday', lb=0.0)
thurs=m.addVar(vtype=GRB.INTEGER, name='Thursday', lb=0.0)
fri=m.addVar(vtype=GRB.INTEGER, name='Friday', lb=0.0)
sat=m.addVar(vtype=GRB.INTEGER, name='Saturday', lb=0.0)
sun=m.addVar(vtype=GRB.INTEGER, name='Sunday', lb=0.0)
m.update()

#Constraints

m.addConstr(sun+wed+thurs+fri+sat, GRB.GREATER_EQUAL, 8.0)
m.addConstr(sun+mon+thurs+fri+sat, GRB.GREATER_EQUAL, 6.0)
m.addConstr(sun+mon+tues+fri+sat, GRB.GREATER_EQUAL, 5.0)
m.addConstr(sun+mon+tues+wed+sat, GRB.GREATER_EQUAL, 4.0)
m.addConstr(sun+mon+tues+wed+thurs, GRB.GREATER_EQUAL, 6.0)
m.addConstr(mon+tues+wed+thurs+fri, GRB.GREATER_EQUAL, 7.0)
m.addConstr(tues+wed+thurs+fri+sat, GRB.GREATER_EQUAL, 9.0)

m.update()

#Objective Function

m.setObjective(mon+tues+wed+thurs+fri+sat+sun, GRB.MINIMIZE)

m.optimize()

for var in m.getVars():
    print("The number of workers that should start on %s is %s" % (var.varName, round(var.x,2)))
print("Having this number of workers starting on each respective day will minimize the number of workers necessary to %s workers" % (m.objVal))

