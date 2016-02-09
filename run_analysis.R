## SCRIPT FOR GETTING AND CLEANING DATA COURSE PROJECT ASSIGNMENT:

## by Antonio Serrano (February 2016)

## 1. Reading data files:

## a) Training data:

trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
dim(trainSubject) # 7352*1
length(table(trainSubject)) # 21 subjects (70% of the complete sample)

trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
dim(trainData) # 7352*561. Data related to three-axis accelerometers and
# gyroscopes included in the quantifying bracelet.For more info, read
# features_info.txt.

trainActivity <- read.table("./UCI HAR Dataset/train/Y_train.txt")
dim(trainActivity) # 7352*1. It comprises 6 activities, ranging from 1 to 6. But
# for the moment we do not know which paricular activities are.

## b) Test data:

testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
dim(testSubject) # 2947*1
length(table(testSubject)) # It comprises 9 subjects (30%)

testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
dim(testData) # 2947*561

testActivity <- read.table("./UCI HAR Dataset/test/Y_test.txt")
dim(testActivity) # 2947*1

## 2. Merging training and test datasets by subjects, data and activities:

joinSubject <- rbind(trainSubject, testSubject)
dim(joinSubject) # 10299*1. So now we have the 10299 observations of the 30 subjects
# together in one data frame.

joinData <- rbind(trainData, testData)
dim(joinData) # 10299*561. So now we have data of the quantifying bracelet of 10299
# observations and 561 measurements all together in one data frame.

joinActivity <- rbind(trainActivity, testActivity)
dim(joinActivity) # 10299*1. The same for the 6 types of activities.

## 3. Extracting only the measurements on the mean and standard deviation for each
# measurement:

features <- read.table("./UCI HAR Dataset/features.txt")
dim(features) # 561*2. The second one has the labels for accelerometer and gyroscope
# variables.
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2]) # We create an index vector
# that indicate the position of those variables that includes the expression "bla bla bla
# mean() bla bla bla" or "bla bla bla std() bla bla bla".
joinData <- joinData[, meanStdIndices] # Now we have selected our variables of interest
dim(joinData) # 10299*66. Instead of 561 variables, now we have 66.

## 4. Appropriately labeling the data set with descriptive variable names:

names(joinData) <- gsub("\\(\\)", "", features[meanStdIndices, 2]) # It takes the labels
# from the features.txt file and put them in joinData variable names. In addition, it
# removes parentheses included in these names.
names(joinData) <- gsub("mean", "Mean", names(joinData)) # It capitalizes M in "mean"
# in column names.
names(joinData) <- gsub("std", "Std", names(joinData)) # It capitalizes S in "Std"
names(joinData) <- gsub("-", "", names(joinData)) # It removes hyphens ("-")

## We also have to use descriptive activity names. The goal here is to change the activity
# code from 1 to 6 into descrptive names (walking, walkingUpstairs, walkingDownstairs,
# sitting, standing, and laying):

activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2])) # It changes text to lower case
substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8)) # It changes
# u lowercase into U uppercase in "walkingupstairs"
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8)) # It changes
# d lowercase into D uppercase in "walkingdownstairs"
activityLabel <- activity[joinActivity[, 1], 2]
joinActivity[, 1] <- activityLabel # With the previous two steps we have labeled
# activities 1-6 with descriptive names
names(joinActivity) <- "activity" # It changes the variable name from "V1" to
# "activity" in joinActivity

## Now we change the variable name from "V1" to "subject" in joinSubject:

names(joinSubject) <- "subject"

## 5. Merging subject, activity and data sets:

mergedData <- cbind(joinSubject, joinActivity, joinData)

## Storing the merged data set in a txt file:

write.table(mergedData, "mergedData.txt")

## 6. Creating a second, independent tidy data set with the average of each variable
# for each activity and each subject:

## Calculating dimensions of the new data set:

subjectNum <- length(table(joinSubject)) # 30. It counts the total number of subjects
# in the experiment
activityNum <- dim(activity)[1] # 6. It counts the types of activities in the
# experiment
columnNum <- dim(mergedData)[2] # 68. It counts the number of columns in the merged
# and clean data set.

## Creating an empty data frame of 180 rows (30 subjects multiplied by 6 activities) and
# 68 columns:

meanData <- matrix(NA, nrow=subjectNum*activityNum, ncol=columnNum) 
meanData <- as.data.frame(meanData)
colnames(meanData) <- colnames(mergedData) # It passes names of variables from mergedData
# to the new empty data frame

## Crating a for loop function to fill the empty data frame:

row <- 1
for(i in 1:subjectNum) { # The loop function goes from subject 1 to 30
        for(j in 1:activityNum) { # From activity 1 to 6
                meanData[row, 1] <- sort(unique(joinSubject)[, 1])[i]
                meanData[row, 2] <- activity[j, 2]
                bool1 <- i == mergedData$subject
                bool2 <- activity[j, 2] == mergedData$activity
                meanData[row, 3:columnNum] <- colMeans(mergedData[bool1&bool2, 3:columnNum])
                row <- row + 1
        }
}

## Alternatively, we could do the previous step using the data.table package and lapply
# function:

# library(data.table)
# formattedData <- data.table(mergedData)
# meanData2 <- formattedData[, lapply(.SD, mean), by=c("subject", "activity")]
## Sorting result by subject:
# library(plyr)
# meanData2 <- arrange(meanData2, subject, activity)

## Storing the result in a txt file:

write.table(meanData, "meanData.txt")
