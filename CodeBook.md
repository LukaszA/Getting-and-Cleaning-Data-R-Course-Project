## Description of data transformation in run_analysis.R

### Create data directory, if it doesn't exist

```
if (!file.exists(".data")) {
  dir.create(".data")
}
```


### File download and unzip

Zipped data source is: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


### Read row data from files

Script reads every file into **dplyr** tables

```
xTrain <- tbl_df(read.table(paste(dataDir,"/train/X_train.txt",sep="")))
yTrain <- tbl_df(read.table(paste(dataDir,"/train/Y_train.txt",sep="")))
subjectTrain <- tbl_df(read.table(paste(dataDir,"/train/subject_train.txt",sep="")))

xTest <- tbl_df(read.table(paste(dataDir,"/test/X_test.txt",sep="")))
yTest <- tbl_df(read.table(paste(dataDir,"/test/Y_test.txt",sep="")))
subjectTest <- tbl_df(read.table(paste(dataDir,"/test/subject_test.txt",sep="")))

activityLables <- tbl_df(read.table(paste(dataDir,"/activity_labels.txt",sep="")))
features <- tbl_df(read.table(paste(dataDir,"/features.txt",sep="")))
```


### Set appropriate column names to datasets

Assign descriptive columns names for better data understanding. The main tables xTrain and xTest get column names from futures dataset

```
colnames(xTrain) <- features$featureName
colnames(xTest) <- features$featureName
```


### Columns selections

Script select columns that contains Mean or Standard Deviation from features$featureName using **grep** 

```
chooseColumns <- grep("mean\\(\\)|std\\(\\)",features$featureName)
```


### Dataset merges

All row data are merged using ** cbind, rbind and merge** as below:

```
tmpTrain <- cbind(subjectTrain, yTrain)
tmpTrain <- merge(tmpTrain, activityLables, by=("activity_id"))
tmpTrain <- tmpTrain[,-1]   #remove activity_id cloumn
tmpTrain <- cbind(tmpTrain, xTrain[,chooseColumns])

tmpTest <- cbind(subjectTest, yTest)
tmpTest <- merge(tmpTest, activityLables, by=("activity_id"))
tmpTest <- tmpTest[,-1] #remove activity_id cloumn
tmpTest <- cbind(tmpTest, xTest[,chooseColumns])

finalDataset <- rbind(tmpTrain, tmpTest)
```


### Create independent tidyDataSet with the average of each variable for each activity and each subject

```
tidyDataSet <-  finalDataset %>%
  gather(key   = featureName,
        value = value,
         -subject_id, -activityName) %>% 
  group_by(activityName, subject_id, featureName) %>%
  summarize(mean = mean(value))
```


### Save tidyData as a txt file created with write.table() using row.name=FALSE

```
write.table(tidyDataSet, file = "tidyDataSet.txt", row.name = FALSE)
```

