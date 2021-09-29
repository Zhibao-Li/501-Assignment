# -*- coding: utf-8 -*-
"""
Created on Tue Sep 28 07:55:54 2021

@author: Bruce
"""
import pandas as pd
import numpy as np
import csv
from sklearn.feature_extraction.text import CountVectorizer
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
import matplotlib.pyplot as plt
from PIL import Image

##Add headers and delete unrelated columns
file=pd.read_csv('Wage_Articles_NewYorkTimes.csv',header=None)
file.columns=['id','website','published_date','keywords']
del file['id']
keywords=file['keywords']

##Tokenizing keywords using CountVectorizer
corpus=[]
for i in range(len(keywords)):
    corpus.append(keywords.loc[i])
pattern = "(?u)\\b[\\w-]+\\b" #don't separate hyphenated words while tokenization
vectorizer=CountVectorizer(corpus,stop_words='english',token_pattern=pattern)
vector=vectorizer.fit_transform(corpus)
count_array=vector.toarray()
# print('the shape is:',vector.shape)
# print(vectorizer.vocabulary_) show positional index in the sparse matrix
df = pd.DataFrame(data=count_array,columns = vectorizer.get_feature_names()) ##convert matrix to dataframe
print(df)
df.to_csv('Cleaned_Keywords_NewYorkTimes.csv')

##Create WordCloud
doc_counts=sum(count_array)
doc_words = np.array(vectorizer.get_feature_names())
frequencies = dict(zip(doc_words, doc_counts))
dove_mask = np.array(Image.open("download.png"))
wordcloud = WordCloud(background_color="white", 
                      mask=dove_mask,
                      contour_width=3, 
                      repeat=True,
                      min_font_size=3,
                      contour_color='darkgreen').fit_words(frequencies)
plt.imshow(wordcloud)
plt.axis("off")
plt.show()
