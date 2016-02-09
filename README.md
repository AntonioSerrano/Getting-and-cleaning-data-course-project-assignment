# README FILE FOR GETTING AND CLEANING DATA COURSE PROJECT ASSIGNMENT

### by Antonio Serrano (February 2016)

This file contains the instructions to use run_analysis.R script:

1. Download the data set from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

2. Unzip the file and move the folder “UCI HAR Dataset” to your working directory. 

3. Move also the run_analysis.R script to your working directory.

4. Type source("run_analysis.R") in RStudio console.

5. After running the code, you will get two files in your working directory:

* mergedData.txt (8.3 Mb): it contains a tidy data set with 10299 observations and 68 variables, including subjects, activities and measures obtained from accelerometers and gyroscopes included in the quantifying bracelet "Samsung Galaxy S II”.

* meanData.txt: it includes a data set of 180 observations and 68 variables. In this case, the 66 measures are the average of each variable for each activity and each subject.


6. Finally, type the following two instructions in RStudio to read the two requested
data sets:

* mergedData <- read.table("mergedData.txt”)
* meanData <- read.table("meanData.txt")
