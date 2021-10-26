##Step1: Gather, Clean and prepare transaction data
library(rtweet)
library(ggplot2)
library(dplyr)
library(tidytext)
library(tm)          # text mining package
library(SnowballC)   # applies stemmming algorithm
library(magrittr)    # allows pipe operator

appname <- "Bruce_zl424"
key <- "DzX5dUb7odZAvWGOSpvg0Hrmz"
secret <- "BgrPToghCCw5Egnfcye4OEP7IB9hlS8nxSeZ7INag5OjLrjcHW"
access_token<-'1435735219395432448-1SKeye1nDZpeIWHgR9rg7NBYsGJY6m'
access_secret<-'CXUhmQJkJSIa2hTs5XHpr50tYoFKP1djrgCa6LBVKTGIS'
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)
#search for 1000 tweets using the #wage hashtag
rstats_tweets <- search_tweets(q = "#wage",
                               n = 1000)

#convert to corpus structure and remove stop words using tm package
my_corpus <- VCorpus(VectorSource(rstats_tweets$text))
getTransformations()
my_corpus <- tm_map(my_corpus, removePunctuation)
my_corpus <- tm_map(my_corpus, removeNumbers)
my_corpus <- tm_map(my_corpus, removeWords, c(stopwords("english"),'wage','wages'))
my_corpus <- tm_map(my_corpus,content_transformer(tolower))
my_corpus <- tm_map(my_corpus, stripWhitespace)
my_corpus <- tm_map(my_corpus, stemDocument)
#convert corpus to dataframe and write file into csv
tweet <- data.frame(text=unlist(sapply(my_corpus, `[`, "content")), 
                    stringsAsFactors=F)
write.csv(tweet,"tweet_basket_data.csv", quote = FALSE, row.names = FALSE)
