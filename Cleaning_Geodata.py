# -*- coding: utf-8 -*-
"""
Created on Tue Sep 28 10:14:46 2021

@author: Bruce
"""

import urllib.parse
import requests
import json
import pandas as pd
import re


filename=open('Original_States_Geodata.txt','r')
data = filename.read()
s=re.sub(r'"status" : "OK"\n}',r'"status" : "OK"\n}\n\n\n',data)
s=re.split(r'\n\n\n',s)

file=open('Cleaned_States_Geodata.txt','w')
file.close()

for i in range(len(s)-1):
    jsondata=json.loads(s[i])
    latitude = jsondata['results'][0]['geometry']['location']['lat']
    longitude = jsondata['results'][0]['geometry']['location']['lng']
    print('latitude', latitude, 'longtitude', longitude)
    address = jsondata['results'][0]['formatted_address']
    print(address)
    file=open('Cleaned_States_Geodata.txt','a')
    file.write(str(address))
    file.write(', ')
    file.write(str(latitude))
    file.write(', ')
    file.write(str(longitude))
    file.write('\n')

file.close()
filename.close()


