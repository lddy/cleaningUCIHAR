#processes and cleans data sets from UCI HAR set 
#author: Igor Levine: iglevi@gmail.com
#5/1/2016

fileselector<-"train"
#fileselector<-"test"

X_file<-paste0("./",fileselector,"/X_",fileselector,".txt")
y_file<-paste0("./",fileselector,"/y_",fileselector,".txt")
subject_file<-paste0("./",fileselector,"/subject_",fileselector,".txt")
output_file<-paste0("cleaned_",fileselector,"_set.csv")

#extracts numeric values from space separated list of numerics, filtering 
#for desired values using "keep" vector 
ExtractColVals  <- function (x, keep)
{
  splitline<-strsplit(x," ")
  splitlineelem<-splitline[[1]]
  isnotempty<-sapply(splitlineelem, function(x){x!=""})
  values<-sapply(splitlineelem[isnotempty],as.numeric)
  stdmeanvals<-values[keep]
  return (stdmeanvals)
}

#read main data file
xtr<-read.csv(X_file, header = FALSE)
xtr$Lines<-as.character(xtr$V1)

#read activity ID data
ytr<-read.csv(y_file, header = FALSE)
names(ytr)<-"actcode"

#read subject code data
str<-read.csv(subject_file, header = FALSE)

#read activity labels
actnames<-read.csv("activity_labels.txt", header=FALSE)
names(actnames)<-"actlabel"
#remove numeric IDs - row index can be used for that
actnames$actlabel<-gsub("[0-9] ","",actnames$actlabel)

#map activity IDs to labels
for(i in 1:nrow(ytr))ytr$actlabel[i]<-actnames$actlabel[ytr$actcode[i]]

#read feature list
features<-read.csv("features.txt", header=FALSE, sep=" ")
names(features)<-c("index","feature")
features$feature<-sapply(features$feature, as.character)
#find positions of "mean()" and "std()" features
tokeep<-grepl("mean\\(\\)|std\\(\\)",features$feature,perl=TRUE)
#record features we will keep
colnames<-features[tokeep,]

allObs<-data.frame()
#extract only needed features and arrange observations from xtr into a data frame
for(i in 1:nrow(xtr))allObs<-rbind(allObs,ExtractColVals(xtr$Lines[i], tokeep))
#add names
names(allObs)<-colnames$feature

#make finalSet dataframe, adding Activity and Subject columns
finalSet<-data.frame(ytr$actlabel, str[,1], allObs)
names(finalSet)[1:2]<-c("Activity","Subject")

#fix some of the column names for readability and clarity
names(finalSet)<-gsub("\\.\\.","()", names(finalSet), perl=TRUE)
names(finalSet)<-gsub("\\.","_", names(finalSet), perl=TRUE)
names(finalSet)<-gsub("^t","", names(finalSet), perl=TRUE)
names(finalSet)<-gsub("^f","FFT_", names(finalSet), perl=TRUE)

#save the dataset
write.csv(finalSet, file=output_file)

#reusing all large frames to load test set

#fileselector<-"train"
fileselector<-"test"


X_file<-paste0("./",fileselector,"/X_",fileselector,".txt")
y_file<-paste0("./",fileselector,"/y_",fileselector,".txt")
subject_file<-paste0("./",fileselector,"/subject_",fileselector,".txt")
output_file<-paste0("cleaned_",fileselector,"_set.csv")


#read main data file
xtr<-read.csv(X_file, header = FALSE)
xtr$Lines<-as.character(xtr$V1)

#read activity ID data
ytr<-read.csv(y_file, header = FALSE)
names(ytr)<-"actcode"

#read subject code data
str<-read.csv(subject_file, header = FALSE)

#read activity labels
actnames<-read.csv("activity_labels.txt", header=FALSE)
names(actnames)<-"actlabel"
#remove numeric IDs - row index can be used for that
actnames$actlabel<-gsub("[0-9] ","",actnames$actlabel)

#map activity IDs to labels
for(i in 1:nrow(ytr))ytr$actlabel[i]<-actnames$actlabel[ytr$actcode[i]]

#read feature list
features<-read.csv("features.txt", header=FALSE, sep=" ")
names(features)<-c("index","feature")
features$feature<-sapply(features$feature, as.character)
#find positions of "mean()" and "std()" features
tokeep<-grepl("mean\\(\\)|std\\(\\)",features$feature,perl=TRUE)
#record features we will keep
colnames<-features[tokeep,]

allObs<-data.frame()
#extract only needed features and arrange observations from xtr into a data frame
for(i in 1:nrow(xtr))allObs<-rbind(allObs,ExtractColVals(xtr$Lines[i], tokeep))
#add names
names(allObs)<-colnames$feature

#make finalSet dataframe, adding Activity and Subject columns
finalSet<-data.frame(ytr$actlabel, str[,1], allObs)
names(finalSet)[1:2]<-c("Activity","Subject")

#fix some of the column names for readability and clarity
names(finalSet)<-gsub("\\.\\.","()", names(finalSet), perl=TRUE)
names(finalSet)<-gsub("\\.","_", names(finalSet), perl=TRUE)
names(finalSet)<-gsub("^t","", names(finalSet), perl=TRUE)
names(finalSet)<-gsub("^f","FFT_", names(finalSet), perl=TRUE)

#save the dataset
write.csv(finalSet, file=output_file)

#read train and test sets from files: less efficient but guarantees that they were
#processed and saved as expected
trSet<-read.csv("cleaned_train_set.csv", header = TRUE)
tsSet<-read.csv("cleaned_test_set.csv", header = TRUE)

library(dplyr)
library(data.table)

joinset<-union(trSet,tsSet)
#fix ".." introduced into names when re-loading csv
names(joinset)<-gsub("\\.\\.","", names(joinset), perl=TRUE)
joinset<-select(joinset,c(2:ncol(joinset)))

#sort the data
joinset<-arrange(joinset, Subject, Activity)


#save master set
write.csv(joinset, file="fullSet.csv")

#both subject and feature are factors for grouping below
joinset$Subject<-sapply(joinset$Subject, as.factor)

#convert to data.table
dtjs<-data.table(joinset)

#calculate averages for Subject-Activity groups
group_cols<-names(joinset)[1:2]
summary<-dtjs[, lapply(.SD,mean), by=group_cols]
summary<-arrange(summary, Subject, Activity)

#pre-pend groupAVG to averaged values to make it clear those are not original measurements/aggregations 
for(i in 3:length(names(summary)))names(summary)[i]<-paste0("groupAVG_", names(summary)[i])

#save summary set
write.csv(summary, file="summary.csv")
