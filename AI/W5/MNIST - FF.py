# -*- coding: utf-8 -*-
"""
Created on Mon Feb 21 07:15:28 2022
https://en.wikipedia.org/wiki/MNIST_database
@author: pblos
"""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Import Libraries Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
import matplotlib.pyplot as plt


import tensorflow
from tensorflow.keras import models
from tensorflow.keras import layers

from tensorflow.keras.utils import to_categorical

import datetime
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Parameters Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Load Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
from keras.datasets import mnist
(train_images, train_labels), (test_images, test_labels)= mnist.load_data()

print("train_images shape= ", train_images.shape)
print("test_images shape= ", test_images.shape)

#image=train_images[6006]
#label=train_labels[6006]
#print(label)
#image=image.reshape(28,28)
#plt.imshow(image)
#plt.show

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
train_images=train_images.astype('float32')/255
test_images=test_images.astype('float32')/255

train_labels=to_categorical(train_labels)
test_labels=to_categorical(test_labels)

train_images=train_images.reshape(60000, 28*28)
test_images=test_images.reshape(10000, 28*28)
print("train_images shape= ", train_images.shape)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
start_time = datetime.datetime.now()

network=models.Sequential()
network.add(layers.Dense(784, activation = 'relu', input_shape=(28 * 28,)))
network.add(layers.Dense(800, activation='relu'))
network.add(layers.Dense(10, activation='softmax'))
network.compile(optimizer='rmsprop', loss= 'categorical_crossentropy', metrics = ['accuracy'])
network.summary()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Train Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
network.fit(train_images, train_labels, epochs=5, batch_size=128)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Show output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
test_loss, test_acc=network.evaluate(test_images, test_labels)
print('test loss= ', test_loss)
print('test accuracy= ', test_acc)

stop_time = datetime.datetime.now()
print ("Time required for training:",stop_time - start_time)