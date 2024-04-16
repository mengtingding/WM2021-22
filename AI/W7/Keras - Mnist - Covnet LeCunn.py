# -*- coding: utf-8 -*-
"""
Created on Mon Feb  4 19:31:09 2019
modified 1/30/2020
@author: apblossom
"""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Import Libraries Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

import tensorflow as tf
from tensorflow.keras import models
from tensorflow.keras import layers
from tensorflow.keras.utils import to_categorical
import datetime
"""
#needed for Paul Blossom's PC
gpus = tf.config.list_physical_devices('GPU')
if gpus:
  try:
    # Currently, memory growth needs to be the same across GPUs
    for gpu in gpus:
      tf.config.experimental.set_memory_growth(gpu, True)
    logical_gpus = tf.config.experimental.list_logical_devices('GPU')
    #print(len(gpus), "Physical GPUs,", len(logical_gpus), "Logical GPUs")
  except RuntimeError as e:
    # Memory growth must be set before GPUs have been initialized
    print(e)
#needed for Paul Blossom's PC
"""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Parameters Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
np.random.seed(7)

#setup dataframe with fake data and column names for writing to disk
d=[[0, 28, 56, 84, .2323, .92323]]
df = pd.DataFrame(data=d)
df.columns=['Index', 'activate',  'optimize',  'batch_sizes', 'test_loss', 'test_acc']
#we need an index for the dataframe appends
# an index value of 0 should overwrite the fake data used in setup
Index=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Load Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
from tensorflow.keras.datasets import mnist
(train_images, train_labels), (test_images, test_labels) = mnist.load_data()

#print ("train_images.shape",train_images.shape)
#print ("len(train_labels)",len(train_labels))
#print("train_labels",train_labels)

#print("test_images.shape", test_images.shape)
#print("len(test_labels)", len(test_labels))
#print("test_labels", test_labels)

#

start_time = datetime.datetime.now()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#img = test_images[171]
#img = img.reshape((28,28))
#plt.imshow(img)
#plt.show()

train_images = train_images.reshape((60000, 28 , 28, 1))
train_images = train_images.astype('float32') / 255

test_images = test_images.reshape((10000, 28 , 28, 1))
test_images = test_images.astype('float32') / 255

train_labels = to_categorical(train_labels)
test_labels = to_categorical(test_labels)



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#committee of 35 conv. net, 1-20-P-40-P-150-10 [elastic distortions, width normalization]
for activate in ['relu', 'tanh', 'elu']:
    for optimize in ['adamax', 'adam', 'SGD', 'rmsprop']:
        for batch_sizes in [ 16, 32, 64]:
            network=models.Sequential()
            network.add(layers.Conv2D(20, (3, 3), activation=activate, input_shape=(28, 28, 1)))
            network.add(layers.MaxPooling2D((2, 2)))
            network.add(layers.Conv2D(40, (3, 3), activation=activate))
            network.add(layers.MaxPooling2D((2, 2)))
            network.add(layers.Flatten())
            network.add(layers.Dense(150, activation=activate))
            network.add(layers.Dense(10, activation='softmax'))
            #network.summary()
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            Fit Model Section
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            network.compile(optimizer=optimize,
                          loss='categorical_crossentropy',
                          metrics=['accuracy'])
            network.fit(train_images, train_labels, epochs=12, batch_size=batch_sizes, validation_data=(test_images, test_labels), verbose = 1)
            
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            Show output Section
            """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            #print('c1_size', c1_size, 'c2_size', c2_size, 'd1_size', d1_size)
            test_loss, test_acc = network.evaluate(test_images, test_labels)
            #print('test_loss:', test_loss)
            #print('test_acc:', test_acc)
            df.loc[Index]=[Index, activate, optimize,  batch_sizes, test_loss, test_acc]
            Index=Index+1

stop_time = datetime.datetime.now()
print ("Time required for training:",stop_time - start_time)

#print(df)
#print (result)
export_csv = df.to_csv (r'CNN_Hyper3.csv', index = None, header=True) 