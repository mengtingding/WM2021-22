"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Import Libraries Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
import matplotlib.pyplot as plt

import numpy as np
import matplotlib.pyplot as plt
import itertools
#%matplotlib inline
from sklearn.metrics import confusion_matrix

import keras
from keras import models
from keras import layers

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
network.add(layers.Dense(2500, activation = 'relu', input_shape=(28 * 28,)))
network.add(layers.Dense(2000, activation='relu'))
network.add(layers.Dense(1500, activation='relu'))
network.add(layers.Dense(1000, activation='relu'))
network.add(layers.Dense(500, activation='relu'))
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




def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    plt.figure()
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]

    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, cm[i, j],
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')

# Predict the values from the validation dataset
pred_label = network.predict(test_images)
# Convert predictions classes to one hot vectors 
pred_label_classes = np.argmax(pred_label,axis = 1) 
# Convert validation observations to one hot vectors
label_true = np.argmax(test_labels,axis = 1) 
# compute the confusion matrix
confusion_mtx = confusion_matrix(label_true, pred_label_classes) 
print(confusion_mtx)
# plot the confusion matrix
plot_confusion_matrix(confusion_mtx, classes = range(10)) 


