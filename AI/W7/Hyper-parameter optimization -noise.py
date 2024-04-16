# -*- coding: utf-8 -*-
"""
Created on Mon Apr 15 14:17:54 2019

@author: apblossom
"""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Import Libraries Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Use scikit-learn to grid search the batch size and epochs
import numpy
from sklearn.model_selection import GridSearchCV
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.layers import GaussianNoise
from tensorflow.keras.wrappers.scikit_learn import KerasClassifier

import datetime
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Parameters Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# set random seed for reproducibility
seed = 7
numpy.random.seed(seed)

num_epochs=20
num_nodes=12
input_cols=8
# define the grid search parameters
optimizer = ['SGD', 'RMSprop', 'Adam']#, 'Adamax','Adagrad', 'Adadelta', 'Nadam']
noise=[0.01, 0.05, 0.1, 0.25]
num_folds=5
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Load Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# load Pima Indian Diabetes dataset
dataset = numpy.loadtxt("pima-indians-diabetes.csv", delimiter=",")


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# split into input (X) and output (Y) variables using slices
X_train = dataset[:,0:8]
Y_train = dataset[:,8]


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
start_time = datetime.datetime.now()

# Function to create model, required for KerasClassifier
def create_model(optimizer='adam', noise=0.1):
	# create model
    model = Sequential()
    model.add(GaussianNoise(noise, input_shape=(input_cols,)))
    model.add(Dense(num_nodes, input_shape=(input_cols,), activation='relu'))
    model.add(Dense(1, activation='sigmoid'))
	# Compile model
    model.compile(loss='binary_crossentropy', optimizer=optimizer, metrics=['accuracy'])
    return model
	
# create model
model = KerasClassifier(build_fn=create_model, epochs=num_epochs, batch_size=10, verbose=0)


param_grid = dict(optimizer=optimizer, noise=noise)
#https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.GridSearchCV.html
# n_jobs=-1 means using all processors (don't use).

grid = GridSearchCV(estimator=model, param_grid=param_grid, n_jobs=1, cv=num_folds, verbose=3)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Train Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
grid_result = grid.fit(X_train, Y_train)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Show output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# print out results
print("Best: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
means = grid_result.cv_results_['mean_test_score']
stds = grid_result.cv_results_['std_test_score']
params = grid_result.cv_results_['params']
for mean, stdev, param in zip(means, stds, params):
    print("%f (%f) with: %r" % (mean, stdev, param))
   

stop_time = datetime.datetime.now()
print ("Time required for training:",stop_time - start_time)






