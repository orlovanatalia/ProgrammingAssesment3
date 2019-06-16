sub_test<-read.table("data/test/subject_test.txt")
x_test<-read.table("data/test/X_test.txt")
y_test<-read.table("data/test/y_test.txt")
sub_train <- read.table("data/train/subject_train.txt")
x_train<-read.table("data/train/X_train.txt")
y_train<-read.table("data/train/y_train.txt")
feach<-read.table("data/features.txt")
colnames(x_test) <- feach[,"V2"]
colnames(x_train) <- feach[,"V2"]
colnames(sub_test) <- "subject"
colnames(sub_train) <- "subject"
colnames(y_test) <- "activity"
colnames(y_train) <- "activity"
testdata <- cbind(sub_test,y_test,x_test)
traindata <- cbind(sub_train,y_train,x_train)
dataset <- rbind(testdata,traindata)
var<- c(1,2,grep("(mean\\(\\)|std\\(\\))",colnames(dataset)))
tdata <- (dataset[,var])
act<-read.table("data/activity_labels.txt")
colnames(act)<-c("activity", "activityNames")
table(tdata$activity)
tdata$activity <- factor(tdata$activity, labels = act$activityNames)
colnames(tdata) <- gsub("\\)","",colnames(tdata))
colnames(tdata) <- gsub("\\(","",colnames(tdata))
datagroup <- tbl_df(tdata)
summary_data <- datagroup %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))
write.table(summary_data, "tidy_data.txt", row.names = FALSE)

