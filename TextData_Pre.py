#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov  9 18:44:03 2021

@author: bruce
"""

import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeClassifier 
from sklearn.model_selection import train_test_split
from sklearn import metrics 
from sklearn.datasets import load_digits
from sklearn.tree import export_graphviz
from six import StringIO
from IPython.display import Image  
import pydotplus
import re

data=pd.read_csv('tweet_basket_data.csv')
data['x1']=0
data['x2']=0
data['label']=0

for i in range(len(data)) :
    if re.search(".*(wage|Wage|pay|Pay|bonus|salary|salaries|wages|Wages).*", data.iloc[i,0]):
        data.iloc[i,2]=1
    elif re.search(".*(wage|Wage|pay|Pay|bonus|salary|salaries|wages|Wages).*", data.iloc[i,0]):
        data.iloc[i,2]=0


for i in range(len(data)):
    data.iloc[i,1]=len(data.iloc[i,0])
    if (len(data.iloc[i,0]))<=80:
        data.iloc[i,3]=1
    elif (len(data.iloc[i,0]))<=160:
        data.iloc[i,3]=2
    elif (len(data.iloc[i,0]))<=240:
        data.iloc[i,3]=3
    else: data.iloc[i,3]=4

data.to_csv('labeldata.csv',index=False)



    
        




