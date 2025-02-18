# PRACTICAL MACHINE LEARNING
# Course Project

## Background

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement ??? a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it. In this project, your goal will be to use data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset).


## Data

The training data for this project are available here: 

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here: 

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

The data for this project comes from this original source: http://groupware.les.inf.puc-rio.br/har. They have been very generous in allowing their data to be used for this kind of assignment.

The main objective is to perform classification ie predict a categorical variable. Random Forests represent a powerful algorithm in this cases.

## Prep Loads

```r
library(caret)
library(kernlab)
library(randomForest)
#library(corrplot)
library(RCurl)
library(xtable)
set.seed(881014)
```

## Get data: train and test data sets.


```r
#file1 <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
#file2 <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

#data <- getURL(file1, ssl.verifypeer=0L, followlocation=1L)
#data <- getURL(file2, ssl.verifypeer=0L, followlocation=1L)

#writeLines(data,'pml-training.csv')
#writeLines(data,'pml-test.csv')

data_train<-read.csv('pml-training.csv',na.strings= c("NA",""," "))
data_test <- read.csv("pml-test.csv", na.strings= c("NA",""," "))
```

## Clean data, removing cols with NA's and other index vars


```r
data_train_NAs <- apply(data_train, 2, function(x)sum(is.na(x)))
data_train_clean <- data_train[,which(data_train_NAs == 0)]

data_test_NAs <- apply(data_test, 2, function(x) {sum(is.na(x))})
data_test_clean <- data_test[,which(data_test_NAs == 0)]

data_train_clean <- data_train_clean[8:length(data_train_clean)]
data_test_clean <- data_test_clean[8:length(data_test_clean)]
```
## Slice Data

Slicing training data 70% for training the model, 30% for cross validation


```r
indexTrain <- createDataPartition(y = data_train_clean$classe, p = 0.7, list = FALSE)
train <- data_train_clean[indexTrain, ]
cross <- data_train_clean[-indexTrain, ]
```

## Fit data and crossvalidation


```r
model <- randomForest(classe ~ ., data = train)

# crossvalidate model
predictCross <- predict(model, cross)

confusionMatrix(cross$classe, predictCross)[3]
```

```
## $overall
##       Accuracy          Kappa  AccuracyLower  AccuracyUpper   AccuracyNull 
##         0.9947         0.9933         0.9925         0.9964         0.2851 
## AccuracyPValue  McnemarPValue 
##         0.0000            NaN
```

It can be observed that Accuracy is at 99.47% with the crossvalidation set so out of sample error estimate is at 0.53%. 

## Predict new data!

```r
predict(model, data_test_clean)
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```
