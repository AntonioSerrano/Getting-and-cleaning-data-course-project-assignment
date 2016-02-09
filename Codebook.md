# CODEBOOK FOR GETTING AND CLEANING DATA COURSE PROJECT ASSIGNMENT

### by Antonio Serrano (February 2016)

This codebook describes data, variables and steps that has been taken to clean the data and obtain the two requested data sets:

1. Reading data files: the total sample (10299 observations) are divided in two parts or samples, training and test data sets. Each of these two data sets are also divided into three different txt files:

a) Training data: these three files comprise data of 7352 observations.

* subject_train.txt: it is a column vector of dimensions 7352*1. It comprises 21 unique subjects, that is, 70% of the total sample (30 subjects), just like the README.txt file says.

* X_train.txt: its dimensions are 7352*561. So, it includes the 561 variables named in the features.txt file. These variable are related to data gathered through three-axis accelerometers and gyroscopes included in the quantifying bracelet "Samsung Galaxy S II". For more info, read features_info.txt.

* Y_train.txt: it comprises 6 activities, ranging from 1 to 6. But for the moment we do not know the specific name for those activities.

These three files are read from the "./data/train" folder and store in trainSubject, trainData, and trainActivity objects respectively as data frames.  

b) Test data: these three files comprise data of 2947 observations.

* subject_test: 2947*1. It comprises 9 subjects, that is, the remaining 30% of the total sample.

* X_test.txt: 2947*561

* Y_test.txt: 2947*1

These three files are read from the "./data/test” folder and store in testSubject, testData, and testActivity objects respectively as data frames.  

2. Merging training and test datasets by subjects, data and activities:

* joinSubject: 10299*1. It results from joining trainSubject and testSubject. So now we have the 10299 observations of the 30 subjects together in one data frame.

* joinData: 10299*561. It results from concatenating testData and testData. Now we have data of the quantifying bracelet of 10299 observations and 561 measurements all together in one data frame.

* joinActivity: 10299*1. It results from concatenating trainActivity and testActivity.

3. Extracting only the measurements on the mean and standard deviation for each measurement:

We read first the features.txt file from the "/data" folder and store the data in a variable called features.  

Then, we have to select only the variables of interest, that is, only those variables within the joinData object that are related to means and standard deviation. In other words, the mean() and std() variables from the list included in the features.txt file. To do this, we can create an index vector indicating the position of those variable in the second column of feature.txt using the grep function with the pattern "mean\\(\\)|std\\(\\)”. In that way we can identify the position of the variables that includes the expression "bla bla bla mean() bla bla bla" or "bla bla bla std() bla bla bla". Be careful, we have to indicate the parentheses after mean or std cause there is another variable called "meanFreq()”.  

After filtering joinData with the index vector, the new data set has 66 columns, instead of 561.  
4. Appropriately labeling the data set with descriptive variable names: we use gsub function to modify the variable names. Specifically, we remove parentheses included in these names, capitalize M in "mean" in column names, capitalizes S in "Std”, and removes hyphens (“-“).

We also have to use descriptive activity names. The goal here is to change the activities coded from 1 to 6 into descriptive names (walking, walkingUpstairs, walkingDownstairs, sitting, standing, and laying). First, we read the activity_labels.txt file from the "./data"" folder and store the data in a variable called activity. We use tolower function to set lower case, substr and toupper functions to change u lowercase into U uppercase in "walkingupstairs” and change d lowercase into D uppercase in "walkingdownstairs”, remove underscores, etc. Finally, we transform the values of joinActivity according to the activity data frame that we have just created.

We also change the variable name from "V1" to "subject" in joinSubject.  

5. Merging subject, activity and data sets: we get the first requested data set called “mergedData” using cbind function. It has 10299x68 data points. The first column is ”subject" and ranges from 1 to 30. The second column is "activity" and contains 6 categories corresponding to the 6 kinds of activity. Finally, the other 66 columns contain measurements related to accelerometers and gyroscopes included in the quantifying bracelet. It ranges -1 to 1 exclusive. We have also stored the result in mergedData.txt file.

6. Creating a second, independent tidy data set with the average of each variable for each activity and each subject:

* First, we get the length of the total number of subjects (30), activities (180), and number of columns including subject and activity columns (68).

* Second, using the previous figures, we create an empty data frame of 180 rows (30 unique subjects multiplied by 6 unique activities) and 68 columns.

* Finally, we crate a loop function to fill the empty data frame with the mean of each variable for each activity and each subject. This loop function goes from subject i = 1 to 30, and from activity j = 1 to 6.

Alternatively, we could do the previous step using the data.table package and lapply function. Right after, it is convenient to sort data by subjects and activities using the plyr package and the arrange function.  

At last, we write the results in meanData.txt using write.table function.  
