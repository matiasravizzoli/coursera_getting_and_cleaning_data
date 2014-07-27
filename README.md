# README.md #

## Script run_analysis.R ##
The scripts assumes that the source information from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip has been downloaded and is unziped in the working directory.
The script will take the information fromt the aboce mentioned source and will merge the training and test data sets, subseting only the signals and related variables from mean and standard deviation. Labels and descriptions are updated and then a tidy data set is generated thru an aggregation of the information.

### Execution example: ###
run_analysis()

### Expected output: ###
tidydataset.txt
