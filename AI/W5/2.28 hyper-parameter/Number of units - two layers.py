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
from tensorflow.keras.wrappers.scikit_learn import KerasClassifier
from tensorflow.keras.layers import Dropout
from tensorflow.keras.constraints import max_norm
#https://keras.io/scikit-learn-api/

import datetime
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Parameters Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# set random seed for reproducibility
seed = 7
numpy.random.seed(seed)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Load Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# load Pima Indian Diabetes dataset
dataset = numpy.loadtxt("pima-indians-diabetes.csv", delimiter=",")

# split into input (X_train) and output (Y_train) variables using slices
X_train = dataset[:,0:8]
Y_train = dataset[:,8]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
start_time = datetime.datetime.now()

# Function to create model, required for KerasClassifier
def create_model(neurons_first=1, neurons_second=2):
    # create model
    model = Sequential()
    model.add(Dense(neurons_first, input_dim=8, kernel_initializer='uniform', activation='linear', kernel_constraint=max_norm(4)))
    model.add(Dense(neurons_second, kernel_initializer='uniform', activation='linear', kernel_constraint=max_norm(4)))
    model.add(Dense(1, activation='sigmoid'))
    optimizer = 'adam'
    # Compile model
    model.compile(loss='binary_crossentropy', optimizer=optimizer, metrics=['accuracy'])
    return model
	
# create model
model = KerasClassifier(build_fn=create_model, epochs=100, batch_size=10, verbose=0)
# define the grid search parameters
neurons_first = [5, 6]
neurons_second = [8, 9]
param_grid = dict(neurons_first=neurons_first, neurons_second=neurons_second)
#https://scikit-learn.org/stable/modules/generated/sklearn.model_selection.GridSearchCV.html
# n_jobs=-1 means using all processors (don't use).

grid = GridSearchCV(estimator=model, param_grid=param_grid, n_jobs=1, verbose=1)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Train Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
grid_result = grid.fit(X_train, Y_train)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Show output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# print out results
print("The best accuracy is: %f using %s" % (grid_result.best_score_, grid_result.best_params_))
means = grid_result.cv_results_['mean_test_score']
stds = grid_result.cv_results_['std_test_score']
params = grid_result.cv_results_['params']
for mean, stdev, param in zip(means, stds, params):
    print("Mean = %f StDev = %f with: %r" % (mean, stdev, param))

 

stop_time = datetime.datetime.now()
print ("Time required for training:",stop_time - start_time)






