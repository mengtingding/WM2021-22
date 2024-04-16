from gurobipy import Model, GRB, quicksum

model = Model("sales representatives")
pop = [43,29,42,21,56,18,71]

x = [] # let x_i be the binary variable indicating whether the region is assigned or not
y = [] # Let y_ij be the binary variable indicating a sales representative is assigned to adjacent sites i and j
adj_region = ["AB","AC", "BC", "BD","BE","CD", "DE","DF", "DG","EF","FG"]
# j_region = [ 0  , 1  , 2  ,  3  ,  4  ,  5 ,  6  ,  7 ,  8  ,  9 , 10]
region = ["A","B","C","D","E","F","G"]
for i in range(7):
    x.append(model.addVar(vtype=GRB.BINARY, name="x_%s"%region[i]))
for i in range(len(adj_region)):
    y.append(model.addVar(vtype=GRB.BINARY, name="y_%s"%adj_region[i]))
    
model.update()

model.addConstr(x[0]<=y[0]+y[1]) #X_A <= AB + AC
model.addConstr(x[1]<=y[0]+y[2]+y[3]+y[4]) # B <= AB+BC+BD+BE
model.addConstr(x[2]<=y[1]+y[2]+y[5]) # C = AC+BC+CD
model.addConstr(x[3]<=y[3]+y[5]+y[6]+y[7]+y[8]) # D = BD+CD+DE+DF+DG
model.addConstr(x[4]<=y[4]+y[6]+y[9]) # E = BE+DE+EF
model.addConstr(x[5]<=y[7]+y[9]+y[10]) # F = DF+EF+FG
model.addConstr(x[6]<=y[8]+y[10]) # G = DG+FG
model.addConstr(sum(y)==2) # only 2 representatives

model.update()

#set objective
model.setObjective(quicksum(pop[i]*x[i] for i in range(len(x))),GRB.MAXIMIZE)

model.optimize()

for var in model.getVars():

    print("{vn}: {val}".format(vn=var.VarName, val=round(var.x, 2)))
