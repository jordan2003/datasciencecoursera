#Data Science Coursera Peoject


#Installing and Loading the Downloader package for ease of use.
#install.packages("downloader")
#require(downloader)
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
#unzip(zipfile="Dataset.zip")

# Installing and Loading the required Lobrary Needed at the end
#install.packages("plyr")
#library(plyr);

#Read all the unCompressed needed files into tables

files<-list.files( "UCI HAR Dataset",recursive=TRUE)
activ_train <- read.table(("./UCI HAR Dataset/train/Y_train.txt"), header = FALSE)
activ_test  <- read.table(("./UCI HAR Dataset/test/Y_test.txt"),header = FALSE)
subject_train <- read.table(("./UCI HAR Dataset/train/subject_train.txt"),header = FALSE)
subject_test  <- read.table(("./UCI HAR Dataset/test/subject_test.txt"),header = FALSE)
feature_train <- read.table(("./UCI HAR Dataset/train/X_train.txt"),header = FALSE)
feature_test  <- read.table(("./UCI HAR Dataset/test/X_test.txt" ),header = FALSE)

#test to see the data uncomment the below line
#str(activ_test)




#1.Merges the training and the test sets to create one data set
subject <- rbind(subject_train, subject_test)
activity<- rbind(activ_train, activ_test)
features<- rbind(feature_train, feature_test)
names(subject)<-c("subject")
names(activity)<- c("activity")
features_name <- read.table(("./UCI HAR Dataset/features.txt"),head=FALSE)
names(features)<- features_name$V2
dataCombine <- cbind(subject, activity)
Data <- cbind(features, dataCombine)



#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
s_features_name<-features_name$V2[grep("mean\\(\\)|std\\(\\)", features_name$V2)]
selectedNames<-c(as.character(s_features_name), "subject", "activity" )
Data<-subset(Data,select=selectedNames)


#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
activityLabels <- read.table(("./UCI HAR Dataset/activity_labels.txt"),header = FALSE)
names(Data)<-gsub("Acc", "accelero-meter", names(Data))
names(Data)<-gsub("Gyro", "gyroscope", names(Data))
names(Data)<-gsub("Mag", "magnitude", names(Data))
names(Data)<-gsub("BodyBody", "body", names(Data))
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "freq", names(Data))
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
D2<-aggregate(. ~subject + activity, Data, mean)
D2<-D2[order(D2$subject,D2$activity),]
write.table(D2, file = "tidy_data2.txt",row.names=FALSE)
