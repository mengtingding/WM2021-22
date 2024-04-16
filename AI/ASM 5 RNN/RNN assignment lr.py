"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Import Libraries Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#from numpy import array
#from numpy import asarray
#from numpy import zeros
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.layers import Flatten
from tensorflow.keras.layers import Embedding
from tensorflow.keras.layers import LSTM, Dropout
import datetime
from tensorflow import keras
from sklearn.model_selection import train_test_split
import pandas as pd
import matplotlib.pyplot as plt

'''
gpus = tf.config.list_physical_devices('GPU')
if gpus:
  try:
    # Currently, memory growth needs to be the same across GPUs
    for gpu in gpus:
      tf.config.experimental.set_memory_growth(gpu, True)
    logical_gpus = tf.config.experimental.list_logical_devices('GPU')
    print(len(gpus), "Physical GPUs,", len(logical_gpus), "Logical GPUs")
  except RuntimeError as e:
    # Memory growth must be set before GPUs have been initialized
    print(e)'''
    
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Parameters Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
max_features = 20000
# cut texts after this number of words (among top max_features most common words)
max_length = 40

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Load Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
print('Loading data...')

data = pd.read_csv('train.csv', encoding='utf8')

y = data['label']

start_time = datetime.datetime.now()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Pretreat Data Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# prepare tokenizer
t = Tokenizer()
t.fit_on_texts(data['tweet'].values)
#vocab_size = len(t.word_index) + 1 #???
# integer encode the documents
encoded_docs = t.texts_to_sequences(data['tweet'].values)
#print(encoded_docs)
# pad documents to a max length
padded_docs = pad_sequences(encoded_docs, maxlen=max_length, padding='post')
#print(padded_docs)

X_train, X_test, y_train, y_test = train_test_split(padded_docs, y, test_size=0.2, random_state=66)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Define Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# define model
model = Sequential()
model.add(Embedding(3000, 100, input_shape=(X_train.shape[1],), input_length=max_length))
#model.add(LSTM(64, activation="elu", kernel_initializer="he_normal", return_sequences=True))
#model.add(Dropout(0.5))
#model.add(LSTM(64, activation="elu", kernel_initializer="he_normal", return_sequences=False))
#model.add(Dropout(0.5))
model.add(LSTM(128, dropout=0.2, recurrent_dropout=0.0, recurrent_activation="sigmoid", activation="tanh",use_bias=True, unroll=False))
model.add(Flatten())
model.add(Dense(1,activation='sigmoid'))


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Train Model Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
# compile the model
opt = keras.optimizers.Adam(learning_rate = 0.0001)# default is 0.01
model.compile(optimizer=opt, loss='binary_crossentropy', metrics=['accuracy'])
# summarize the model
print(model.summary())
# fit the model
history = model.fit(X_train, y_train, epochs=10, batch_size = 32, verbose=1, validation_split = 0.2)
# evaluate the model

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Show output Section
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
#loss, accuracy = model.evaluate(padded_docs, labels, verbose=0)
#print('Accuracy: %f' % (accuracy*100))
#Plot training & validation accuracy values
plt.plot(history.history["accuracy"])
plt.plot(history.history["val_accuracy"])
plt.title("Model Accuracy")
plt.ylabel("Accuracy")
plt.xlabel("Epoch")
plt.legend(["Train","Test"])
plt.ylim([0,1])
plt.show()

#Plot loss
#Plot training & validation accuracy values
plt.plot(history.history["loss"])
plt.plot(history.history["val_loss"])
plt.title("Model Loss")
plt.ylabel("Loss")
plt.xlabel("Epoch")
plt.legend(["Train","Test"])
plt.ylim([0,1])
plt.show()

stop_time = datetime.datetime.now()
print ("Time required for training:",stop_time - start_time)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Prediction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
'''t = Tokenizer()
t.word_to_texts(data['tweet'].values)
encoded = t.texts_to_sequences(data['tweet'].values)
padded = pad_sequences(encoded, maxlen=max_length, padding='post')'''

#pred = model.predict()

