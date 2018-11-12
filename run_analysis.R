library(dplyr)
library(tidyr)


#create data directory if it doesn't exist
if (!file.exists(".data")) {
  dir.create(".data")
}


#file download and unzip
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = ".data/data.zip", method = "curl")
unzip(".data/data.zip", exdir=".data")


#read row data from files
dataDir <- ".data/UCI HAR Dataset"

xTrain <- tbl_df(read.table(paste(dataDir,"/train/X_train.txt",sep="")))
yTrain <- tbl_df(read.table(paste(dataDir,"/train/Y_train.txt",sep="")))
subjectTrain <- tbl_df(read.table(paste(dataDir,"/train/subject_train.txt",sep="")))

xTest <- tbl_df(read.table(paste(dataDir,"/test/X_test.txt",sep="")))
yTest <- tbl_df(read.table(paste(dataDir,"/test/Y_test.txt",sep="")))
subjectTest <- tbl_df(read.table(paste(dataDir,"/test/subject_test.txt",sep="")))

activityLables <- tbl_df(read.table(paste(dataDir,"/activity_labels.txt",sep="")))
features <- tbl_df(read.table(paste(dataDir,"/features.txt",sep="")))


#set appropriate column names to datasets
colnames(activityLables) <- c("activity_id","activityName")
colnames(features) <- c("feature_id", "featureName")

colnames(yTrain) <- "activity_id"
colnames(yTest) <- "activity_id"

colnames(xTrain) <- features$featureName
colnames(xTest) <- features$featureName

colnames(subjectTrain) <- "subject_id"
colnames(subjectTest) <- "subject_id"


#choose only columns that contains Mean or Standard Deviation from features$featureName
chooseColumns <- grep("mean\\(\\)|std\\(\\)",features$featureName)


#dataset merges
tmpTrain <- cbind(subjectTrain, yTrain)
tmpTrain <- merge(tmpTrain, activityLables, by=("activity_id"))
tmpTrain <- tmpTrain[,-1]   #remove activity_id cloumn
tmpTrain <- cbind(tmpTrain, xTrain[,chooseColumns])

tmpTest <- cbind(subjectTest, yTest)
tmpTest <- merge(tmpTest, activityLables, by=("activity_id"))
tmpTest <- tmpTest[,-1] #remove activity_id cloumn
tmpTest <- cbind(tmpTest, xTest[,chooseColumns])

finalDataset <- rbind(tmpTrain, tmpTest)


#remove all unnecessary objects
rm(activityLables, features, subjectTest, subjectTrain, xTest, xTrain, yTest, yTrain
   , tmpTest, tmpTrain, chooseColumns, dataDir, fileUrl)


#create independent tidyDataSet with the average of each variable for each activity and each subject
tidyDataSet <-  finalDataset %>%
  gather(key   = featureName,
         value = value,
         -subject_id, -activityName) %>% 
  group_by(activityName, subject_id) %>%
  summarize(mean = mean(value))


#save tidyData as a txt file created with write.table() using row.name=FALSE
write.table(tidyDataSet, file = "tidyDataSet.txt", row.name = FALSE)
