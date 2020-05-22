---
title: "CodeBook.md"
author: "Yashendu Joshi"
date: "5/22/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

# Coursera: Getting and Cleaning data  - Project

This codebook Contains metadata and explaination about variables, the data, and any transformations or work that was performed to clean up the data.

## I. Objective

The purpose of this project is to demonstrate ability to collect, work with, and clean a data set.This also includes writing an R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each       activity and each subject.

## II. Data Source

We will use below references for the data to be used in this project.

#### Project Description:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#### Data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


## III. run_analysis.R 

We will perform data cleaning using R functions, script will be available on this file. Below is the stepwise functionality and metadeta required to understand context of the script.

#### Step1: Downloading the data

We first download the reference data using the download function.


```

dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

zipfilepath <- "C://Users//Yashendu Joshi//Desktop//Kaggle//#Study//LearnR//GettingCleaningDataProject//Data//Dataset.zip"

download.file(dataURL, zipfilepath)

```

#### Step2: Unzip the datafile and save the source files

save the source files in usable format.


```

# Unzip the dataset
unzip(zipfile = ".//Data//Dataset.zip", exdir = ".//Data")

filepath <- ".//Data//UCI HAR Dataset"


### ----------------------- Reading Data from Files ----------------------------------------------------------------------

#create a list which has all file names
files = list.files(filepath, recursive=TRUE)
#show the files
files

```

#### Step3: read and merge train and test data

```

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


```
#### Step4: Calculate mean/ std dev and merge to existing dataset with activity labels

```
# Need step is to read all the values that are available
colNames = colnames(setAllInOne)
#Need to get a subset of all the mean and standards and the correspondongin activityID and subjectID 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
#A subtset has to be created to get the required dataset
setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

setWithActivityNames = merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

```
#### Step4: Finalize and write the tidy dataset to file "tidyData.txt"


```
# New tidy set has to be created 
secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]

#write the ouput to a text file 
write.table(secTidySet, "tidyData.txt", row.name=FALSE)

```
