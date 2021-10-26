##Step 2: Create Rules 
library(arules)
library(arulesViz)
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(plyr)
library(dplyr)
library(tidytext)
library(ggplot2)

#load this transaction data into an object of the transaction class
tr <- read.transactions('tweet_basket_data.csv', format = 'basket', sep=' ')
#Look some features of transaction object and  view the distribution of objects based on itemMatrix, in this case, i look top 20 frequent items 
summary(tr)
library(RColorBrewer)
itemFrequencyPlot(tr,topN=20,type="absolute",col=brewer.pal(8,'Pastel2'), main="Absolute Item Frequency Plot")
itemFrequencyPlot(tr,topN=20,type="relative",col=brewer.pal(8,'Pastel2'),main="Relative Item Frequency Plot")

#Generate basic apriori algorithm 
association.rules<- apriori(tr, parameter = list(supp=0.05,conf=0.8,maxlen=5))
inspect(association.rules[1:15])
##  SOrt by Conf
SortedRules_conf <- sort(association.rules, by="confidence", decreasing=TRUE)
inspect(SortedRules_conf[1:20])
## Sort by Sup
SortedRules_sup <- sort(association.rules, by="support", decreasing=TRUE)
inspect(SortedRules_sup[1:20])
## Sort by Lift
SortedRules_lift <- sort(association.rules, by="lift", decreasing=TRUE)
inspect(SortedRules_lift[1:20])

#remove subsets, also can extend or reduce the number of rules by change the value of min(sup) and min(conf) and maxlen
shorter.association.rules <- apriori(tr, parameter = list(supp=0.06, conf=0.9,maxlen=2))
subset.rules <- which(colSums(is.subset(shorter.association.rules ,shorter.association.rules )) > 1) # get subset rules in vector
length(subset.rules) 
subset.association.rules. <- shorter.association.rules[-subset.rules] # remove subset rules.
#look for the items that affect A, or look for the items that are affected by A. in this case, A is 'blacktwitt'
blacktwitt.association.rules1 <- apriori(tr, parameter = list(supp=0.05, conf=0.8,maxlen=3),appearance = list(default="lhs",rhs="blacktwitt"))
inspect(head(blacktwitt.association.rules1))
blacktwitt.association.rules2 <- apriori(tr, parameter = list(supp=0.05, conf=0.8,maxlen=3),appearance = list(lhs="blacktwitt",default="rhs"))
inspect(head(blacktwitt.association.rules2))

##Step3: Visualizing Association Rules
# Filter rules with confidence greater than 0.4 or 40%
subRules<-association.rules[quality(association.rules)$confidence>0.9]
top500subRules <- head(subRules, n = 500, by = "support")
#Plot top500SubRules
plot(subRules)
plot(subRules,method="two-key plot")
plot(top500subRules,method="matrix3D")
#interactive plots
plot(top500subRules,engine='plotly')
plot(top500subRules, method = "graph",  engine = "htmlwidget")
#save graph in graphml format
saveAsGraph(head(top500subRules, n = 500, by = "lift"), file = "rules.graphml")
#Individual Rule Representation(also called Parallel Coordinates Plot)
#in this case,  It shows that when I have 'CHILDS GARDEN SPADE PINK' and 'CHILDS GARDEN RAKE PINK' in my shopping cart, 
#I am likely to buy 'CHILDS GARDEN RAKE BLUE' along with these as well.
subRules2<-head(top500subRules, n=20, by="lift")
plot(subRules2, method="paracoord")











