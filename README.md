#The file contains a description of run_analysis.R script
#Step1.Merging the training and the test sets to create one data set
#Read source files to data.frames
 ##Read files from test dataset to data.frames
sub_test<-read.table("data/test/subject_test.txt")
x_test<-read.table("data/test/X_test.txt")
y_test<-read.table("data/test/y_test.txt")
 ##Read files from train dataset to data.frames
sub_train <- read.table("data/train/subject_train.txt")
x_train<-read.table("data/train/X_train.txt")
y_train<-read.table("data/train/y_train.txt")
 ##Read file with features names to data.frames
feach<-read.table("data/features.txt")
# Rename columns in data.frames
 ## Rename columns on x_test and x_train using features names from feach
colnames(x_test) <- feach[,"V2"]
colnames(x_train) <- feach[,"V2"]
 ## Rename columns on sub_test, sub_train, y_test,y_train before creating one dataset
colnames(sub_test) <- "subject"
colnames(sub_train) <- "subject"
colnames(y_test) <- "activity"
colnames(y_train) <- "activity"
#Step2.	Merges the training and the test sets to create one data set
 ## Create test and train dataset using cbind 
testdata <- cbind(sub_test,y_test,x_test)
traindata <- cbind(sub_train,y_train,x_train)
 ## Create one dataset using rbind 
dataset <- rbind(testdata,traindata)
#Step3. Extracts only the measurements on the mean and standard deviation for each measurement.
 ##Create a vector with column numbers for the new data set. Use a regular expression to select columns contain mean() and std() on the names 
var<- c(1,2,grep("(mean\\(\\)|std\\(\\))",colnames(dataset)))
 ##Subsetting coiumns to new dataset - tdata
tdata <- (dataset[,var])
#Step4. Uses descriptive activity names to name the activities in the data set
 ## Read file with activity labels to data.frame and rename it's columns
act<-read.table("data/activity_labels.txt")
colnames(act)<-c("activity", "activityNames")
 ## Replace activity codes in tdata on name the activities from act
tdata$activity <- factor(tdata$activity, labels = act$activityNames)
#Step5.	Appropriately labels the data set with descriptive variable names
 ## Remove "(" and ")" from variable names on tdata
colnames(tdata) <- gsub("\\)","",colnames(tdata))
colnames(tdata) <- gsub("\\(","",colnames(tdata))
#Step6. Creating a second, independent tidy data set with the average of each variable for each activity and each subject.
 ## Create second data set 
datagroup <- tbl_df(tdata)
 ## Group data set by subject and then by activity, and summarise each variable using function "mean".
summary_data <- datagroup %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))
## Write dataset in txt file
write.table(summary_data, "tidy_data.txt", row.names = FALSE)
