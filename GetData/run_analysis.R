#This script 
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Library Request
library(plyr)
library(dplyr)
library(reshape2)
library(data.table)

#Checks if data is already downloaded 
if (!file.exists("getdata-projectfiles-UCI HAR Dataset.zip")) {
	download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
		"getdata-projectfiles-UCI HAR Dataset.zip", method="curl")
}

if (!file.exists("UCI HAR Dataset")) unzip("getdata-projectfiles-UCI HAR Dataset.zip") 

#Set filenames
parent<-"UCI HAR Dataset/"
data_set<-c("train", "test")
subject_files<-paste0(parent,data_set,"/subject_",data_set,".txt")
feature_files<-paste0(parent,data_set,"/X_",data_set,".txt",sep="")
activity_files<-paste0(parent,data_set,"/y_",data_set,".txt",sep="")

#Reading labels
feature_lab<-read.table(paste0(parent,"features.txt", sep=""))[,2]
activity_lab<-read.table(paste0(parent,"activity_labels.txt", sep=""))
names(activity_lab)<-c("activity_code","activity_name")

#Loading subject and feature data
subject_data <- do.call("rbind.fill",lapply(subject_files,function(x)read.table(x,col.names="subject")))
feature_data <- do.call("rbind.fill",lapply(feature_files,read.table))
names(feature_data) <- feature_lab

#feature selection
feats_selec <-as.character(feature_lab[grepl('mean\\(\\)|std\\(\\)',feature_lab)])
feature_data_selec <- feature_data[,feats_selec]

#Loading activity data
activity_data <- do.call("rbind.fill",lapply(activity_files,read.table))
names(activity_data) <- "activity_code"

#Joining activity label
activity_data$activity_code<-factor(activity_data$activity_code)
activity_data_join <- join(activity_data,activity_lab, by="activity_code")

#Binding features (X) and activity (y) 
data_binded <- cbind(feature_data_selec, activity_data_join, subject_data)

#Metal Transformation
melt_data <- melt(data_binded, id=c("subject", "activity_name"), measure.vars=feats_selec)
cast_data <- dcast(melt_data, activity_name + subject ~ variable, mean)

#Tidy Data Set
tidy_data <- cast_data[order(cast_data$subject, cast_data$activity_name),]    

tidy_data <- tidy_data[,c(2,1,3:length(names(tidy_data)))]

#Reindex Rows and move Subject to Column 1
rownames(tidy_data) <- 1:nrow(tidy_data)


#Output File
write.table(tidy_data,file="tidy_dataset.txt", row.names=FALSE)
