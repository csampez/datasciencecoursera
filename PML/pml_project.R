library(caret)
library(kernlab)
library(randomForest)
library(corrplot)
library(RCurl)

#get data
file1 <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
file2 <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(file1, destfile = "./pml-training.csv")
download.file(file2, destfile = "./pml-testing.csv")

data <- getURL(file1, ssl.verifypeer=0L, followlocation=1L)
writeLines(data,'pml-training.csv')
data_train<-read.csv('pml-training.csv',na.strings= c("NA",""," "))

data <- getURL(file2, ssl.verifypeer=0L, followlocation=1L)
writeLines(data,'pml-test.csv')
data_test <- read.csv("pml-test.csv", na.strings= c("NA",""," "))

# clean data, removing cols
data_train_NAs <- apply(data_train, 2, function(x)sum(is.na(x)))
data_train_clean <- data_train[,which(data_train_NAs == 0)]
data_test_NAs <- apply(data_test, 2, function(x) {sum(is.na(x))})
data_test_clean <- data_test[,which(data_test_NAs == 0)]

data_train_clean <- data_train_clean[8:length(data_train_clean)]
data_test_clean <- data_test_clean[8:length(data_test_clean)]

# slice data
inTrain <- createDataPartition(y = data_train_clean$classe, p = 0.7, list = FALSE)
train <- data_train_clean[inTrain, ]
cross <- data_train_clean[-inTrain, ]

# correlation matrix
correlMatrix <- cor(train[, -length(train)])
corrplot(correlMatrix, order = "FPC", method = "square", type = "upper", tl.cex = 0.8,  tl.col = rgb(0, 0, 0))

# fit data
model <- randomForest(classe ~ ., data = train)

# crossvalidate model
predictCross <- predict(model, cross)
confusionMatrix(cross$classe, predictCross)

# predict test
predictTest <- predict(model, data_test_clean)