## run_analysis.R script and related files written/provided by David J. Bauer.

These files were generated to satisfy the final project (week 4) requirements of the Coursera course "Getting and Cleaning Data".

### Files in this repository include:
**1. run_analysis.R** - R script file designed to output a tidy data set of specific values indicated in the assignment instructions
**2. codebook.md** - explains the variables and data included in the outputted tidy data set
**3. README.md** - (this file); lists and explains repository files; provides overview of project

### Overview
As a general overview, the script is designed to organize and pare down a large amount of cell phone movement data (accelerometer and gyroscope) collected from 30 participants, each of whom demonstrated 6 activities (walking on level floor, walking up stairs, walking down stairs, sitting, standing, and laying).

The assignment requests a script that will generate average performance values for specific variables (any variable containing mean or standard deviation data) of each participant on each activity. The activities were completed multiple times by each participant.

A link to the raw data was provided in the assignment instructions on Coursera and also appears below. The raw data are spread across several text files and require a good amount of effort to organize, label properly, and combine. The following section walks through my steps employed to process the data; *also refer to notes provided in the script* if you are attempting to fully understand, replicate, and/or increase the efficiency of my efforts.

### Processing steps
**STEP 0:** Download data file (.zip), extract into local folder, and set that folder as the working directory in R.

**STEP 1:** *Merge training and data sets to create one data set.*
This step involved a series of substeps as follows:
* 1A. Read data files into R
* 1B. Read variable file into R, clean up the variable names a bit, separate the test and training data into 561 columns, label with the variable names, and convert to numeric (they begin as character).
* 1C. Add subject and activity columns to each of the test and training data sets.
* 1D. Combine the test and training data sets into a single data set for further processing.

**STEP 2:** *Extract only the measurements on the mean and standard deviation for each measurement.*
This step is somewhat tricky in part because the assignment instructions are somewhat vague on which variables to isolate; in addition, it's not clear what decision or question the final data will be used to inform. Ultimately I decided to play it safe and keep every variable that included the string "mean" or "std" in the name, regardless of where in the name the string appeared or whether any of the letters were capitalized.

In my experience, keeping more data than you think you need is better than cutting away (or neglecting to record) something that you later consider useful or important.

**STEP 3:** *Use descriptive activity names to name the activities in the data set.*
Label the factor levels of the activity variable using (slightly modified) names provided with the data. These include walking, upstairs, downstairs, sitting, standing, and laying.

**STEP 4:** *Appropriately label the data set with descriptive variable names.*
I actually completed this step for the most part in step 1B; however, the names needed additional cleaning because they each began with an unnecessary digit. In this step I removed the prevailing digits from the variable names but left the remaining string.

**STEP 5:** *From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.*
I completed this step with two substeps:
* 5A. Convert the subject variable to factor (it begins as integer).
* 5B. Create an object using grouping and summarization that outputs the mean for each subject by each activity; generate a .csv file to output this object. *Please refer to the codebook for details on the outputted variables and data contained in the .csv file.*

### Link to raw Data
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
