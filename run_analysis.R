library(reshape2)

#Read activity_labels.txt
dsActivityLabel <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Read features.txt
dsFeatures <- read.table("./UCI HAR Dataset/features.txt")


#Read Xtest datasets
dsXTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
dsYTest <- read.table("./UCI HAR Dataset/test/Y_test.txt")
dsSTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Set column names to dataset Test
colnames(dsXTest) <- dsFeatures$V2
#Add Cols
dsXTest$Activity <- dsYTest$V1
dsXTest$Subject <- factor(dsSTest$V1)
#Filter out unwanted columns
dsXTestFiltered <- dsXTest[,grepl("mean|std|Activity|Subject",colnames(dsXTest))]


#Read train datasets
dsXTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
dsYTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")
dsSTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Set column names to dataset Train
colnames(dsXTrain) <- dsFeatures$V2
#Add Cols
dsXTrain$Activity <- dsYTrain$V1
dsXTrain$Subject <- factor(dsSTrain$V1)
#Filter out unwanted columns
dsXTrainFiltered <- dsXTrain[,grepl("mean|std|Activity|Subject",colnames(dsXTrain))]

#Bind both tables into Master
dsMaster <- rbind(dsXTestFiltered,dsXTrainFiltered)
#Assign descriptive labels for Activity
dsMaster$ActivityLabels <- factor(dsMaster$Activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))


#Tidy dataset
dsMelted <- melt(dsMaster, id = c("Subject", "ActivityLabels"))
dsTidy <- dcast(dsMelted, Subject + ActivityLabels ~ variable, mean)
write.table(dsTidy, "./dsTidy.txt", row.names = FALSE, quote = FALSE)
