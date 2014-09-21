#setwd("~/Courses/Coursera/Data Science/Getting and Cleaning Data/Week02/UCI HAR Dataset")
#The script will read the files in the current directory
#Check whether the files are in the current directory before running the script

#Check installed packages
this.dir <- dirname(parent.frame(2)$ofile) 
setwd(this.dir) 

#get the labels
actlabels <- read.table("./activity_labels.txt")
names(actlabels)  <- c("activityID", "activityType")

features <- read.table("./features.txt")

#Read Test data
testX <- read.table("./test/X_test.txt")
names(testX)  <- features[,2]
testX <- testX[, grep("-std|-mean", names(testX))]
testY <- read.table("./test/y_test.txt")
names(testY) <- c("activityID")
subTest <- read.table("./test/subject_test.txt")
names(subTest) <- c("subjectID")

testData <- cbind(testY,subTest,testX)

#Read Train data
trainX <- read.table("./train/X_train.txt")
names(trainX)  <- features[,2]
trainX <- trainX[, grep("-std|-mean", names(trainX))]
trainY <- read.table("./train/y_train.txt")
names(trainY) <- c("activityID")
subTrain <- read.table("./train/subject_train.txt")
names(subTrain) <- c("subjectID")

trainData <- cbind(trainY,subTrain,trainX)

#Combine train and test data all together
totalData <- rbind(testData,trainData)
#Sort by activityid, subjectID
totalData <- arrange(totalData, activityID, subjectID)


#Add labels for activities
totalData$activityName <- factor(totalData$activityID,
                                levels=actlabels$activityID, 
                                labels=actlabels$activityType)

#Write combined data to disk
write.table(totalData, "totalData.txt")

#Calculate means by activity, subject
totalMeans <- aggregate(totalData, by=list(activity=totalData$activityID,
                                name=totalData$activityName,
                                subject=totalData$subjectID
                                )
                        ,mean)


#Remove redundant columns 
totalMeans <- totalMeans[,!(names(totalMeans) %in% c("activityID",
                                "subjectID", "activityName"))]

#write file meansData.txt
write.table(totalMeans, "meansData.txt",row.name=FALSE)
