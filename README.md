# README: Getting and Cleaning Data


## Requirement

* The R script assumed that raw data folder for the assignment `/UCI HAR Dataset` is in the same directory as the script.
* The R script written assumed that the package `dplyr` is installed and loaded.


## Purpose

The script is coded to produce a tidy dataset from raw dataset *UCI HAR Dataset*. The code can be broken down into 5 main part:
1. Load the data into memory using `read.table()` function.
2. Merge *Subject*, *Activity_Label* and *Data* into one dataset, for each training and test set
3. Merge the training and test set into a dataset
4. Extract the variables of the mean and standard deviation of measurements
5. Change the *Activity label* in dataset to a more descriptive name
6. Assign descriptibe variable name to the columns of dataset
7. Create a new dataset with the average of each variable for each activity and each subject

The script will open a preview of a tidy dataset at the end. The *tidy_data.csv* saved in the same directory as this document is written using `write.csv()` function. The rest of this document attempt to explain those step in detail.


## Reading from raw data

The original raw data separate the training set and test set into different folder,(`/training` and `/test`) with each folder containing the participant information(stored in `/training/subject_train.txt` and `/test/subject_test.txt`), the activity being carried out(stored in `/training/y_train.txt` and `/test/y_test.txt`), and the data collected stored in `/training/X_train.txt`, `/test/X_test.txt`. The label for the activity carried out is stored in `activity_label.txt`. Additionaly, the label for the measurent data is provided by `/features.txt`.

The first section of the script functions to loaded this data into memory using `read.table()` and reference them using various variables.


## Merging the participant, activites and data collectd into a dataset

To reconstruct a dataset with data being associated with subject/participant and activity, `cbind()` function is used to bind together those data into a more complete dataset.

I done this seperately for the training set and test set.


## Merging the training set and test set

Similarly, the training set and data set is bind using `rbind()`.


## Extracting only the measurements on the mean and standard deviation for each measurement.

Noting that in the origianal `/features.txt`, all our required measurement contain `-mean()` or `-std()`. I used `grep()` function to get the index of all our required measurement and stored it in `reqFeatureIndex`.

With `Data <- Data[,c(1,2,reqFeatureIndex + 2)]`, we reassigned `Data` with only our required columns. Note that `reqFeatureIndex + 2` is used as we added two columns(*Subject* and *Activity*) previously.


## Changing the activity label in the dataset to a more descriptive name

This step is divided into 2 process:

1. 
      ```R
      activityLabel_desc <- unname(sapply(activityLabel[[2]], function(x){gsub("_", " ", tolower(x))}))
      ```
      
      Note that `activityLabel[[2]]` containing the activity label. Using `sapply()` function, each of the label is             converted into lowercase(using `tolower()`) and all the character `_` is removed using `gsub()`.
      
      The `unname()` function is used to remove the name from the resulting character vector, allowed for easier diagnosing during the development process.
      
2. Using the newly named activity label(stored in `activityLabel_desc`), I rename the the Activity column of data using the `sapply()` function.


## Relabel the dataset with more descriptive name

I created a helper function to achive this task:
```R
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
```
Given a name, this function remove `()` from the name, split the name by `-` into components, exchange the last 2 position of the components and reassign the name for mean and standard deviation. (I want a variable name with either `Sd` and `Mean` at the end)


## Creating a new dataset with average of each variable for each activity and each subject.

Note that the package `dplyr` is required for the part. We first group the data by `Activity` and `Subject` using the `group_by()` fucntion. Then using the `summarise_all()` to create a new table with means asscocaited with each activity and each subjects.