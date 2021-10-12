#install.packages('factoextra')
library(tidyverse)
library('factoextra')
library(ggpubr)
data<-read.csv('Cleaned_industry_wages.csv',na.string=c(''))
names(data)[1]<-'ID'
data<-aggregate(data,by=list(data$ID,data$year),FUN=mean, na.rm=TRUE)
data<-data %>% select(2,8)
#data detection
str(data)
summary(data)
any(is.na(data))
origin<-data
data <- scale(data) # standardize variables

ntk <- (nrow(data)-1)*sum(apply(data,2,var))
# Determine number of clusters
for (i in 1:10) ntk[i] <- sum(kmeans(data,centers=i)$withinss)
plot(1:10, ntk, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares")

#Discussion: From this graph, we could know 4 clusters would be better to fit the original data
fit <- kmeans(data, 4,nstart=25) 
print(fit)
# get cluster means
aggregate(origin,by=list(fit$cluster),FUN=mean)
# append cluster assignment
mydata <- data.frame(origin, fit$cluster)
fit$tot.withinss

#Visualization K-means
fviz_cluster(fit, data = origin,
             palette = c("#2E9FDF", "#00AFBB", "#E7B800",'red'), 
             geom = "point",
             ellipse.type = "convex", 
             ggtheme = theme_bw()
             )

## Ward Hierarchical Clustering and Plotting
d <- dist(data, method = "euclidean") # distance matrix
fit <- hclust(d, method="ward")
cut_ward <- cutree(fit, k=4) # cut tree into 4 clusters
plot(fit)

# Rectangular box and cut line plotting
rect.hclust(fit, k=4, border = 2:5)
abline(h = 4, col = 'red') #plot cut line

# Different colors plotting
library(dendextend)
ward_dend_obj <- as.dendrogram(fit)
ward_col_dend <- color_branches(ward_dend_obj, h = 4)
plot(ward_col_dend)

# Merge cluster with original data and plot it in line plot
library(dplyr)
data_with_labels <- mutate(origin, cluster = cut_ward)
names(data_with_labels)[1]<-'year'
count(data_with_labels,cluster)
library(ggplot2)
ggplot(data_with_labels, aes(x=year, y = Annual_wage, color = factor(cluster))) + geom_point()






