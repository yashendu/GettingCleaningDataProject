library(dplyr)

###------------------------- Downloading and Unzipping dataset -----------------------------------------------------------

dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

zipfilepath <- "C://Users//Yashendu Joshi//Desktop//Kaggle//#Study//LearnR//GettingCleaningDataProject//Data//Dataset.zip"

download.file(dataURL, zipfilepath)

# Unzip the dataset
unzip(zipfile = ".//Data//Dataset.zip", exdir = ".//Data")

filepath <- ".//Data//UCI HAR Dataset"


### ----------------------- Reading Data from Files ----------------------------------------------------------------------

#create a list which has all file names
files = list.files(filepath, recursive=TRUE)
#show the files
files


### 1. Output Steps - Here we begin how to create the data set of training and test
#Reading training tables - xtrain / ytrain, subject train
xtrain = read.table(file.path(filepath, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(filepath, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(filepath, "train", "subject_train.txt"),header = FALSE)
#Reading the testing tables
xtest = read.table(file.path(filepath, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(filepath, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(filepath, "test", "subject_test.txt"),header = FALSE)
#Read the features data
features = read.table(file.path(filepath, "features.txt"),header = FALSE)
#Read activity labels data
activityLabels = read.table(file.path(filepath, "activity_labels.txt"),header = FALSE)


#Create Sanity and Column Values to the Train Data
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#Create Sanity and column values to the test data
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"
#Create sanity check for the activity labels value
colnames(activityLabels) <- c('activityId','activityType')


#Merging the train and test data - important outcome of the project
mrg_train = cbind(ytrain, subject_train, xtrain)
mrg_test = cbind(ytest, subject_test, xtest)
#Create the main data table merging both table tables - this is the outcome of 1
setAllInOne = rbind(mrg_train, mrg_test)


# Need step is to read all the values that are available
colNames = colnames(setAllInOne)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

# New tidy set has to be created 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#write the ouput to a text file 
write.table(secTidySet, "tidyData.txt", row.name=FALSE)

