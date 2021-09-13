# -*- coding: utf-8 -*-
"""
Created on Sun Sep 12 18:57:05 2021

@author: Bruce
"""

import urllib.parse
import requests
import json
import pandas as pd

api_key='AIzaSyDWtNNb4qRz0Xpg3lk9aX-4MwF2eKj6SDA'
googlemap='https://maps.googleapis.com/maps/api/geocode/json?'
file=open('us-state-ansi-fips.csv')
csv=pd.read_csv(file)

filename=open('States_Geodata.txt','w')
filename.close()
for i in range(len(csv)):
    location=csv.loc[i,'stname']
    parameters=dict()
    parameters['address']=location
    parameters['key']=api_key
    url='https://maps.googleapis.com/maps/api/geocode/json?{}'.format(urllib.parse.urlencode(parameters))

    data=requests.get(url).text
    jsondata=json.loads(data)
    latitude = jsondata['results'][0]['geometry']['location']['lat']
    longitude = jsondata['results'][0]['geometry']['location']['lng']
    print('latitude', latitude, 'longtitude', longitude)
    address = jsondata['results'][0]['formatted_address']
    print(address)
    filename=open('States_Geodata.txt','a')
    filename.write(str(location))
    filename.write(', ')
    filename.write(str(latitude))
    filename.write(', ')
    filename.write(str(longitude))
    filename.write('\n')


filename.close()

    
        

