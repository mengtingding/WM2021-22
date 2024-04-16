# -*- coding: utf-8 -*-
"""
Created on Wed Mar 30 12:03:50 2022

@author: mengt
"""

"""
import libraries 
"""
import tensorflow.keras as keras
from tensorflow.keras import optimizers
from tensorflow.keras import layers
from tensorflow.keras import models
from tensorflow.keras import Input
from tensorflow.keras.utils import to_categorical
from tensorflow.keras.datasets import cifar10
import matplotlib.pyplot as plt
import datetime
import pandas as pd

"""
loading data
"""
start = datetime.datetime.now()
(x_train,y_train),(x_test,y_test) = cifar10.load_data()
"""one hot encoding????"""
y_train = to_categorical(y_train,10)
y_test = to_categorical(y_test,10)
x_train = x_train.astype('float32') #scale the train and test dataset 
x_test = x_test.astype('float32')

print("Train samples:",x_train.shape,y_train.shape)
#print("Train samples:",x_test.shape,y_test.shape)

#data_augmentation = keras.Sequential(
#    [
#        layers.RandomFlip("horizontal"),
#        layers.RandomRotation(0.1),    
#        layers.RandomZoom(0.2),
#    ]
#)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
model = models.Sequential()
model.add(Input(shape=(32,32,3))) 
model.add(layers.Rescaling(1./255))
model.add(layers.Conv2D(32,(3,3),activation='relu'))
model.add(layers.MaxPooling2D((2,2)))
model.add(layers.Conv2D(64,(3,3),activation='relu'))
model.add(layers.MaxPooling2D((2,2)))
model.add(layers.Conv2D(128,(3,3),activation='relu'))
model.add(layers.MaxPooling2D((2,2)))
model.add(layers.Flatten())
model.add(layers.Dense(512,activation="relu"))
model.add(layers.Dense(10,activation="softmax"))
model.summary()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Train Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
model.compile(loss='categorical_crossentropy', optimizer = optimizers.Adam(lr=0.001),
              metrics=["accuracy"])
batch_size = 32
history=model.fit(x_train,y_train,epochs=30,batch_size=batch_size,validation_data=(x_test,y_test),verbose=1)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Show output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#plotting training and testing loss vs training iterations
accuracy = history.history['accuracy']
val_accuracy = history.history['val_accuracy']
loss = history.history['loss']
val_loss = history.history['val_loss']

epochs = range(len(accuracy))

plt.plot(epochs, accuracy, 'bo', label='Training acc')
plt.plot(epochs, val_accuracy, 'b', label='Validation acc')
plt.title('Training and validation accuracy')
plt.legend()

plt.figure()

plt.plot(epochs, loss, 'bo', label='Training loss')
plt.plot(epochs, val_loss, 'b', label='Validation loss')
plt.title('Training and validation loss')
plt.legend()

plt.show()

end = datetime.datetime.now()
print('running time:',end-start)