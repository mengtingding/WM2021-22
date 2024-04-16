import numpy as np
from gurobipy import * 

# index sets: i plant, j warehouse, k retailer, y year
# 
demand = [[1000,1200,1800,1200,1000,1400,1600,1000]] 
rate = [0.2,0.2,0.25,0.2,0.2,0.25,0.25,0.2]
for t in range(2,11):
    demand_1 = []
    for j in range(len(demand[0])):
        demand_1.append(demand[0][j]+demand[0][j]*rate[j]**(t-1))
    demand.append(demand_1)

# Capacity
Capacity = [16000,12000,14000,10000,13000]
plant = [1,2,3,4,5]
warehouse = [1,2,3,4]
retail = [1,2,3,4,5,6,7,8]
MaxI = 4000
# construction costs 
cstr = [[2000000,1600000,1800000,900000,1500000]]

for i in range(2,11):
    c = []
    for j in range(len(cstr[0])):
        c.append(cstr[0][j]*(1.03)**(i-1))
    cstr.append(c)

# reopen costs (plant i in year l
reopen = [[190000,150000,160000,100000,130000]]
for i in range(2,11):
    c = []
    for j in range(len(reopen[0])):
        c.append(reopen[0][j]*(1.03)**(i-1))
    reopen.append(c)
# operating costs (plant i in year l
operate = [[420000,380000,460000,280000,340000]]
for i in range(2,11):
    c = []
    for j in range(len(operate[0])):
        c.append(operate[0][j]*(1.03)**(i-1))
    operate.append(c)

# shut down costs (plant i in year l
shut_down = [[170000,120000,130000,80000,110000]]
for i in range(2,11):
    c = []
    for j in range(len(shut_down[0])):
        c.append(shut_down[0][j]*(1.03)**(i-1))
    shut_down.append(c)

# shipping costs
## plant i to Warehouse j, i=5,j=4
P_WH_2=[];P_WH_3=[];P_WH_4=[];P_WH_5=[];P_WH_6=[];P_WH_7=[];P_WH_8=[];P_WH_9=[]; P_WH_10=[]
P_WH_1 = [[120,130,80,50],
          [100,30,100,90],
          [50,70,60,30],
          [60,30,70,70],
          [60,20,40,80]]
P_to_WH = [P_WH_1,P_WH_2,P_WH_3,P_WH_4,P_WH_5,P_WH_6,P_WH_7,P_WH_8,P_WH_9,P_WH_10]
for a in range(len(P_to_WH)-1):
    for i in range(len(plant)):
        k = []
        for j in range(len(warehouse)):
            k.append(P_WH_1[i][j]*(1.03)**(a+1))
        P_to_WH[a+1].append(k)

## warehouse i to retail k
WH_R_1 = [[90,100,60,50,80,90,20,120],
           [50,70,120,40,30,90,30,80],
           [60,90,70,90,90,40,110,70],
           [70,80,90,60,100,70,60,90]]

WH_R_2=[];WH_R_3=[];WH_R_4=[];WH_R_5=[];WH_R_6=[];WH_R_7=[];WH_R_8=[];WH_R_9=[];WH_R_10=[]
WH_to_R = [WH_R_1,WH_R_2,WH_R_3,WH_R_4,WH_R_5,WH_R_6,WH_R_7,WH_R_8,WH_R_9,WH_R_10]

for a in range(len(WH_to_R)-1):
    for i in range(len(warehouse)):
        k = []
        for j in range(len(retail)):
            k.append(WH_R_1[i][j]*(1.03)**(a+1))
        WH_to_R[a+1].append(k)

year = list(range(1,11))
print(year)
AC = [200] #alloy cost for each year through 10 years
for t in year:
    AC.append(AC[0]+(1.03)**t)
maxalloy = 60000


## setting variables
# construction binary, reopen binary, operating binary, shut down binary
# number of products produces in plant i year 
## setting variables
# construction binary, reopen binary, operating binary, shut down binary
# number of products produces in plant i year 
model = Model("XYZ company")

# construction costs* construction binary c + reopen costs * reopen binary r + oeprating costs * operating binary o + shut down costs * shut down binary s
# + planttoWH shipping*plant to WH binary + WHtoretail shipping* WH retail binary
# + material costs 

## binary variables
C = model.addVars(range(1,len(plant)+1), range(1,len(year)+1),vtype=GRB.BINARY,ub=1,obj = cstr, name="construction") # construction 
O = model.addVars(range(1,len(plant)+1), range(1,len(year)+1),vtype=GRB.BINARY,ub=1,obj = operate, name="Operating") # operation
R = model.addVars(range(1,len(plant)+1), range(1,len(year)+1),vtype=GRB.BINARY,ub=1,obj = reopen, name="Reopening") # Reopen
S = model.addVars(range(1,len(plant)+1), range(1,len(year)+1),vtype=GRB.BINARY,ub=1,obj = shut_down, name="Shut down") # Shut down 
# lambda
#for i in range(len(year)): (warehouse variables)
X = model.addVars(range(1,len(plant)+1), range(1,len(warehouse)+1), range(1,len(year)+1),vtype=GRB.CONTINUOUS,obj = P_to_WH, name="ship_ij") # plant to WH shipping 
Y = model.addVars(range(1,len(warehouse)+1), range(1,len(retail)+1),range(1,len(year)+1),vtype=GRB.CONTINUOUS,obj = WH_to_R, name="ship_jk") # WH to retail shipping
I = model.addVars(warehouse,year, vtype=GRB.CONTINUOUS, name = "warehouse Inventory keeping") # warehouse k in year i each year

#production variable set:
Plantprod = model.addVars(plant,year,vtype=GRB.CONTINUOUS, name = "plantproduce")  # each year 

# Material variables:
mu1 = model.addVars(plant,year,vtype=GRB.BINARY,name ="mu1") #widget
mu2 = model.addVars(plant,year,vtype=GRB.BINARY,name ="mu2")  
mu3 = model.addVars(plant,year,vtype=GRB.BINARY,name ="mu3")
z1 = model.addVars(plant,year,vtype=GRB.BINARY,name ="z1")
z2 = model.addVars(plant,year,vtype=GRB.BINARY,name ="z2")

model.modelSense = GRB.MINIMIZE

# constraints

## binary constraints

for y in year:
    if y == 1:
        model.addConstrs((R[i,y] == O[i,y] for i in plant), "operation year 1")
    else:
        model.addConstrs((R[i,y] >= O[i,y]-O[i,y-1] for i in plant), "operation other years") # if its operating this year but not operating the year before
        model.addConstrs((S[i,y] >= O[i,y-1]-O[i,y] for i in plant), "Shut down costs") # shut down costs occurs when not operating this year but operated year before


## plants i to warehouse j in year y shipping & capacity constraints
for y in year:
    for i in plant:
        totalstorage=0
        for j in warehouse:
            totalstorage += X[i,j,y]
        model.addConstrs(totalstorage <= Capacity[i]*O[i,y], "plant shipping constriants")

## warehouse j to retail k in year y shipping constraints
for y in year:
    for j in warehouse:
        model.addConstrs(sum(Y[j,k,y] for k in retail) <= sum(X[i,j,y] for i in plant), "warehouse shipping constraints")
        model.addConstrs(sum(Y[j,k,y] for k in retail) == demand[y,k], "Demand for each year") #demand constraint

# inventory constraint
model.addConstrs((I[j,y] <= MaxI for j in warehouse for y in year), "maximum inventory") # ending inventory for warehouse j in year y

### alloy
for y in year:
    for i in plant:
        model.addConstrs(sum(X[i,j,y] for j in warehouse)* 4.7 <= maxalloy, "alloy constraint for each year each plants")

### widget mu (plant, year)
for y in year:
    for i in plant:
        model.addConstrs(sum(X[i,j,y] for j in warehouse)*3==(0*mu1[i,y]+(9000*150*(1.03)**y)*mu2[i,y]+(16000*3*120*(1.03)**y)*mu3[i,y]),"widget for plant i for year y")
        model.addConstrs((mu1[i,y]+mu2[i,y]+mu3[i,y]==1), "control wiget")
        model.addConstrs((z1[i,y]+z2[i,y]==1), "control wiget assembly")
        model.addConstrs((mu1[i,y]<=z1[i,y]), "control wiget assembly")
        model.addConstrs((mu2[i,y]<=z1[i,y]+z2[i,y]), "control wiget assembly")
        model.addConstrs((mu3[i,y]<=z2[i,y]), "control wiget assembly")


## average yearly inventory 
## both the flow into a warehouse and the flow out of a warehouse should not exceed an average of 1000 units per month. #2-10 IAN
model.addConstrs((I[j,y]<=12000 for j in warehouse for y in year),"MAX") 

model.addConstrs((sum(Y[i,j,y] for j in warehouse) <=(12000 for i in plant for y in year)," max flow in for each warehouse per year"))
#model.addConstrs((Y.sum(i,k,'*')<=12000 for i in year for k in warehouse for r in retail)," max flow out")
for y in year:
    for j in warehouse:
        model.addConstrs(sum(Y[j,k,y] for k in retail)<=12000,"max flow out for each warehouse per year")
#2-10 AVG(INVENTORY)
model.addConstrs(((I[1,k]+I[2,k])<=4000*2 for k in warehouse),"AVG<=4000")
model.addConstrs(((I[2,k]+I[3,k])<=4000*2 for k in warehouse),"AVG<=4000")
model.addConstrs(((I[3,k]+I[4,k])<=4000*2 for k in warehouse),"AVG<=4000")
model.addConstrs(((I[4,k]+I[5,k])<=4000*2 for k in warehouse),"AVG<=4000")
model.addConstrs(((I[5,k]+I[6,k])<=4000*2 for k in warehouse),"AVG<=4000")
model.addConstrs(((I[6,k]+I[7,k])<=4000*2 for k in warehouse),"AVG<=4000")
model.addConstrs(((I[7,k]+I[8,k])<=4000*2 for k in warehouse),"AVG<=4000")
model.addConstrs(((I[8,k]+I[9,k])<=4000*2 for k in warehouse),"AVG<=4000")
model.addConstrs(((I[9,k]+I[10,k])<=4000*2 for k in warehouse),"AVG<=4000")

model.optimize()

print(model.ObjVal)
for var in model.getVars():
    if(var.x>0):
        print(var.varName,var.x)