# import pulp
from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize

# define variables
X11 = LpVariable("X11", 0, None)
X12 = LpVariable("X12", 0, None)
X13 = LpVariable("X13", 0, None)
X21 = LpVariable("X21", 0, None)
X22 = LpVariable("X22", 0, None)
X23 = LpVariable("X23", 0, None)
X31 = LpVariable("X31", 0, None)
X32 = LpVariable("X32", 0, None)
X33 = LpVariable("X33", 0, None)
X41 = LpVariable("X41", 0, None)
X42 = LpVariable("X42", 0, None)
X43 = LpVariable("X43", 0, None)
X51 = LpVariable("X51", 0, None)
X52 = LpVariable("X52", 0, None)
X53 = LpVariable("X53", 0, None)
Y11 = LpVariable("Y11", 0, None)
Y12 = LpVariable("Y12", 0, None)
Y13 = LpVariable("Y13", 0, None)
Y14 = LpVariable("Y14", 0, None)
Y21 = LpVariable("Y21", 0, None)
Y22 = LpVariable("Y22", 0, None)
Y23 = LpVariable("Y23", 0, None)
Y24 = LpVariable("Y24", 0, None)
Y31 = LpVariable("Y31", 0, None)
Y32 = LpVariable("Y32", 0, None)
Y33 = LpVariable("Y33", 0, None)
Y34 = LpVariable("Y34", 0, None)
M1 = LpVariable("M1", 0, 1)
M2 = LpVariable("M2", 0, 1)
M3 = LpVariable("M3", 0, 1)
M4 = LpVariable("M4", 0, 1)
M5 = LpVariable("M5", 0, 1)
W1 = LpVariable("W1", 0, 1)
W2 = LpVariable("W2", 0, 1)
W3 = LpVariable("W3", 0, 1)

# defines the problem
prob = LpProblem("problem", LpMinimize)

# define constraints
prob += Y11 + Y21 + Y31 == 200
prob += Y12 + Y22 + Y32 == 300
prob += Y13 + Y23 + Y33 == 150
prob += Y14 + Y24 + Y34 == 250
prob += X11 + X12 + X13 <= 300*M1
prob += X21 + X22 + X23 <= 200*M2
prob += X31 + X32 + X33 <= 300*M3
prob += X41 + X42 + X43 <= 200*M4
prob += X51 + X52 + X53 <= 400*M5
prob += X11 + X21 + X31 + X41 + X51 == Y11 + Y12 + Y13 + Y14
prob += X12 + X22 + X32 + X42 + X52 == Y21 + Y22 + Y23 + Y24
prob += X13 + X23 + X33 + X43 + X53 == Y31 + Y32 + Y33 + Y34
prob += Y11 <= 200*W1 # for each customer put in the demand 
prob += Y12 <= 300*W1
prob += Y13 <= 150*W1
prob += Y14 <= 250*W1
prob += Y21 <= 200*W2
prob += Y22 <= 300*W2
prob += Y23 <= 150*W2
prob += Y24 <= 250*W2
prob += Y31 <= 200*W3
prob += Y32 <= 300*W3
prob += Y33 <= 150*W3
prob += Y34 <= 250*W3

# define objective function
prob += 30000*W1 + 40000*W2 + 30000*W3 + 35000*M1 + 45000*M2 + 40000*M3 + 42000*M4 + 40000*M5 + 40*Y11 + 80*Y12 + 90*Y13 + 50*Y14 + 70*Y21 + 70*Y22 + 60*Y23 + 80*Y24 + 80*Y31 + 30*Y32 + 50*Y33 + 60*Y34 + 800*X11 + 1000*X12 + 1200*X13 + 700*X21 + 500*X22 + 700*X23 + 800*X31 + 600*X32 + 500*X33 + 500*X41 + 600*X42 + 700*X43 + 700*X51 + 600*X52 + 500*X53

# solve the problem
status = prob.solve()
print(f"Problem")
print(f"status={LpStatus[status]}")

# print the results
for variable in prob.variables():
    print(f"{variable.name} = {variable.varValue}")
    
print(f"Objective = {value(prob.objective)}")
print(f"")

