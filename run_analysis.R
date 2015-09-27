if (dir.exists("./data") == FALSE) {
        dir.create("./data")
        }
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/dataset.zip")

unzip("./data/dataset.zip", exdir = "./data")

###
dataXtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)
dataXtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
combined_X <- rbind(dataXtrain, dataXtest)
features_names <- read.table("./data/UCI HAR Dataset/features.txt" , sep = " ", header = FALSE)
names(combined_X) <- features_names$V2

dataYtrain <- read.table("./data/UCI HAR Dataset/train/Y_train.txt" , header = FALSE)
dataYtest <- read.table("./data/UCI HAR Dataset/test/Y_test.txt" , header = FALSE)
combined_Y <- rbind(dataYtrain, dataYtest)
names(combined_Y) <- c("activity")


subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt" , header = FALSE)
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt" , header = FALSE)
combined_subject <- rbind(subject_train, subject_test)
names(combined_subject) <- c("Subject")

combined_XY <- cbind(combined_X, combined_Y) 

mydata <- cbind(combined_XY, combined_subject)

###

str(mydata)
rm("dataXtrain", "dataXtest", "dataYtrain", "dataYtest", "subject_train", "subject_test")
rm("combined_XY", "combined_X", "combined_Y", "combined_subject")

contains_mean <- grep("mean()", features_names$V2, ignore.case = TRUE, value = TRUE)
contains_sd <- grep("std()", features_names$V2, ignore.case = TRUE, value = TRUE)

mean_sd_names_vector <- c(contains_mean, contains_sd, "Subject", "activity")
mean_sd_names_vector


mydata_mean_sd <- subset(mydata, select = mean_sd_names_vector)
str(mydata_mean_sd)

###

activities_names <- read.table("./data/UCI HAR Dataset/activity_labels.txt", sep=" ", header =FALSE)
activities_names <- as.data.frame(activities_names)
names(activities_names) <- c("id", "Activity")
activities_names


mergedData <- merge(mydata_mean_sd, activities_names, by.x = "activity", by.y = "id")
str(mergedData)

library(dplyr)

Data <- select(mergedData, -(activity))
Data <- Data[c(87, 88, 1:86)]
View(Data)
str(Data)

#### http://www.cookbook-r.com/Manipulating_data/Renaming_columns_in_a_data_frame/

names(Data) <- gsub("Gyro", "Gyroscope", names(Data))
names(Data) <- gsub("Acc", "Accelerator", names(Data))
names(Data) <- gsub("tBody", "TimeBody", names(Data))
names(Data) <- gsub("tGravity", "TimeGravity", names(Data))

names(Data) <- gsub("Freq", "Frequency", names(Data))
names(Data) <- gsub("fBody", "FrequencyBody", names(Data))
names(Data) <- gsub("Mag", "Magnitude", names(Data))
names(Data) <- gsub("Jerk", "Jerk-signal", names(Data))
names(Data) <- gsub("BodyBody", "Body", names(Data))

names(Data) <- gsub("-X", "-X-axis", names(Data))
names(Data) <- gsub("-Y", "-Y-axis", names(Data))
names(Data) <- gsub("-Z", "-Z-axis", names(Data))

names(Data)

### http://stackoverflow.com/questions/21644848/summarizing-multiple-columns-with-dplyr

groupedData <- group_by(Data, Subject, Activity)
tidyData <- summarise_each(groupedData, funs(mean))
View(tidyData)

write.table(Data2, file = "tidyData.txt", row.name=FALSE, col.names = TRUE)

#to load the 'tidyData.txt' use 
tidyData <- read.table("tidyData.txt", header = TRUE)
str(tidyData)