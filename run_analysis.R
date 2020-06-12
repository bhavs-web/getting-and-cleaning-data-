library(plyr)
library(data.table)
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
xTrain = read.table('./train/x_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)

subjectTest = read.table('./test/subject_test.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
yTest = read.table('./test/y_test.txt',header=FALSE)

combinex <- rbind(xTrain, xTest)
combiney <- rbind(yTrain, yTest)
subjectDataSet <- rbind(subjectTrain, subjectTest)
dim(combinex)

dim(combiney)

dim(subjectDataSet)

combinex_m_sd <- combinex[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(combinex_m_sd) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
View(combinex_m_sd)
dim(combinex_m_sd)

combiney[, 1] <- read.table("activity_labels.txt")[combiney[, 1], 2]
names(combiney) <- "Activity"
View(combiney)

names(subjectDataSet) <- "Subject"
summary(subjectDataSet)

# organising and combining the data

organiseddata <- cbind(combinex_m_sd, combiney, subjectDataSet)

# descriptive names

names(organiseddata) <- make.names(names(organiseddata))
names(organiseddata) <- gsub('Acc',"Acceleration",names(organiseddata))
names(organiseddata) <- gsub('GyroJerk',"AngularAcceleration",names(organiseddata))
names(organiseddata) <- gsub('Gyro',"AngularSpeed",names(organiseddata))
names(organiseddata) <- gsub('Mag',"Magnitude",names(organiseddata))
names(organiseddata) <- gsub('^t',"TimeDomain.",names(organiseddata))
names(organiseddata) <- gsub('^f',"FrequencyDomain.",names(organiseddata))
names(organiseddata) <- gsub('\\.mean',".Mean",names(organiseddata))
names(organiseddata) <- gsub('\\.std',".StandardDeviation",names(organiseddata))
names(organiseddata) <- gsub('Freq\\.',"Frequency.",names(organiseddata))
names(organiseddata) <- gsub('Freq$',"Frequency",names(organiseddata))
View(organiseddata)

names(organiseddata)

Data2<-aggregate(. ~Subject + Activity, organiseddata, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

