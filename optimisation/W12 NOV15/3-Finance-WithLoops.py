from gurobipy import Model, GRB, quicksum

model = Model("Jones Portfolio Analysis")

# Problem Setup:

all_portfolio = 100000
exp = [.04, .052, .071, .1, .082, .065, .2, .125]

# Decision Variables
investments = []
investment_names = ["Savings Account", "Certificate of Deposit", "Atlantic Lighting", "Arkansas REIT", "Bedrock Investment Annuity", "Nocal Mining Bond", "Minicomp Systems", "Antony Hotels"]
for i in range(8):
    investments.append(model.addVar(vtype=GRB.CONTINUOUS, lb=0.0, name=investment_names[i]))

model.update()

# Constraints
model.addConstr(
    investments[0]*exp[0] + investments[1]*exp[1] + investments[2]*exp[2] + investments[3]*exp[3] + investments[4]*exp[4] + investments[5]*exp[5] + investments[6]*exp[6] + investments[7]*exp[7] >= .075*all_portfolio, "Expected Return"
)

model.addConstr(
     investments[0] + investments[1] + investments[2] + investments[3] + investments[4] + investments[5] + investments[6] + investments[7] == all_portfolio, "Total"
)

model.addConstr(
    investments[0] + investments[1] + investments[4] + investments [6] >= 50000, "A-rating"
)

model.addConstr(
    investments[0] + investments[2] + investments[3] + investments[6] + investments[7] >= 40000, "Liquidity"
)

model.addConstr(
    investments[0] + investments[1] <= 30000, "Savings/CD"    
)
model.update()


# Set Objective Function
model.setObjective(
    0*investments[0] + 0*investments[1] + 25*investments[2] + 30*investments[3] + 20*investments[4] + 15*investments[5] + 65*investments[6] + 40*investments[7], 
    GRB.MINIMIZE)
model.update()

# Solve the model
model.optimize()

print("Based on the model's output, the following amounts are recommended for optimal portfolio construction:")
for var in model.getVars():

    print("{vn}: ${val}".format(vn=var.VarName, val=round(var.x, 2)))

print("These outputs adhere the constraints given by the portfolio owner.")