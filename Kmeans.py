# -*- coding: utf-8 -*-
"""
Created on Mon Oct 11 16:55:52 2021

@author: Bruce
"""
import os
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from wordcloud import WordCloud, STOPWORDS, ImageColorGenerator
from PIL import Image

X=pd.read_csv('Cleaned_Keywords_NewYorkTimes.csv')
try: del X['Unnamed: 0']
except: pass
inertia=list()
for i in range(2,5):
    model=KMeans(n_clusters=i,init='k-means++',random_state=0).fit(X)
    inertia.append(model.inertia_)
plt.figure(1)
plt.bar(range(2,5),inertia)
plt.title('K-means result in different clusters')
plt.xlabel('n_clusters')
plt.ylabel('inertia value')
plt.show()

##DiscussionL: From this graph, we could see that when number of clusters is 4, the inertia is the lowest. It means 4 cluster model fits the original data best. 

##WordCloud

labels=model.predict(X)
X['label']=labels
for i in range(0,4):
    index=X['label']==i
    df=X.loc[index,]
    doc_counts=sum(df.values)
    doc_words=np.array(df.columns.values)
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

#%%
from scipy.cluster.hierarchy import dendrogram
from sklearn.cluster import AgglomerativeClustering

def plot_dendrogram(model, **kwargs):

    counts = np.zeros(model.children_.shape[0])
    n_samples = len(model.labels_)
    for i, merge in enumerate(model.children_):
        current_count = 0
        for child_idx in merge:
            if child_idx < n_samples:
                current_count += 1  # leaf node
            else:
                current_count += counts[child_idx - n_samples]
        counts[i] = current_count

    linkage_matrix = np.column_stack([model.children_, model.distances_,
                                      counts]).astype(float)

# Plot the dendrogram
    dendrogram(linkage_matrix, **kwargs)



model = AgglomerativeClustering(distance_threshold=0, n_clusters=None)

model = model.fit(X)
plt.title('Hierarchical Clustering Dendrogram')
# plot the top three levels of the dendrogram
plot_dendrogram(model, truncate_mode='level', p=3)
plt.xlabel("Number of points in node")
plt.show() 

#%%
from sklearn.cluster import DBSCAN
from sklearn import metrics
from sklearn.preprocessing import StandardScaler


model=KMeans(n_clusters=3,init='k-means++',random_state=0).fit(X)
labels_true=model.predict(X)
X = StandardScaler().fit_transform(X)

### Compute DBSCAN
db = DBSCAN(eps=0.3, min_samples=10).fit(X)
core_samples_mask = np.zeros_like(db.labels_, dtype=bool)
core_samples_mask[db.core_sample_indices_] = True
labels = db.labels_


n_clusters_ = len(set(labels)) - (1 if -1 in labels else 0)
n_noise_ = list(labels).count(-1)

print('Estimated number of clusters: %d' % n_clusters_)
print('Estimated number of noise points: %d' % n_noise_)
print("Homogeneity: %0.3f" % metrics.homogeneity_score(labels_true, labels))
print("Completeness: %0.3f" % metrics.completeness_score(labels_true, labels))
print("V-measure: %0.3f" % metrics.v_measure_score(labels_true, labels))
print("Adjusted Rand Index: %0.3f"
      % metrics.adjusted_rand_score(labels_true, labels))
print("Adjusted Mutual Information: %0.3f"
      % metrics.adjusted_mutual_info_score(labels_true, labels))
print("Silhouette Coefficient: %0.3f"
      % metrics.silhouette_score(X, labels))

#Plot
import matplotlib.pyplot as plt


unique_labels = set(labels)
colors = [plt.cm.Spectral(each)
          for each in np.linspace(0, 1, len(unique_labels))]
for k, col in zip(unique_labels, colors):
    if k == -1:
        # Black used for noise.
        col = [0, 0, 0, 1]

    class_member_mask = (labels == k)

    xy = X[class_member_mask & core_samples_mask]
    plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=tuple(col),
             markeredgecolor='k', markersize=14)

    xy = X[class_member_mask & ~core_samples_mask]
    plt.plot(xy[:, 0], xy[:, 1], 'o', markerfacecolor=tuple(col),
             markeredgecolor='k', markersize=6)

plt.title('Estimated number of clusters: %d' % n_clusters_)
plt.show()






