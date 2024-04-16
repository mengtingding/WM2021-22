from gurobipy import Model, GRB, quicksum

# Declare Model
model = Model("Computer Production")

# Problem Constants
production_capacity = {
    "regular":160,
    "overtime":50
}

assembly_cost = {
    "regular":190,
    "overtime":260
}

inventory_holding = 10

weekly_demand = [105, 170, 230, 180, 150, 250]

# Decision Variables:
ovtProd = []
regProd = []
invKept = []
for i in range(len(weekly_demand)):

    regProd.append(model.addVar(vtype=GRB.INTEGER, lb=0.0, name="regProd_week_{c}".format(c=str(i+1))))

for i in range(len(weekly_demand)):

    ovtProd.append(model.addVar(vtype=GRB.INTEGER, lb=0.0, name="ovtProd_week_{c}".format(c=str(i+1))))

for i in range(len(weekly_demand)-1):
    
    invKept.append(model.addVar(vtype=GRB.INTEGER, lb=0.0, name="invKept_week_{c}".format(c=str(i+1))))

model.update()

# Constraints:
for i in range(len(regProd)):

    model.addConstr(regProd[i] <= production_capacity['regular'], "Regular Production Capacity Constraint {n}".format(n=+1))
    model.addConstr(ovtProd[i] <= production_capacity['overtime'], "Overtime Production Capacity Constraint {n}".format(n=i+1))


model.addConstr((regProd[0] + ovtProd[0] - invKept[0]), GRB.GREATER_EQUAL, 105, 'Week 1 Demand') # week 1 demand
model.addConstr((regProd[1] + ovtProd[1] + invKept[0] - invKept[1]), GRB.GREATER_EQUAL, 170, 'Week 2 Demand') # week 2 demand
model.addConstr((regProd[2] + ovtProd[2] + invKept[1] - invKept[2]), GRB.GREATER_EQUAL, 230, 'Week 3 Demand') # week 3 demand
model.addConstr((regProd[3] + ovtProd[3] + invKept[2] - invKept[3]), GRB.GREATER_EQUAL, 180, 'Week 4 Demand') # week 4 demand
model.addConstr((regProd[3] + ovtProd[3] + invKept[2] - invKept[3]), GRB.GREATER_EQUAL, 180, 'Week 4 Demand') # week 4 demand
model.addConstr((regProd[4] + ovtProd[4] + invKept[3] - invKept[4]), GRB.GREATER_EQUAL, 150, 'Week 5 Demand') # week 5 demand
model.addConstr((regProd[5] + ovtProd[5] + invKept[4]), GRB.GREATER_EQUAL, 250, 'Week 6 Demand') # week 6 demand

model.update()

# Set the objective function:

model.setObjective(
    (assembly_cost['regular']*quicksum(regProd)) + (assembly_cost['overtime']*quicksum(ovtProd) + (inventory_holding*quicksum(invKept))), GRB.MINIMIZE
)

model.update()

model.optimize()

class blorp: # Adding this so that the print statement works. Needed an object that had a method named x.
    def __init__(self, x):
        self.x = x

print("Based on the model output, the following production schedule is recommended to meet demand: ")
print("Week", "|", "Regular Production", "|", "Overtime Production", "|","Inventory")
print("---------------------------------------------------------------")
reg = "Regular Production"
ovt = "Overtime Production"
inv = "Inventory"
w = 1
invKept.append(blorp(0.0))
for x, y, z in zip(regProd, ovtProd, invKept):

    week = str(' ')*(len(str("Week"))-len(str(abs(w))))
    xval = str(' ')*(len(reg)-len(str(abs(x.x))))
    yval = str(" ")*(len(ovt)-len(str(abs(y.x))))
    zval = str(" ")*(len(inv)-len(str(abs(z.x))))
    print("{f}".format(f=w)+week, "|", "{xv}".format(xv=abs(x.x))+xval, "|", "{yv}".format(yv=abs(y.x))+yval, "|", "{zv}".format(zv=abs(z.x))+zval)
    w += 1