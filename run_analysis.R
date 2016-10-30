#Download and unzip files 
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "data")
unzip("data", exdir = "./data")
filepath <- file.path("./data", "UCI HAR Dataset")
files <- list.files(filepath, recursive = TRUE)
files

#Read the downloaded files into R
library(data.table)

ActivityTest <- read.table(file.path(filepath, "test", "y_test.txt"), header = FALSE)
ActivityTrain <- read.table(file.path(filepath, "train", "y_train.txt"), header = FALSE)

SubjectTest <- read.table(file.path(filepath, "test", "subject_test.txt"), header = FALSE)
SubjectTrain <- read.table(file.path(filepath, "train", "subject_train.txt"), header = FALSE)

FeaturesTest <- read.table(file.path(filepath, "test", "X_test.txt"), header = FALSE)
FeaturesTrain <- read.table(file.path(filepath, "train", "X_train.txt"), header = FALSE)

#Preview of the files
str(ActivityTest)
str(ActivityTrain)
str(SubjectTest)
str(SubjectTrain)
str(FeaturesTest)
str(FeaturesTrain)

#merge the data tables using rbind
Subject <- rbind(SubjectTrain, SubjectTest)
Activity <- rbind(ActivityTrain, ActivityTest)
Features <- rbind(FeaturesTrain, FeaturesTest)

#Appropriately name the variables
SubjectID <- c("subject")
ActivityID <- c("activity")
FeaturesID <- read.table(file.path(filepath, "features.txt"), head = FALSE)
FeaturesID2 <- FeaturesID$V2

#Merge all the data columns with cbind
Alldata <- cbind(Subject, Activity)
alldata <- cbind(Features, Alldata)

#Extract only the mean and standard deviation from the feature names
subFeaturesID <- FeaturesID$V2[grep("mean\\(\\)|std\\(\\)", FeaturesID$V2)]

#Then subset the dataset by the selected feature names
subnames <- c(as.character(subFeaturesID), "subject", "activity")
finaldata <- subset(alldata, select = subnames)
str(finaldata)

#Read fullnames from the activity labels
activityLabels <- read.table(file.path(filepath, "activity_labels.txt"), header = FALSE)

#Rename the variables to more descriptive names
names(finaldata)<-gsub("^t", "time", names(finaldata))
names(finaldata)<-gsub("^f", "frequency", names(finaldata))
names(finaldata)<-gsub("Acc", "Accelerometer", names(finaldata))
names(finaldata)<-gsub("Gyro", "Gyroscope", names(finaldata))
names(finaldata)<-gsub("Mag", "Magnitude", names(finaldata))
names(finaldata)<-gsub("BodyBody", "Body", names(finaldata))

#create tidy dataset
library(plyr);
Data1<-aggregate(. ~subject + activity, finaldata, mean)
Data1<-Data1[order(Data1$subject,Data1$activity),]
write.table(Data1, file = "tidydata.txt",row.name=FALSE)
