---
title: "CodeBook for Peer-graded assignment from Getting-and-Cleaning-Data-R-Course-Project"
output: html_document
---


## Desctiption of data transformation

#create data directory if it doesn't exist
#file download and unzip
#read row data from files
#set appropriate column names to datasets
#choose only columns that contains Mean or Standard Deviation from features$featureName
#dataset merges
#remove all unnecessary objects
#create independent tidyDataSet with the average of each variable for each activity and each subject

```
tidyDataSet <-  finalDataset %>%
  gather(key   = featureName,
         value = value,
         -subject_id, -activityName) %>% 
  group_by(activityName, subject_id) %>%
  summarize(mean = mean(value))
```

#save tidyData as a txt file created with write.table() using row.name=FALSE



