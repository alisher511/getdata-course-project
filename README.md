# Getting and Cleaning Data Course project
The more detailed description of the code performed on the original data set can be found in Codebook.md in the same repo.

run_analysis.R performs the following steps:
- creates a directory called 'data' if one doesn't already exist
downloads and stores the data, loads it into R
- the code works with the following txt files:
"X_train.txt", "X_test.txt", "Y_train.txt", "Y_test.txt", "subject_train.txt", "subject_test.txt", "features.txt", "activity_labels.txt".
- merges the train and test data to create a single data.frame
- selects only mean and standard deviation variables
- substitutes number factors in 'Activity' with activity names from `activity_labels.txt`
- renames the variables to make them clearer to understand
- and finally, groups the data by 'Subject' and 'Activity' and applies a `mean()` function to each variable.
Writes the data to `tidyData.txt`
