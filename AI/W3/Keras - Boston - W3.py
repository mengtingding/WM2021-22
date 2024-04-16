"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Import Libraries Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
import datetime
from tensorflow.keras.datasets import boston_housing
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
import matplotlib.pyplot as plt

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Parameters Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Load Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
(train_data, train_targets), (test_data, test_targets) = boston_housing.load_data()
#print(f'Training data : {train_data.shape}')
#print(f'Test data : {test_data.shape}')
#print(f'Training sample : {train_data[0]}')
#print(f'Training target sample : {train_targets[0]}')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
start_time = datetime.datetime.now()
# create model
model=Sequential()
model.add(Dense(13, input_dim=13, activation = 'relu', kernel_initializer='normal'))
model.add(Dense(1, kernel_initializer='normal'))

#compile model
model.compile(loss='mean_squared_error', optimizer='adam', metrics=['mean_absolute_error'])
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Train Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
history = model.fit(train_data, train_targets, epochs=100, batch_size=5, verbose=1, validation_data=(test_data,test_targets))

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Show output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# Visualize training metric history
plt.figure()
plt.plot(history.history['mean_absolute_error'], label='Training accuracy')
plt.plot(history.history['val_mean_absolute_error'], label='Test accuracy')
plt.title('Training / Test MAE values')
plt.xlabel('Epoch')
plt.ylabel('MAE')
plt.legend(loc="upper left")
plt.show()

# Visualize training loss history
plt.figure()
plt.plot(history.history['loss'], label='Training loss')
plt.plot(history.history['val_loss'], label='Test loss')
plt.title('Training / Test loss values')
plt.xlabel('Epoch')
plt.ylabel('loss')
plt.legend(loc="upper left")
plt.show()

stop_time = datetime.datetime.now()
print ("Time required for training:",stop_time - start_time)

