run_analysis <- function() {
  ## Load required libraries
  library(data.table)
  library(reshape)
  
  ## Set working directory
  currentwd <- getwd()
  filespath <- file.path(currentwd, "UCI HAR Dataset")
  
  ## Load Data Sets
  subject_test_file <- file.path(filespath,"test/subject_test.txt")
  subject_train_file <- file.path(filespath,"train/subject_train.txt")
  
  subject_test_table <- fread(subject_test_file)
  subject_train_table <- fread(subject_train_file)
  
  label_test_file <- file.path(filespath,"test/Y_test.txt")
  label_train_file <- file.path(filespath,"train/Y_train.txt")
  
  label_test_table <- fread(label_test_file)
  label_train_table <- fread(label_train_file)
  
  data_test_file <- file.path(filespath,"test/X_test.txt")
  data_train_file <- file.path(filespath,"train/X_train.txt")
  
  data_test_table_temp <- read.table(data_test_file)
  data_test_table <- data.table(data_test_table_temp)
  data_test_table_temp <- NULL
  data_train_table_temp <- read.table(data_train_file)
  data_train_table <- data.table(data_train_table_temp)
  data_train_table_temp <- NULL
  
  
  ## Merges the training and the test sets to create one data set.
  merged_subjects <- rbind(subject_test_table, subject_train_table)
  rename(merged_subjects, c("V1"="subject"))
  
  merged_labels <- rbind(label_test_table,label_train_table)
  rename(merged_labels, c("V1"="Label"))
  temp <- NULL
  temp <- cbind(merged_subjects, merged_labels)
  merged_data <- rbind(data_test_table, data_train_table)
  
  
  
  ## Extracts only the measurements on the mean and standard deviation 
  ## for each measurement.
  features_file <-fread(file.path(filespath,"features.txt"))
  features_file <- features_file[like(V2,"mean\\(|std\\(")]
  rename(features_file, c("V1"="IDs","V2"="Desc"))
  features_file <- cbind(features_file,paste("V",features_file$"IDs",sep=""))
  
  lista <-c(features_file$V2)
  merged_data <- merged_data[,lista,with=FALSE]
  merged_data <- cbind(temp, merged_data)
  
  
  
  ## Uses descriptive activity names to name the activities in the data set.
  activity_labels_file <-fread(file.path(filespath,"activity_labels.txt"))
  rename(activity_labels_file, c("V1"="activityID","V2"="activityDESC"))
  rename(merged_data, c("Label"="activityID"))
  merged_data <- merge(merged_data, activity_labels_file, by = "activityID", all.x = TRUE)
  
  setkey(merged_data, subject, activityID, activityDESC)
  
  
  ## Appropriately labels the data set with descriptive variable names. 
  temp2 <- merged_data
  features_file$Desc = gsub("\\(\\)", "", features_file$Desc)
  features_file$Desc = gsub("-", ".", features_file$Desc)
  for (i in 1:length(features_file$Desc)) {
    colnames(temp2)[i +2] <- features_file$Desc[i]
  }
  
  
  
  ## Creates a second, independent tidy data set with the average of 
  ## each variable for each activity and each subject. 
  temp3 <-aggregate(temp2, by=list(Subject = temp2$subject, Activity = temp2$activityID, ActivityDesc =temp2$activityDESC), FUN=mean, na.rm=TRUE)
  drops <- c("subject","activityID","activityDESC")
  finaldata <- temp3[,c(!(names(temp3) %in% drops))]
  
  write.table(finaldata, file="./tidydataset.txt", sep="\t", row.names=FALSE, quote=FALSE)
  
  print("File saved as ./tidydataset.txt")
  
  
}
