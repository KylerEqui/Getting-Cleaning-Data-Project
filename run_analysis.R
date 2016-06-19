if(!file.exists("./UCIdata")){dir.create("./UCIdata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./UCIdata/GCdata.zip", method = "libcurl")
unzip(zipfile = "./UCIdata/GCdata.zip", exdir="./UCIdata")

path_fd <- file.path("./UCIdata", "UCI HAR Dataset")

yTest  <- read.table(file.path(path_fd, "test", "Y_test.txt"), header = FALSE)
yTrain <- read.table(file.path(path_fd, "train", "Y_train.txt"), header = FALSE)

SubjectTest  <- read.table(file.path(path_fd, "test", "subject_test.txt"), header = FALSE)
SubjectTrain <- read.table(file.path(path_fd, "train", "subject_train.txt"), header = FALSE)

xTest  <- read.table(file.path(path_fd, "test" , "X_test.txt" ),header = FALSE)
xTrain <- read.table(file.path(path_fd, "train", "X_train.txt"),header = FALSE)



#connecting the data

dataActivity <- rbind(yTest,yTrain)
dataSubject  <- rbind(SubjectTest,SubjectTrain)
dataFeatures <- rbind(xTest, xTrain)

#setting names to the variables

names(dataActivity) <- c("activity")
names(dataSubject)  <- c("subject")

dataFeaturesNames <- read.table(file.path(path_fd, "features.txt"),head=FALSE)
names(dataFeatures) <- dataFeaturesNames$V2

dataMerged <- cbind(dataSubject, dataActivity)
Data       <- cbind(dataFeatures, dataMerged)


#Only measurements on the Mean and Standard Deviation

subdataFeaturesNames <- dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectednames <- c(as.character(subdataFeaturesNames), "subject", "activity")

Data <- subset(Data, select=selectednames)

#Descriptive Activity Names to name the activities in the data set

activitylabels <- read.table(file.path(path_fd, "activity_labels.txt"), header = FALSE)

Data$activity <- factor(Data$activity);
Data$activity <- factor(Data$activity, labels = as.character(activitylabels$V2))

#Descriptive Labels

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


TidyData <- aggregate(.~subject + activity, Data, mean)
TidyData <- TidyData[order(TidyData$subject,TidyData$activity),]
write.table(TidyData, "TidyData.txt", row.name=FALSE)









