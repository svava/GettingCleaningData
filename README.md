---
title: "README.md"
author: "Svava Bragason"
date: "May 26, 2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
<p> </p>


This is the README.md file for the Getting and Cleaning Data Final Assignment. As part of this assignment, the following files are included:
<p> </p>

<table border = 1>
 <tr >
  <th >
  <p align=center > <b> File </b> </p>
  </th>
   <th >
  <p align=center > <b>  Description </b> </p>

  </th>
 </tr>
 <tr >
  <td >
  <p '> README.md </p>
  </td>
  <td >
  <p > A file in markdown format that disolays when someone accesses the GitHub repository for a person's submission for the course project. The file is located at github.com/svava </p>
  </td>
 </tr>
  <tr >
  <td >
  <p '> CodeBook.md </p>
  </td>
  <td >
  <p > A file in markdown format that describes the variables (columns) contained in the tidy data set that must be uploaded to the coursera website as part of the project submission process. The file is located at ...... </p>
  </td>
 </tr>
  <tr >
  <td >
  <p > run_analysis.R </p>
  </td>
 <td >
   <p >An R script that contains all of the R functions used to transform the eight input data files into the required formats for steps 4 and 5 of the assignment instructions. </p>
  </td>
 </tr>
</table>


<p> </p>
<p> </p>

 Another file, the output from step 5 listed in "The Data Cleansing Task" should be uploaded to the Coursera website as part of the assignment submission. I have included this tidydata.txt file as well in the GitHub repository for easy reference.


<table border = 1>
 <tr >
  <th >
  <p align=center > <b> File </b> </p>
  </th>
   <th >
  <p align=center > <b>  Description </b> </p>

  </th>
 </tr>
 <tr >
  <td >
  <p '> tidydata.txt </p>
  </td>
  <td >
  <p > A file of tidy data created from the UCI HAR dataset using the run_analysis.R script. The file is located at https://github.com/svava/GettingCleaningData </p>
  </td>
 </tr>
  <tr >
  <td >
  <p '> CodeBook.md </p>
  </td>
  <td >
  <p > A file in markdown format that describes the variables (columns) contained in the tidy data set that must be uploaded to the coursera website as part of the project submission process. https://github.com/svava/GettingCleaningData </p>
  </td>
 </tr>
  <tr >
  <td >
  <p > run_analysis.R </p>
  </td>
 <td >
   <p >An R script that contains all of the R functions used to transform the eight input data files into the required formats for steps 4 and 5 of the assignment instructions. </p>
  </td>
 </tr>
</table>


### Dataset use disclosure
Original data was obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Use of this dataset  is acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

## Tidy Data
According to the Tidy Data paper by Hadley Wickham (http://vita.had.co.nz/papers/tidy-data.pdf), there are four components of tidy data:
1. Each measured variable forms a column
2. Each different observation of variables forms a row
3. Each type of observational unit forms a table
4. If there are multiple tables, they should include a column in the table which allows them to be linked.

Additionally, there should be:

* a row including the variable names at the top of each file
* human readable variable names
* data should be saved in one file per table



## Steps performed in the run_analysis.R 

### 1. Dataset download and extraction
Zipped dataset is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to a local temporary file location, and then files are extracted using unzip function from zip to a temporary directory called tempdir.

### 2. Load data.table and dplyr libraries
The data.table library is used for flexible and quick manipulation of data. The dplyr library is used for chaining commands.
<p> </p>

### 3. Load source data files to data tables
The metadata files feature labels and  activity labels are loaded respectively to master data.tables feature_labelsDT and activity_labelsDT using normalized file paths and fread().


The remaining source data file paths corresponding to the experiment data are assigned to a pathtofile variable and loaded into data tables using fread().


pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "test", "subject_test.txt"))
test_subjectsDT <- fread(pathtofile)

pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "train", "subject_train.txt"))
train_subjectsDT <- fread(pathtofile)


pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "test", "y_test.txt"))
test_activitiesDT <- fread(pathtofile)


pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "train", "y_train.txt"))
train_activitiesDT <- fread(pathtofile)


pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "test", "X_test.txt"))
testDT <- fread(pathtofile)


pathtofile <- normalizePath(file.path(tempdir,"UCI HAR Dataset", "train", "X_train.txt"))
trainDT <- fread(pathtofile)

###Merge the test and activity data into single sets
Starting with subjects, merge the test_subjectsDT and train_subjectsDT into subjectsDT:

subjectsDT <- rbind(test_subjectsDT,train_subjectsDT)



Merge the activities files test_activitiesDT, train_activitiesDT into activitiesDT:
<p>
activitiesDT <- rbind(test_activitiesDT, train_activitiesDT)

Merge the measurements data files testDT and trainDT into DT:
DT <- rbind(testDT, trainDT)

### Assign column names to the files. 
We will need column names for easier manipulation and selection of the correct variables.
First we calls the observation subjects "subject"
names(subjectsDT) <- c("subject")



Now we give the observation activities a activity_id column name
names(activitiesDT) <- c("act_id")

Then we add some more column names to the activity and feature labels

names(activity_labelsDT) <- c("act_id","activity")
names(feature_labelsDT) <- c("feature_id","feature_label")

### Clean up the interim objects from the workspace
rm("test_subjectsDT")
rm("train_subjectsDT")
rm("test_activitiesDT")
rm("train_activitiesDT")



### Apply the feature labels from the feature_labels data table to the DT column names
names(DT) <- feature_labelsDT$feature_label


### Join all the sets together using cbind
fullDT <- cbind(subjectsDT, activitiesDT,DT )

### clean up
rm("subjectsDT")
rm("activitiesDT")
rm("DT")

### Subset only the mean and standard variables
Using regular expression, select the subject, activity, and all the measurements on the mean and standard deviation for each measurement, take all the variables including "mean()" or "std()" in their names, according to features_info.txt the "mean()" variables denote the Mean value and the "std()"  variables show  Standard deviation.


## OK, now to subset only the mean and standard variables
## Using regular expression, take all the variables including mean() or std() in their names
## Note that we need to use the double escape character \\\\ before each parens
meanDT <- subset(fullDT, select = grep("subject|act_id|mean\\(\\)|std\\(\\)", names(fullDT)))

### Inner join on act_id column
meanActivityDT <- activity_labelsDT[meanDT, nomatch = 0L, on="act_id"]

### Remove act_id column
meanActivityDT [,c("act_id")] <- NULL

### clean up intermediate file
rm("activity_labelsDT")
rm("meanDT")


### Make the column names to make them more human readable
First, I removed the special punctuation characters to make it easier to reference the column names without using escape characters or generating syntax errors.
names(meanActivityDT) <-gsub("[[:punct:]]","",names(meanActivityDT))

I capitalized Std and Mean to make these more easily human readable
I did not further manipulate the variable names in the tidy data set, already these variable names are on the longer side, and full descriptions of each variable are available in the CodeBook.md file
names(meanActivityDT) <-gsub("std","Std",names(meanActivityDT))
names(meanActivityDT) <-gsub("mean","Mean",names(meanActivityDT))



### Group by subject and country 
meanActivityDT <- meanActivityDT  %>% group_by(subject, activity)
### Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidydata <- meanActivityDT %>% summarize_all(mean)

### Write output file
pathtofile <- normalizePath(file.path(tempdir,"tidydata.txt"))
fwrite(by_Activity, file = pathtofile)

### Display the tidy data file
Tidy data as per the ReadMe that can be read into R with read.table(header=TRUE). 



Use the below code to preview the tidydata text file in R:
```

pathtofile <- https://github.com/svava/GettingCleaningData/blob/master/tidydata.txt
data <- read.table(pathtofile, header = TRUE) 
     View(data)

```
## Create the codebook
The final part of the run_analysis.R file contains the code which was used to help automate the descriptions of the feature variables for the codebook. The column names were added to a features list and converted to a data table. 
Using pattern matching and string replacements, a new variable feature_desc was added to the features data table, then written out to a text file. 
The entire contents of the output text file containing feature descriptions was manually copied and appended to a manually created CodeBook.md file using RStudio.

##Note: Source Data Set Description can be found at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

