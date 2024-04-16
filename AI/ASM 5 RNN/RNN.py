import pandas as pd
from numpy import array
from numpy import asarray
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split
import pandas as pd
from numpy import array
from numpy import asarray
import matplotlib.pyplot as plt
from datetime import datetime
import random

from sklearn.model_selection import train_test_split

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.layers import Embedding, LSTM, Dropout
from tensorflow.keras.models import Sequential
from keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.layers import Flatten, Dense


train = pd.read_csv('train.csv',encoding='utf8')
test = pd.read_csv('test.csv',encoding='utf8')

y = train["label"]
maxlength = 50

t = Tokenizer()
t.fit_on_texts(train['tweet'].values)
X = t.texts_to_sequences(train['tweet'].values)
X = pad_sequences(X,maxlen=maxlength,padding='post')

X_train, X_valid, y_train, y_valid = train_test_split(X, y, test_size=0.20, random_state=52)
vocab_size = len(t.word_index) + 1

start = datetime.now()
model = Sequential()
model.add(Embedding(vocab_size,32,input_length=maxlength))
model.add(LSTM(64, return_sequences=False, dropout=0.1, recurrent_dropout=0.1,recurrent_activation="sigmoid",activation = "tanh"))
#model.add(Dropout(0.2))
model.add(Flatten())
model.add(Dense(1,activation='sigmoid'))
print(model.summary())

opt = keras.optimizers.Adam(learning_rate=0.001)
model.compile(optimizer=opt,loss='binary_crossentropy',metrics = ['acc'])
print(model.summary)
history = model.fit(X_valid,y_valid,epochs=10,batch_size = 20, validation_split = 0.2)
end=datetime.now()
print("run time:",end-start)

"""
plots
"""
plt.plot(history.history["acc"])
plt.plot(history.history["val_acc"])
plt.title("Model Accuracy")
plt.ylabel("Accuracy")
plt.xlabel("Epoch")
plt.legend(["Train","Test"])
plt.ylim([0,1])
plt.show()

plt.plot(history.history['loss'], label='Training loss')
plt.plot(history.history['val_loss'], label='Validation loss')
plt.ylabel("Loss")
plt.title("Model loss")
plt.ylim([0,1])
plt.legend(["Train","validate"])
plt.show()

"""
prediction
"""
t = Tokenizer()
t.fit_on_texts(test['tweet'].values)
encoded_test_tweets = t.texts_to_sequences(train['tweet'].values)
padded_test_tweets = pad_sequences(encoded_test_tweets,maxlen=maxlength,padding='post')
prob = model.predict(padded_test_tweets,verbose=1,batch_size=20)
pred = []
for i in range(len(prob)):
    if prob[i] > 0.5:
        pred.append(1)
    else:
        pred.append(0)

#sample prediction
for i in range(4):
    index = random.randint(0,len(prob))
    print(encoded_test_tweets[index],pred[index])

hatespeech = round((sum(pred)/len(pred)),3)*100
print("the percentage of hate speech tweets is: {}%".format(hatespeech))




