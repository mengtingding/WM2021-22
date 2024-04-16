# Question 4
from gurobipy import *
Arcs= {('1','2'):400,("1","3"):950,("1","4"):800,
    ("2","5"):1800,("2","6"):900,
    ("3","5"):1100,("3","6"):600,
    ("4","6"):600,("4","7"):1200,
    ("6","5"):900,("6","7"):1000,("5","8"):400,("6","8"):1300,("7","8"):600}
Nodes = ["1","2","3","4","5","6","7","8"]
visited = []

shortest = [-1]*len(Nodes); prev_node = shortest.copy()

while len(Nodes) != 0:
    if len(visited) == 0:
        visited.append(Nodes[0])
        shortest[0] = 0
        prev_node[0] = Nodes[0]
        Nodes.pop(0)
    elif len(visited) == 1:
        
    
    
model=Model("Truck")

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
    if (key[0]=='1'):
        lhs_1.addTerms(1,X[key])
    elif (key[1]=='8'):
        lhs_2.addTerms(1,X[key])

model.addConstr(lhs_1==1,name='start flow')
model.addConstr(lhs_1==1,name='end flow')

for node in Nodes:
    lhs = LinExpr(0)
    if(node!='1' and node!='8'):
        for key in Arcs.keys():
            if(key[1]==node):
                lhs.addTerms(1,X[key])
            elif(key[0]==node):
                lhs.addTerms(-1,X[key])
    print()
    model.addConstr(lhs==0,name="flow conservation")
    
model.write('model_spp.lp')
model.optimize()

print("Objective:",model.ObjVal)
for var in model.getVars():
    if(var.x>0):
        print(var.varName,var.x)
