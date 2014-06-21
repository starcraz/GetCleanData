library(knitr)
knit("run_analysis.Rmd")

## Course Project
## run_analysis

## loading the necessary packages
library(data.table)
library(reshape2)

## set directory
path <- getwd()
path

## pull the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "dataset.zip"
if(!file.exists(path)){dir.create(path)}
download.file(url, file.path(path, file))

## unzip files with 7-zip
extract <- file.path("C:", "Program Files (x86)", "7-Zip", "7z.exe")
parameters <- "x"
cmd <- paste(paste0("\"", extract, "\""), parameters, paste0("\"", file.path(path, file), "\""))
system(cmd)

## set the file path to the folder name of the data set
pathIn <- file.path(path, "UCI HAR Dataset")
list.files(pathIn, recursive = TRUE) # see what data are inside the folder

## reading the subject data into R
subjectTrain <- data.table(read.table(file.path(pathIn, "train", "subject_train.txt")))
subjectTest <- data.table(read.table(file.path(pathIn, "test", "subject_test.txt")))

## reading the activity data into R
activityTrain <- data.table(read.table(file.path(pathIn, "train", "Y_train.txt")))
activityTest <- data.table(read.table(file.path(pathIn, "test", "Y_test.txt")))

## reading the training and testing data into R
train <- data.table(read.table(file.path(pathIn, "train", "X_train.txt")))
test <- data.table(read.table(file.path(pathIn, "test", "X_test.txt")))

```{r fig.height = 3, fig.width = 4, fig.cap = "1.Merge training and test sets",
        echo = FALSE}
## 1.merges the training and the test sets to create one data set
subject <- rbind(subjectTrain, subjectTest)
setnames(subject, "V1", "subject")
activity <- rbind(activityTrain, activityTest)
setnames(activity, "V1", "activityNum")
data <- rbind(train, test)

subject <- cbind(subject, activity)
data <- cbind(subject, data)

setkey(data, subject, activityNum)

```
## 2.extracts only the measurements on the mean and standard deviation for each measurement
### use the feature data 
```{r fig.heights = 3, fig.width = 4, fig.cap = "2.Extract measurements of mean and standard deviation",
    echo = FALSE)}
features <- data.table(read.table(file.path(pathIn, "features.txt")))
setnames(features, names(features), c("featureNum", "featureName"))

### pull out measurements for mean and standard deviation
features <- features[grepl("mean\\(\\)|std\\(\\)", featureName)]

### convert variable names to match the merged data set
features$featureCode <- features[, paste0("V", featureNum)]
head(features)
features$featureCode

### select only feature code to the merged data set
sub <- c(key(data), features$featureCode)
data <- data[, sub, with = FALSE]

```

## 3.uses descriptive activity names to name the activities in the data set
activityNames <- data.table(read.table(file.path(pathIn, "activity_labels.txt")))
setnames(activityNames, names(activityNames), c("activityNum", "activityName"))

## 4.appropriately labels the data set with descriptive variables names
data <- merge(data, activityNames, by = "activityNum", all.x = TRUE)
setkey(data, subject, activityNum, activityName)

### melt data set to a tall and narrow format
data <- data.table(melt(data, key(data), variable.name = "featureCode"))
data <- merge(data, features[, list(featureNum, featureCode, featureName)], 
              by = "featureCode", all.x = TRUE)

### create new variable to change class of activity and feature variable into factor
data$activity <- factor(data$activityName)
data$feature <- factor(data$featureName)

### pull out feature from featureName
pullfeature <- function(regex){
        grepl(regex, data$feature)
}
### with 1 category feature
data$featureJerk <- factor(pullfeature("Jerk"), labels = c(NA, "Jerk"))
data$featureMagnitude <- factor(pullfeature("Mag"), labels = c(NA, "Magnitude"))

### with 2 category features
n <- 2
y <- matrix(seq(1,n), nrow = n)
x <- matrix(c(pullfeature("^t"), pullfeature("^f")), ncol = nrow(y))
data$featureDomain <- factor(x %*% y, labels = c("Time", "Freq"))
x <- matrix(c(pullfeature("Acc"), pullfeature("Gyro")), ncol = nrow(y))
data$featureInstrument <- factor(x %*% y, labels = c("Accelerometer", "Gyroscope"))
x <- matrix(c(pullfeature("BodyAcc"), pullfeature("GravityAcc")), ncol = nrow(y))
data$featureAcceleration <- factor(x %*% y, labels = c(NA, "Body", "Gravity"))
x <- matrix(c(pullfeature("mean()"), pullfeature("std()")), ncol = nrow(y))
data$featureVariable <- factor(x %*% y, labels = c("Mean", "SD"))

### with 3 category features
n <- 3
y <- matrix(seq(1, n), nrow = n)
x <- matrix(c(pullfeature("-X"), pullfeature("-Y"), pullfeature("-Z")), ncol = nrow(y))
data$featureAxis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))

### validate all features are included in the variables
row1 <- nrow(data[, .N, by = c("feature")])
row2 <- nrow(data[, .N, by = c("featureDomain", "featureAcceleration", "featureInstrument",
                               "featureJerk", "featureMagnitude", "featureVariable", "featureAxis")])
row1 == row2

## 5.creates a second, independent tidy data set with the average of each variable for each activity and each subject
setkey(data, subject, activity, featureDomain, featureAcceleration, featureInstrument,
       featureJerk, featureMagnitude, featureVariable, featureAxis)
tidyData <- data[, list(count = .N, average = mean(value)), by = key(data)]

## saving tidy data
tidy <- file.path(path, "SmartphoneActivityData.txt")
write.table(tidyData, tidy, quote = FALSE, sep = "\t", row.names = FALSE)

## codebook
library(knitr)
library(markdown)
setwd("~/Repositories/Coursera/GettingCleaningData/Project")
knit("run_analysis.Rmd", encoding = "ISO8859-1")
markdownToHTML("run_analysis.md", "run_analysis.html")

knit("codeBook.Rmd", output="codeBook.md", encoding="ISO8859-1", quiet=TRUE)
markdownToHTML("codebook.md", "codebook.html")