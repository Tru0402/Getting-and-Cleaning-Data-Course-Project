

getwd() ##Getting working directory

setwd("C:/Users/Brandon/Downloads/getdata-projectfiles-UCI HAR Dataset") ##Setting wd to where downloaded data is

list.files()

DataDir <- ("C:/Users/Brandon/Downloads/getdata-projectfiles-UCI HAR Dataset") ##Setting initial directory

DataDir2 <- paste(DataDir, "UCI HAR Dataset"     , sep = "/") ##Creating directory where data is stored

setwd(DataDir2) ##Setting working directory to where data is stored

list.files() ##Verifying this is where the data files are

feature   <- paste(DataDir2, "features.txt"        , sep = "/")
activity  <- paste(DataDir2, "activity_labels.txt" , sep = "/")
testdir  <- paste(DataDir2, "test"                , sep = "/")
traindir <- paste(DataDir2, "train"               , sep = "/")
mergedir <- paste(DataDir2, "merge"               , sep = "/")
output    <- paste(DataDir, "tidydataset.txt"            , sep = "/")


subjectmerge <- paste(mergedir, "subject_merge.txt", sep = "/")
xmerge <- paste(mergedir,       "X_merge.txt", sep = "/")
ymerge <- paste(mergedir,       "y_merge.txt", sep = "/")
subjecttest <- paste(testdir, "subject_test.txt", sep = "/")
xtest <- paste(testdir,       "X_test.txt", sep = "/")
ytest <- paste(testdir,       "y_test.txt", sep = "/")
subjecttrain <- paste(traindir, "subject_train.txt", sep = "/")
xtrain <- paste(traindir,       "X_train.txt", sep = "/")
ytrain <- paste(traindir,       "y_train.txt", sep = "/")

library(data.table) ##loading necessary
library(stringr)

if (!file.exists(mergedir)) {
  dir.create(mergedir)
}
if (file.exists(subjectmerge)) {file.remove(subjectmerge)}
if (file.exists(      xmerge)) {file.remove(      xmerge)}
if (file.exists(      ymerge)) {file.remove(      ymerge)}

file.copy(subjecttrain, subjectmerge); file.append(subjectmerge, subjecttest)
file.copy(      xtrain,       xmerge); file.append(      xmerge,       xtest)
file.copy(      ytrain,       ymerge); file.append(      ymerge,       ytest)

feature  <- read.table(feature , header=FALSE)
activity <- read.table(activity, header=FALSE)

subject  <- read.table(subjectmerge, header=FALSE)
X        <- read.table(      xmerge, header=FALSE)
y        <- read.table(      ymerge, header=FALSE)

header <- feature[grepl("mean|std",feature$V2),"V1"]
data1   <- data.table(cbind(subject, y, X[,header]))
name         <- feature$V2[header]
name         <- str_replace_all(name, "([-])" , "_" )
name         <- str_replace_all(name, "([()])", "" )
setnames(data1, c( "subject", "activity", as.character(name)))
data1$activity <- activity$V2[ data1$activity ]
tidydataset <- data1[, lapply(.SD,mean),by=list(activity,subject), .SDcols=3:dim(data1)[2]]
write.table(tidydataset, file=output, row.names=FALSE, col.names=TRUE, sep="\t", quote=FALSE)















