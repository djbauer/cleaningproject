#run_analysis.R
#       Script created to partially satisfy completion of Coursera course 
#       "Getting and Cleaning Data", week 4 (final week) project.
#       Created by David J. Bauer, 2018-10-11

#STEP 0: Set working directory to folder that contains downloaded and extracted 
#       data folder/files. Then load the tidyverse library.

library(tidyverse)

#STEP 1: Merge training and test sets to create one data set.

#       1A: read files into R (note: .zip downloaded from provided link and 
#       extracted into working directory)
testsub <- read.delim("./test/subject_test.txt", header = FALSE)
testx <- read.delim("./test/X_test.txt", header = FALSE)
testy <- read.delim("./test/y_test.txt", header = FALSE)

trainsub <- read.delim("./train/subject_train.txt", header = FALSE)
trainx <- read.delim("./train/X_train.txt", header = FALSE)
trainy <- read.delim("./train/y_train.txt", header = FALSE)

#       1B: the testx and trainx objects are weird... there is only one column 
#       but each row contains 561 values. These need to be spread out into 
#       561 columns and named appropriately.

#       The column names are provided in the file features.txt. Need to read in 
#       features and create a list of variable names.
features <- read.delim("./features.txt", header = FALSE)

#       Oh, but guess what? The variable names are also confusing because each 
#       includes a number, a space, and then the actual variable name. So, get 
#       rid of the space. This also converts to character for some reason, so 
#       that's good (for subsequent tidyr separate).
features1 <- apply(features, 2, function(x)gsub('\\s+', '',x))

#       Use tidyr separate to split the single column of 561 values into 561 
#       columns (named from features1). Note that some columns are separated by 
#       more than 1 space so need to add +. Also note that the first column is 
#       blank so I created a dummy column in features2 using append.
features2 <- append(features1, "dummy", after = 0)
testdata <- testx %>% separate(V1, features2, sep = "\\s+")
traindata <- trainx %>% separate(V1, features2, sep = "\\s+")

#       Convert the data to numeric now. I tried to do it at the end but it 
#       seems to work better if you do it at this stage.

testdata[2:562] <- as.numeric(unlist(testdata[2:562]))
traindata[2:562] <- as.numeric(unlist(traindata[2:562]))

#       1C: Add the subject numbers and activity labels to the test and train 
#       data in order of subject, activity label, anad values. Then add column 
#       names to the first two columns.
testdata2 <- cbind(testsub, testy, testdata)
traindata2 <- cbind(trainsub, trainy, traindata)

names(testdata2)[1] <- "subject"
names(testdata2)[2] <- "activity"
names(traindata2)[1] <- "subject"
names(traindata2)[2] <- "activity"

#       1D: Combine test and train data into single set by binding rowns.
alldata <- rbind(testdata2, traindata2)


#STEP 2: Extract only the measurements on the mean and standard deviation 
#       for each measurement.

#       This can be done via the dplyr select function. I will select all 
#       variables that contain the text "subject", "activity", "mean", or "std".

#       NOTE: regarding "mean" and "std", cases and locations in the text are 
#       ignored... every variable with any instance of "mean" or "std" is 
#       included. This may or may not be appropriate depending on the planned 
#       analyses but the assignment is sort of vague on this issue so I figured 
#       better safe than sorry.
extracted <- alldata %>% select(subject, activity, contains("mean"), 
                                contains("std"))


#STEP 3: Use descriptive activity names to name the activities in the data set.

#       Rename the factor levels using the provided labels (slightly modified). 
extracted$activity <- factor(extracted$activity, levels = c(1,2,3,4,5,6),
                             labels = c("walking", "upstairs", "downstairs",
                                        "sitting", "standing", "laying"))


#STEP 4: Appropriately label the data set with descriptive variable names.

#       In an earlier step I included the variable names provided by the 
#       features file, but they include prevailing digits that are unnecessary.
#       This will remove them (by substituting nothing) to clean up the names a 
#       bit.
colnames(extracted) <- gsub("^[0-9]+", "", colnames(extracted))


#STEP 5: From the data set in step 4, create a second, independent tidy data 
#       set with the average of each variable for each activity and each
#       subject.

#       5A. This will require grouping data based both on subject and activity. 
#       First change the subject class to factor (currently integer).
extracted$subject <- as.factor(extracted$subject)

#       5B. Now create an object using grouping and summarization that reports 
#       the mean for each subject by each activity and generate a .csv file. I 
#       tested the .csv file in both Excel and JASP; works great using the 
#       specified arguments.
meansoutput <- extracted %>% group_by(subject, activity) %>% 
           summarise_at(vars(3:88), mean)

write.table(meansoutput, file = ".\\meansoutput.csv", sep = ",",
            row.names = FALSE)