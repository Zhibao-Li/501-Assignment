library(httr)
library(jsonlite)
library(urltools)

for (i in 1:30){
origin<-'https://api.nytimes.com/svc/search/v2/articlesearch.json?q=salary&api-key=bNZo0nAD5O1L1B4tRhGNJZ7xAnT05aST'
url<-param_set(origin,key='page',value=i)
res<-GET(url)
js<-rawToChar(res$content)
data<-fromJSON(js)

keyword<-data$response$docs$keywords
web_url<-data$response$docs$web_url
pub_date<-data$response$docs$pub_date

Top_keywords=c()
for (i in c(1:10)){
  words<-data.frame(keyword[i])$value[1]
  Top_keywords<-append(Top_keywords,words)
}

row<-data.frame(web_url,pub_date,Top_keywords,stringsAsFactors = FALSE)
if (i==1){write.append(row,'Wage_Articles_NewYorkTimes.csv',append = TRUE,sep = ",",col.names=TRUE)}
else{write.table(row,'Wage_Articles_NewYorkTimes.csv',append = TRUE,sep = ",",col.names=FALSE)}
}


