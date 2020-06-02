## STEP 1:  Load the data into memory from raw dataset.
# Assume the folder "UCI HAR Dataset" is in the same directory as this script.
trainSet <- read.table("UCI HAR Dataset/train/X_train.txt")
trainLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")

testSet <- read.table("UCI HAR Dataset/test/X_test.txt")
testLabels <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activityLabel <- read.table("UCI HAR Dataset/activity_labels.txt")


## STEP 2:  Merge the Subject, Activity_Label and Dataset
trainData <- cbind(trainSubject, trainLabels, trainSet)
testData <- cbind(testSubject, testLabels, testSet)


## STEP 3:  Merge the training and the test sets to create one data set.
Data <- rbind(trainData, testData)


## STEP 4:  Extract only the measurement of mean and standard deviation
# Note that the required features have "-mean(" or "-std(" in their name
reqFeatureIndex <- grep("-mean\\(|-std\\(", features[[2]])
Data <- Data[,c(1,2,reqFeatureIndex + 2)]

##STEP 5:  Change the activity_label (an int) into a descriptive name (a char)
# Change the name of activity_label to a more descriptive one
activityLabel_desc <- unname(sapply(activityLabel[[2]], function(x){gsub("_", " ", tolower(x))}))

## Change the activity_label in Data to be a descriptive one
Data[[2]] <- sapply(Data[[2]], function(x){activityLabel_desc[x]})


## STEP 6:  Relabel the dataset with more descriptive name
# Function to rename the variable into more descriptive form
renameVariable <- function(name) {
      name <- gsub("\\()", "", name)
      nameComponent <- strsplit(name, "-")[[1]]
      if (length(nameComponent) == 3) {
            temp <- nameComponent[2]
            nameComponent[2] <- nameComponent[3]
            nameComponent[3] <- temp
      }
      if (nameComponent[length(nameComponent)] == "mean") {
            nameComponent[length(nameComponent)] <- "Mean"
      } else {
            nameComponent[length(nameComponent)] <- "Sd"
      }
      
      paste(nameComponent, collapse="")
}

# Rename all the variable name to descriptive name
renFeature <- unname(sapply(features[[2]][reqFeatureIndex], renameVariable))

# Label the variable of data set with appropriate name
names(Data) <- c("Subject", "Activity", renFeature)


## STEP 7: Create a new dataset with average of each variable for each activity and each subject.
library(dplyr)
new_data <- Data %>% group_by(Subject, Activity) %>% summarize_all(mean)
View(new_data)


