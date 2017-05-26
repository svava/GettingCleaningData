##run_analysis.R 
## Author Svava Bragason
## May 26,2017
## from the data
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## You should create one R script called run_analysis.R that does the following. 
## 1.	Merges the training and the test sets to create one data set.
## 2.	Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3.	Uses descriptive activity names to name the activities in the data set
## 4.	Appropriately labels the data set with descriptive variable names. 
## 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## First download the source data. This is going to run in the default directory
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destfile <- "UCI_HAR_Dataset.zip"
## Need to set the download method to binary
download.file(fileURL, destfile, mode = "wb")

##Load data.table library and dplyr libraries
library(data.table)
library(dplyr)

# Create a name for the directory where we'll unzip
tempdir <- tempfile()

# Create the directory using that name
dir.create(tempdir)

# Unzip the file into the dir
unzip(destfile, exdir=tempdir)


## Now load the feature_labels from the features.txt file within the zip archive
pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "features.txt"))
feature_labelsDT <- fread(pathtofile)

##Load the master ActivityLabels
pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "activity_labels.txt"))
activity_labelsDT <- fread(pathtofile)

## Now start loading the data files
##Load Test Subject Labels
pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "test", "subject_test.txt"))
test_subjectsDT <- fread(pathtofile)

##Load Train Subject Labels
pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "train", "subject_train.txt"))
train_subjectsDT <- fread(pathtofile)


##Load Test Activity Labels
pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "test", "y_test.txt"))
test_activitiesDT <- fread(pathtofile)

##Load Train Activity Labels
pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "train", "y_train.txt"))
train_activitiesDT <- fread(pathtofile)

##LoadTestData
pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "test", "X_test.txt"))
testDT <- fread(pathtofile)

##Load Train Data
pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "train", "X_train.txt"))
trainDT <- fread(pathtofile)

##Merge the test and train subjects while keeping order by using rbind
subjectsDT <- rbind(test_subjectsDT,train_subjectsDT)



## Clean up the interim objects
rm("test_subjectsDT")
rm("train_subjectsDT")


##Merge the activities files
activitiesDT <- rbind(test_activitiesDT, train_activitiesDT)





##Merge the data files
DT <- rbind(testDT, trainDT)

## Give the subjects a subject column name
names(subjectsDT) <- c("subject")

## Give the activities a activity_id column name
names(activitiesDT) <- c("act_id")

## Clean up the interim objects
rm("test_activitiesDT")
rm("train_activitiesDT")

##Add some more column names

names(subjectsDT) <- c("subject")
names(activity_labelsDT) <- c("act_id","activity")
names(feature_labelsDT) <- c("feature_id","feature_label")


##DTColumnNames
##Apply the feature labels from the feature_labels data table to the DT column names
names(DT) <- feature_labelsDT$feature_label


##Join all the sets together
fullDT <- cbind(subjectsDT, activitiesDT,DT )

## clean up
rm("subjectsDT")
rm("activitiesDT")
rm("DT")
("feature_labelsDT")
rm("testDT")
rm("trainDT")

## OK, now to subset only the mean and standard variables
## Using regular expression, take all the variables including mean() or std() in their names
## Note that we need to use the double escape character \\ before each parens
meanDT <- subset(fullDT, select = grep("subject|act_id|mean\\(\\)|std\\(\\)", names(fullDT)))



## inner_join will find the activity_id columns
##meanActivityDT <- meanDT[activity_labelsDT, nomatch = 0L, on="act_id"]
meanActivityDT <- activity_labelsDT[meanDT, nomatch = 0L, on="act_id"]

## get rid of act_id column
meanActivityDT [,c("act_id")] <- NULL

## clean up intermediate file
rm("activity_labelsDT")
rm("meanDT")
## rm("fullDT")


#remove special characters from column names
names(meanActivityDT) <-gsub("[[:punct:]]","",names(meanActivityDT))

# Capitalize Std and Mean
names(meanActivityDT) <-gsub("std","Std",names(meanActivityDT))
names(meanActivityDT) <-gsub("mean","Mean",names(meanActivityDT))



## Group by subject and country 
meanActivityDT <- meanActivityDT  %>% group_by(subject, activity)
## Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidydata <- meanActivityDT %>% summarize_all(mean)


## Write output file
pathtofile <- normalizePath(file.path(tempdir,"tidydata.txt"))
fwrite(tidydata, file = pathtofile)

## load and view the output
data <- read.table(pathtofile, header = TRUE) 
     View(data)
     
     
## The following code was used to help generate the content of the CodeBook.md file. The top part of the file was typed manually.
  ## Then, the content from output.txt was pasted in
     features <- names(meanActivityDT)
     features <- data.table(features)
     names(features)<- c("desc")
     features <- transform(features, feature_desc  = ifelse(grepl("Mean", features$desc), "Mean value of the ", ""))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Std", features$desc), "Standard Deviation of the ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Gyro", features$desc), "Angular ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Mag", features$desc), "Magnitude of the ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Jerk", features$desc), "Jerk of the ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Body", features$desc), "Body ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Gravity", features$desc), "Gravity ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Acc", features$desc), "Acceleration ", "")))
     
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("^t", features$desc), "time domain ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("^f", features$desc), "frequency domain ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("^t|^f", features$desc), "signal ", "")))
    
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("X", features$desc), "on the x axis of the phone ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Y", features$desc), "on the y axis of the phone ", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("Z", features$desc), "on the z axis of the phone ", "")))
     
  
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("^t|^f", features$desc), "normalized and bounded within [-1,1].", "")))
 
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("subject", features$desc), "One of a group of 30 volunteers within an age bracket of 19-48 years who performed the activities in the experiment. 
                                                                                 Range is from 1 to 30 denoting each different test subject.", "")))
     features <- transform(features, feature_desc  = paste0(feature_desc, ifelse(grepl("activity", features$desc), "Activity of daily living (ADL) performed while carrying a waist-mounted smartphone with embedded inertial sensors. 
                                                                                 LAYING
                                                                                 SITTING
                                                                                 STANDING
                                                                                 WALKING
                                                                                 WALKING_DOWNSTAIRS
                                                                                 WALKING_UPSTAIRS
                                                                                 ", "")))
     
    fileConn<-file("output.txt")
     
     names(features)<- c("Data Dictionary", "Tidy Data from UCI HAR Dataset")
     
     
     
     ##Note that the HTML breaks are being generated in the separators
     write.table(features, file = fileConn, append = TRUE, quote = FALSE, sep = " \n <BR>",
                 eol = "\r\n \r\n", na = "NA", dec = ".", row.names = FALSE,
                 col.names = TRUE, qmethod = c("escape"),
                 fileEncoding = "")
     
