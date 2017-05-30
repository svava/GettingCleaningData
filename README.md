---
title: "README.md"
author: "Svava Bragason"
date: "May 26, 2017"
output: html_document
---

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
  <p > A file in markdown format that displays when someone accesses the GitHub repository for a person's submission for the course project. The file is located at https://github.com/svava/GettingCleaningData/blob/master/README.md </p>
  </td>
 </tr>
  <tr >
  <td >
  <p '> CodeBook.md </p>
  </td>
  <td >
  <p > A file in markdown format that describes the variables (columns) contained in the tidy data set that must be uploaded to the coursera website as part of the project submission process. A file of tidy data created from the UCI HAR dataset using the run_analysis.R script. The file is located at https://github.com/svava/GettingCleaningData/blob/master/CodeBook.md </p>
  </td>
 </tr>
  <tr >
  <td >
  <p > run_analysis.R </p>
  </td>
 <td >
   <p >An R script that contains all of the R functions used to transform the eight input data files into the required formats for steps 4 and 5 of the assignment instructions. This file is located at https://github.com/svava/GettingCleaningData/blob/master/run_analysis.R </p>
  </td>
 </tr>
</table>


<p> </p>
<p> </p>

 Another file, the output from step 5 listed in "The Data Cleansing Task" should be uploaded to the Coursera website as part of the assignment submission. I have included this tidydata.txt file as well in the GitHub repository for easy reference, located at https://github.com/svava/GettingCleaningData/blob/master/tidydata.txt.


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
</table>

<p> </p>
<p> </p>
<OL> Included information
<LI> <a href="#disclosure">Dataset use disclosure</a> 
<LI> <a href="#tidydata">Tidy Data</a> 
<LI> <a href="#run_analysis">Steps performed in the run_analysis.R</a> 
<LI> <a href="#codebook">Creation of the CodeBook.md</a> 
</OL>

### Dataset use disclosure <a name="disclosure"></a> 
Original data was obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Use of this dataset  is acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

### Tidy Data <a name="tidydata"></a>
According to the Tidy Data paper by Hadley Wickham (http://vita.had.co.nz/papers/tidy-data.pdf), there are four components of tidy data:
<OL>
<LI> Each measured variable forms a column
<LI>  Each different observation of variables forms a row
<LI> Each type of observational unit forms a table
<LI>  If there are multiple tables, they should include a column in the table which allows them to be linked.
</OL>
Additionally, there should be:

* a row including the variable names at the top of each file
* human readable variable names
* data should be saved in one file per table



## Steps performed in the run_analysis.R <a name="run_analysis"></a>

#### Assumption note:
This script assumes that the Samsung data folder "UCI HAR Dataset" is in the working directory of the user running the run_analysis.R script.

#### 1. Load data.table and dplyr libraries
The data.table library is used for flexible and quick manipulation of data. The dplyr library is used for chaining commands.
<p> 

#### 2. Create a working directory variable "workdir" containing the working directory

#### 3. Load source data files to interim data tables
The metadata files feature labels and  activity labels are loaded respectively to master data.tables feature_labelsDT and activity_labelsDT using normalized file paths and fread().

<table border = 1>
 <tr >
  <th >
  <p align=center > <b> Source Data File </b> </p>
  </th>
   <th >
  <p align=center > <b>  Interim Data Table </b> </p>

  </th>
 </tr>
 <tr >
  <td >
  <p > features.txt </p>
  </td>
  <td >
  <p > feature_labelsDT </td>
 </tr>
  <tr >
  <td >
  <p > activity_labels.txt </p>
  </td>
  <td >
  <p > activity_labelsDT </p>
  </td>
 </tr>
  <tr >
  <td >
  <p > UCI HAR Dataset/test/subject_test.txt</p>
  </td>
 <td >
   <p >test_subjectsDT</td>
 </tr>
   <tr >
  <td >
  <p > UCI HAR Dataset/train/subject_train.txt</p>
  </td>
 <td >
   <p >train_subjectsDT</td>
 </tr>
 
 
 
 
 
 <tr >
  <td >
  <p > UCI HAR Dataset/test/y_test.txt</p>
  </td>
 <td >
   <p >test_activitiesDT</td>
 </tr>
 
   <tr >
  <td >
  <p > UCI HAR Dataset/train/y_train.txt</p>
  </td>
 <td >
   <p >train_activitiesDT</td>
 </tr>
 
  <tr >
  <td >
  <p > UCI HAR Dataset/test/X_test.txt</p>
  </td>
 <td >
   <p >testDT</td>
 </tr>
 
   <tr >
  <td >
  <p > UCI HAR Dataset/train/X_train.txt</p>
  </td>
 <td >
   <p >trainDT</td>
 </tr>
 
 
</table>




#### 4. Merge the test and activity data into single sets
* Merge the test_subjectsDT and train_subjectsDT into subjectsDT

* Merge the activities files test_activitiesDT, train_activitiesDT into activitiesDT using rbind.

* Merge the measurements data files testDT and trainDT into DT using rbind 

#### 5. Assign column names to the files. 
We will need column names for easier manipulation and selection of the correct variables.
First we calls the observation subjects "subject"
names(subjectsDT) <- c("subject")



Now we give the observation activities a activity_id column name
names(activitiesDT) <- c("act_id")

Then we add some more column names to the activity and feature labels

names(activity_labelsDT) <- c("act_id","activity")
names(feature_labelsDT) <- c("feature_id","feature_label")

 * Apply the feature labels from the feature_labels data table to the DT column names
names(DT) <- feature_labelsDT$feature_label


#### 6.  Join all the sets together using cbind
fullDT <- cbind(subjectsDT, activitiesDT,DT )

#### 7. Clean up the interim objects from the workspace
rm("test_subjectsDT")
rm("train_subjectsDT")
rm("test_activitiesDT")
rm("train_activitiesDT")
rm("subjectsDT")
rm("activitiesDT")
rm("DT")

#### 8. Subset only the mean and standard variables
Using regular expression, select the subject, activity, and all the measurements on the mean and standard deviation for each measurement, take all the variables including "mean()" or "std()" in their names, according to features_info.txt the "mean()" variables denote the Mean value and the "std()"  variables show  Standard deviation.

Note that we need to use the double escape character \\\\ before each parens
meanDT <- subset(fullDT, select = grep("subject|act_id|mean\\(\\)|std\\(\\)", names(fullDT)))

#### 9. Assign human readable labels to the activities
* Inner join activity_labelsDT to meanDT on act_id column to create meanActivityDT
* Remove act_id column by assigning a null value


#### 10. Modify the column names to make them more human readable
First, I removed the special punctuation characters to make it easier to reference the column names without using escape characters or generating syntax errors.
<DT>
<DD> 
names(meanActivityDT) <-gsub("[[:punct:]]","",names(meanActivityDT))

I capitalized Std and Mean to make these more easily human readable
I did not further manipulate the variable names in the tidy data set, already these variable names are on the longer side, and full descriptions of each variable are available in the CodeBook.md file
names(meanActivityDT) <-gsub("std","Std",names(meanActivityDT))
names(meanActivityDT) <-gsub("mean","Mean",names(meanActivityDT))



#### 11. Group by subject and country 
meanActivityDT <- meanActivityDT  %>% group_by(subject, activity)

#### 12. Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidydata <- meanActivityDT %>% summarize_all(mean)

#### 13. Write the tidy data set to output file
pathtofile <- normalizePath(file.path(tempdir,"tidydata.txt"))
fwrite(by_Activity, file = pathtofile)

#### 14. Display the tidy data file
Tidy data as per the ReadMe that can be read into R with read.table(header=TRUE). 

#### 15. Codebook preparation
The final part of the run_analysis.R file contains the code which was used to help automate the descriptions of the feature variables for the codebook. The column names were added to a features list and converted to a data table. 
Using pattern matching and string replacements, a new variable feature_desc was added to the features data table, appended with HTML tags for easier display, then written out to a text file "tidydata_variable_descriptions.txt".

### Create the codebook
In order to create the CodeBook.md file, the following steps were performed. 
<OL>
<LI>Copy and paste the contents of the UCI HAR Dataset README.txt file to the first part of CodeBook.md
<LI>Copy and paste the contents of the features_info.txt to the next part of CodeBook.md
<LI>Copy and paste the entire contents of the tidydata_variable_descriptions.txt file that was generated as the final portion of the run_analysis.R file to the manually created CodeBook.md file using RStudio.
<LI>Format the headings using HTML tags within RStudio.
<LI> Add link to source data set description.
</OL>
<BR>
 
#### Note: Source Data Set Description can be found at:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#

