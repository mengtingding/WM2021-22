from gurobipy import *
m=Model('Jones')

#Decision Variables

savings=m.addVar(vtype=GRB.CONTINUOUS, name='Savings Account', lb=0.0)
cd=m.addVar(vtype=GRB.CONTINUOUS, name='Cert of Deposit', lb=0.0)
al=m.addVar(vtype=GRB.CONTINUOUS, name='Atlantic Lighting', lb=0.0)
ar=m.addVar(vtype=GRB.CONTINUOUS, name='Arkansas REIT', lb=0.0)
bedrock=m.addVar(vtype=GRB.CONTINUOUS, name='Bedrock Insurance Annuity', lb=0.0)
nocal=m.addVar(vtype=GRB.CONTINUOUS, name='Nocal Mining Bond', lb=0.0)
mini=m.addVar(vtype=GRB.CONTINUOUS, name='Minicomp Systems', lb=0.0)
antony=m.addVar(vtype=GRB.CONTINUOUS, name='Antony Hotels', lb=0.0)



Portfolio=[savings, cd, al, ar, bedrock, nocal, mini, antony] #variable name
expReturn=[0.04, 0.052, 0.071, 0.1, 0.082, 0.065, 0.2, 0.125]

m.update()

#Constraints

m.addConstr(savings+cd+al+ar+bedrock+nocal+mini+antony, GRB.EQUAL, 100000)
m.addConstr(savings+cd, GRB.LESS_EQUAL, 30000)
m.addConstr(savings*0.04+cd*0.052+al*0.071+ar*0.1+bedrock*0.082+nocal*0.065+mini*0.2+antony*0.125, 
            GRB.GREATER_EQUAL, 
            .075*(savings+cd+al+ar+bedrock+nocal+mini+antony))

m.addConstr(savings+cd+bedrock+mini, GRB.GREATER_EQUAL, 
            0.5*(savings+cd+al+ar+bedrock+nocal+mini+antony))

m.addConstr(savings+al+ar+mini+antony, 
            GRB.GREATER_EQUAL, 0.4*(savings+cd+al+ar+bedrock+nocal+mini+antony))

m.update()

#Optimization Model

m.setObjective(savings*0 + cd*0 + al*25 + ar*30 + bedrock*20 + nocal*15 + mini*65+ antony*40, GRB.MINIMIZE)

m.optimize()

for var in m.getVars():
    print("Jones should recommend that Frank invests $%s in %s" % ((round(var.x,2)), var.varName))
print("Investing this amount in each of the respective accounts will minimize Frank's risk at a risk factor of %s" % round(m.objVal,2))