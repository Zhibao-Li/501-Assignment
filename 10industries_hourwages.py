# -*- coding: utf-8 -*-
"""
Created on Mon Sep 13 15:57:26 2021

@author: Bruce
"""
import requests
import json
import csv
outfile=open('outfile.csv','w',newline='')
writer=csv.writer(outfile)
header=['seriesID','year','period','value']
writer.writerow(header)
headers = {'Content-type': 'application/json'}

for i in ['CES2000000003','CES6500000003','CES5500000003','CES5000000003','CES7000000003',
          'CES3000000003','CES1000000003','CES8000000003','CES6000000003','CES4000000003']:
    para=json.dumps({"seriesid": [i],"startyear":"2016", "endyear":"2021",'registrationkey':'3695e7d859674190a85c7765117827d6'})
    p = requests.post('https://api.bls.gov/publicAPI/v2/timeseries/data/', data=para, headers=headers)
    json_data = json.loads(p.text)
    print(json.dumps(json_data,indent=4))

    for series in json_data['Results']['series']:
        seriesID = series['seriesID']
        for item in series['data']:
            year=item['year']
            period=item['period']
            wage_by_hour=item['value']
            row=[seriesID,year,period,wage_by_hour]
            writer.writerow(row)
           
outfile.close()
