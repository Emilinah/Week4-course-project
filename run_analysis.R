download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "data")
unzip("data", exdir = "./data")
filepath <- file.path("./data", "UCI HAR Dataset")
files <- list.files(filepath, recursive = TRUE)
files

library(data.table)

ActivityTest <- read.table(file.path(filepath, "test", "y_test.txt"), header = FALSE)
ActivityTrain <- read.table(file.path(filepath, "train", "y_train.txt"), header = FALSE)

SubjectTest <- read.table(file.path(filepath, "test", "subject_test.txt"), header = FALSE)
SubjectTrain <- read.table(file.path(filepath, "train", "subject_train.txt"), header = FALSE)

FeaturesTest <- read.table(file.path(filepath, "test", "X_test.txt"), header = FALSE)
FeaturesTrain <- read.table(file.path(filepath, "train", "X_train.txt"), header = FALSE)

str(ActivityTest)
str(ActivityTrain)
str(SubjectTest)
str(SubjectTrain)
str(FeaturesTest)
str(FeaturesTrain)

Subject <- rbind(SubjectTrain, SubjectTest)
Activity <- rbind(ActivityTrain, ActivityTest)
Features <- rbind(FeaturesTrain, FeaturesTest)

SubjectID <- c("subject")
ActivityID <- c("activity")
FeaturesID <- read.table(file.path(filepath, "features.txt"), head = FALSE)
FeaturesID2 <- FeaturesID$V2

Alldata <- cbind(Subject, Activity)
alldata <- cbind(Features, Alldata)

subFeaturesID <- FeaturesID$V2[grep("mean\\(\\)|std\\(\\)", FeaturesID$V2)]
subnames <- c(as.character(subFeaturesID), "subject", "activity")
finaldata <- subset(alldata, select = subnames)
str(finaldata)

activityLabels <- read.table(file.path(filepath, "activity_labels.txt"), header = FALSE)

names(finaldata)<-gsub("^t", "time", names(finaldata))
names(finaldata)<-gsub("^f", "frequency", names(finaldata))
names(finaldata)<-gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))

library(plyr);
Data1<-aggregate(. ~subject + activity, finaldata, mean)
Data1<-Data1[order(Data1$subject,Data1$activity),]
write.table(Data1, file = "tidydata.txt",row.name=FALSE)
