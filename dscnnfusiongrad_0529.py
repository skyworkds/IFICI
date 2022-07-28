
from pickle import UNICODE
import cv2
import numpy as np
import matplotlib.pyplot as plt
import os
os.environ['HDF5_DISABLE_VERSION_CHECK'] = '2' 


import tensorflow as tf
from keras.models import *
from keras.layers import *
from keras.optimizers import *
from keras import backend as keras
from skimage.metrics import structural_similarity as ssim
from sklearn import metrics as mr
from keras.callbacks import ModelCheckpoint #


def grad_loss(y_true,y_pred,nir,vis):
	nir=tf.cast(nir,tf.float32)
	vis=tf.cast(vis,tf.float32)
	mse = keras.mean(keras.square(y_pred - y_true), axis=-1)
	

	#w  = [1 4 6 4 1] / 16;
	kernelx = tf.constant([
		[
			[-1.0],  [0.0], [1.0],
			[-2.0],  [0.0], [2.0],
			[-1.0],  [0.0], [1.0]
		]
	],shape=[3,3,1,1])
	kernely = tf.constant([
		[
			[-1.0], [-2.0], [-1.0],
			[0.0],  [0.0], [0.0],
			[1.0],  [2.0], [1.0]
		]
	],shape=[3,3,1,1])


	# kernelx = kernelx/2.0
	# kernely = kernely/2.0
	cnir = tf.nn.conv2d(nir, kernelx, strides=[1, 1, 1, 1], padding='SAME')
	rnir = tf.nn.conv2d(nir, kernely, strides=[1, 1, 1, 1], padding='SAME')
	hfnir = keras.square(cnir)+keras.square(rnir)
	# hfnir = keras.sqrt(hfnir)
	
	cvis = tf.nn.conv2d(vis, kernelx, strides=[1, 1, 1, 1], padding='SAME')
	rvis = tf.nn.conv2d(vis, kernely, strides=[1, 1, 1, 1], padding='SAME')
	hfvis = keras.square(cvis)+keras.square(rvis)
	# hfvis = keras.sqrt(hfvis)
	
	cpred = tf.nn.conv2d(y_pred, kernelx, strides=[1, 1, 1, 1], padding='SAME')
	rpred = tf.nn.conv2d(y_pred, kernely, strides=[1, 1, 1, 1], padding='SAME')
	hfy_pred = keras.square(cpred)+keras.square(rpred)
	# hfy_pred = keras.sqrt(hfy_pred)
	
	kernelx = tf.constant([
		[
			[1.0],  [0.0], 
			[0.0],  [-1.0]
		]
	],shape=[2,2,1,1])
	kernely = tf.constant([
		[
			[0.0], [1.0], 
			[-1.0],  [0.0]
		]
	],shape=[2,2,1,1])
	# convresx = tf.nn.conv2d(hfy_pred-hfnir/2-hfvis/2, kernelx, strides=[1, 1, 1, 1], padding='SAME') 
	# convresy = tf.nn.conv2d(hfy_pred-hfnir/2-hfvis/2, kernely, strides=[1, 1, 1, 1], padding='SAME')
	# grad = keras.mean(keras.square(convresx)+keras.square(convresy), axis=-1)

	# convresx = tf.nn.conv2d(hfy_pred-keras.maximum(hfnir,hfvis), kernelx, strides=[1, 1, 1, 1], padding='SAME') 
	# convresy = tf.nn.conv2d(hfy_pred-keras.maximum(hfnir,hfvis), kernely, strides=[1, 1, 1, 1], padding='SAME')
	# grad = keras.mean(keras.square(convresx)+keras.square(convresy), axis=-1)
	# return mse+2.9*grad 

	grad = keras.mean(
		keras.abs(hfy_pred - keras.maximum(keras.maximum(hfvis, hfnir), hfy_pred)), axis=-1)
	return mse+100.1209*grad  


	# return grad  
def regugrad_loss(nis, vis):
	def grad(y_true,y_pred):
		return grad_loss(y_true,y_pred,nis,vis)
	return grad  

path = os.getcwd()
print(path)
for i in range(8,41):
	#i = 1
	nirfile = ".\\fusionsource\\TNO\\Test_vi\\"+str(i)+".bmp"
	visfile = ".\\fusionsource\\TNO\\Test_ir\\"+str(i)+".bmp"
	nsctfile = ".\\fusionresult\\TNO\\"+str(i)+".png"
		
	print(nirfile)

	Imgnir = cv2.imread(nirfile,cv2.IMREAD_GRAYSCALE)
	Imgvis = cv2.imread(visfile,cv2.IMREAD_GRAYSCALE)
	Imgnsct = cv2.imread(nsctfile,cv2.IMREAD_GRAYSCALE)

	ssimv = ssim(Imgnir,Imgvis)
	print(ssimv)
	print(Imgnir.shape)

	Imgnir = Imgnir.reshape(1,Imgnir.shape[0],Imgnir.shape[1],1)
	Imgvis = Imgvis.reshape(1,Imgvis.shape[0],Imgvis.shape[1],1)
	Imgnsct = Imgnsct.reshape(1,Imgnsct.shape[0],Imgnsct.shape[1],1)

	nirinput = Input(shape=(None,None,1)) #nirinput = Input(shape=(256,256,1))
	visinput = Input(shape=(None,None,1))
	maininput = Input(shape=(None,None,1))

	bon1 = Conv2D(32,(3,3),padding='same',activation='relu')(maininput)
	nir1 = Conv2D(32,(3,3),padding='same',activation='relu')(nirinput)
	vis1 = Conv2D(32,(3,3),padding='same',activation='relu')(visinput)
	con1 = concatenate([bon1,nir1,vis1],axis=3)

	bon2 = Conv2D(32,(3,3),padding='same',activation='relu')(con1)
	nir2 = Conv2D(32,(3,3),padding='same',activation='relu')(nirinput)
	vis2 = Conv2D(32,(3,3),padding='same',activation='relu')(visinput)
	con2 = concatenate([bon2,nir2,vis2],axis=3)

	output = Conv2D(32,(3,3),padding='same',activation='relu')(con2)
	output = Conv2D(1,(1,1),padding='same')(output)

	model = Model(input = [nirinput,visinput,maininput], output = output)

	model.summary()
	mode_loss = regugrad_loss(Imgnir,Imgvis)
	# model.compile(optimizer = Adam(lr = 1e-4), loss = 'mean_squared_error', metrics = ['accuracy'])
	model.compile(optimizer = Adam(lr = 5e-4), loss = mode_loss, metrics = ['accuracy'])

	# checkpoint  
	filepath = "best_weights.h5"
	#checkpoint = ModelCheckpoint(filepath, monitor='val_acc', verbose=0, save_best_only=True, mode='max', period=1)
	checkpoint = ModelCheckpoint(filepath, monitor='loss', save_weights_only=True, verbose=0, save_best_only=True, mode='min', period=1)
	callbacks_list = [checkpoint]


	model.fit([Imgnir,Imgvis,Imgnsct], Imgnsct,  epochs=500, batch_size=1, callbacks = callbacks_list)

	model = Model(input = [nirinput,visinput,maininput], output = output)
	model.load_weights('best_weights.h5')
	preoutput = model.predict([Imgnir,Imgvis,Imgnsct])

	print(preoutput[0].shape)
	print(preoutput[0])
	# plt.imshow(preoutput[0].reshape([240,320]))
	refile = ".\\fusionresult\\TNO_CNNOP\\"+str(i)+".png"
	cv2.imwrite(refile,preoutput[0])
