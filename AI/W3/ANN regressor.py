"""import library section"""
import datetime
from tensorflow.keras.datasets import boston_housing
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
import matplotlib.pyplot as plt
"""
Parameters section
"""


"""
Load Data
"""
(train_data, train_targets), (test_data,test_targets) = boston_housing.load_data()
#print(f'training data : {train_data_shape}')
#print()

"""
Pretreat data section
"""
import seaborn as sns
import matplotlib.pyplot as plt
from scipy import stats


"""
Define Model Section
"""
start_time = datetime.datetime.now()
#create model
model = Sequential()
model.add(Dense(13,input_dim=13, activation='relu')) # first layer, size, activation function 
model.add(Dense(1))

#compile model
model.compile(loss='mean_squared_error',optimizer ='adam',metrics=['mean_absolute_error'])
"""
train Model Section
"""
history = model.fit(train_data,train_targets,epochs=25,batch_size=5,verbose=1,validation_data=(test_data,test_targets)) # save the value of loss function and metrics
#epoch is the number of epochs is how many times the algorithm is going to run
"""
show output section
"""
#visualisation training history
plt.figure()
plt.plot(history.history['mean_absolute_error'],label='Training accuracy')
plt.plot(history.history['val_mean_absolute_error'], label='test accuracy')
plt.title("Training vs Testing MAE values")
plt.xlabel("Epoch")
plt.ylabel('MAE values')
plt.legend(loc="upper left")
plt.show()

#visualize training loss history
plt.figure()
plt.plot(history.history['loss'],label='Training loss')
plt.plot(history.history['val_loss'], label='test loss')
plt.title("Training vs Testing loss values")
plt.xlabel("Epoch")
plt.ylabel('loss')
plt.legend(loc="upper left")
plt.show()

stop_time = datetime.datetime.now()
print("Time required for training:", stop_time-start_time)








