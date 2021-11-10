library(DAAG)
library(party)
library(rpart)
library(rpart.plot)
library(mlbench)
library(caret)
library(pROC)
library(tree)

data<-read.csv('DT_R.csv')

# Tree Classification
#partition
set.seed(1000)
ind <- sample(2, nrow(data), replace = T, prob = c(0.5, 0.5))
train <- data[ind == 1,]
test <- data[ind == 2,]
tree <- rpart(recommended ~., data = train)
#original tree
rpart.plot(tree)
printcp(tree)
plotcp(tree)

p <- predict(tree, train, type = 'class')
confusionMatrix(p, train$recommended)

#ROC Visualization-test tree
p1 <- predict(tree, test, type = 'prob')
p1 <- p1[,2]
r <- multiclass.roc(test$recommended, p1, percent = TRUE)
roc <- r[['rocs']]
r1 <- roc[[1]]
plot.roc(r1,
         print.auc=TRUE,
         auc.polygon=TRUE,
         grid=c(0.1, 0.2),
         grid.col=c("green", "red"),
         max.auc.polygon=TRUE,
         auc.polygon.col="lightblue",
         print.thres=TRUE,
         main= 'ROC Curve')

###Regression Tree
#tree and prune
tree <- rpart(overall_rating ~., data = train)
rpart.plot(tree)
printcp(tree)
rpart.rules(tree)
plotcp(tree)
#evaluate test data
p <- predict(tree, test)
sqrt(mean((test$overall_rating-p)^2))
(cor(test$overall_rating,p))^2

###text tree
#original tree
tree.recommended = tree(recommended~., data=train)
summary(tree.recommended)
plot(tree.recommended)
text(tree.recommended, pretty = 0)
tree.recommended
#evaluate test tree
tree.pred = predict(tree.recommended, test, type="class")
with(test, table(tree.pred,recommended))
#original tree correct rate:(133+81)/230

#Prune tree
cv.recommended = cv.tree(tree.recommended, FUN = prune.misclass)
cv.recommended
plot(cv.recommended)
prune.recommended = prune.misclass(tree.recommended, best = 2)
plot(prune.recommended)
text(prune.recommended, pretty=0)
#evaluate test tree
tree.pred = predict(prune.recommended, test, type="class")
with(test, table(tree.pred,recommended))
#prune tree correct rate: (133+81)/230



