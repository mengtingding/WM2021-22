import gurobipy as gp
from gurobipy import GRB
#from gurobipy import *

capacity = [300, 200, 300, 200, 400]
demand = [200, 300, 150, 250]
fixedcostplant = [35000, 45000, 40000, 42000, 40000]
fixedcostwh = [30000, 40000, 30000]
T = 900

plants = range(len(capacity))
customers = range(len(demand))
warehouses = range(len(fixedcostwh))

planttowh = [[800, 1000, 1200],
             [700,500,700],
             [800,600,500],
             [500,600,700],
             [700,600,500]]

whtocust = [[40,80,90,50],
            [70,70,60,80],
            [90,30,50,60]]

m = gp.Model("Hunts")

xvars = m.addVars(plants, warehouses, vtype=GRB.CONTINUOUS, obj = planttowh, name = "x")
yvars = m.addVars(warehouses, customers, vtype=GRB.CONTINUOUS, obj=whtocust, name = "y")
mvars = m.addVars(plants, vtype=GRB.CONTINUOUS, obj = fixedcostplant, lb = 0, ub = 1,  name = "mvar")
wvars = m.addVars(warehouses, vtype=GRB.CONTINUOUS, obj = fixedcostwh, lb = 0, ub = 1,  name = "wvar")

m.modelSense = GRB.MINIMIZE

m.addConstrs((yvars.sum('*', k) == demand[k] for k in customers), "Demand")
m.addConstrs((xvars.sum(i, '*') <= capacity[i]*mvars[i] for i in plants), "Plant Capacity")
m.addConstrs((xvars.sum('*',j) == yvars.sum(j,'*') for j in warehouses), "Warehouse Balance")
m.addConstrs((yvars.sum(j,'*') <= T*wvars[j] for j in warehouses), "Warehouse Capacity")

# Prints model in a form to look at it line by line (to ensure constraints and objective function written correctly)
#m.write('hunt.lp')

# Optimize Model
m.optimize()

#printSolution()
# Objective Function Value
print('\nTotal Costs: %g' % m.objVal)

# Solution (Variable Values):
print('SOLUTION:')
for i in plants:
    if mvars[i].x > 0.99:
        print('Plant %s open' % (i+1))
        for j in warehouses:
            if xvars[i,j].x > 0:
                print('Transport %g units to warehouse %s' % ((xvars[i,j].x, (j+1))))
    else:
        print('Plant %s closed' % (i+1))

for j in warehouses:
    if wvars[j].x > 0.99:
        print('Warehouse %s open' % (j+1))
        for k in customers:
            if yvars[j,k].x > 0:
                print('Transport %g units to customer %s' % ((yvars[j,k].x), (k+1)))
    else:
        print('Warehouse %s closed' % (j+1))
        