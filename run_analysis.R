
#libraries used for code
library(utils)
library(data.table)
library(dplyr)

#downloading zipped file from given URL
u<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
if (!file.exists('dataPA03')){dir.create('dataPA03')}
download.file(u, destfile = './dataPA03/dataPA03.zip', method = 'curl')
date_downloaded<-date()

#unzipping downloaded file using utils library
unzip('./dataPA03/dataPA03.zip', exdir = './dataPA03')

#creating list of .txt files in folder test
test_list<-list.files('./dataPA03/UCI HAR Dataset/test', pattern = '.txt',full.names = TRUE)
test_list

#reading in test data
subject_test<-read.table(test_list[1])
x_test<-read.table(test_list[2])
y_test<-read.table(test_list[3])

#combining together test data
df_test<-cbind(subject_test, y_test, x_test)

#checking dimension of created data frame
dim(df_test)

#creating list of .txt files in folder train
train_list<-list.files('./dataPA03/UCI HAR Dataset/train', pattern = '.txt',full.names = TRUE)
train_list

#reading in train data
subject_train<-read.table(train_list[1])
x_train<-read.table(train_list[2])
y_train<-read.table(train_list[3])

#combining together train data
df_train<-cbind(subject_train, y_train, x_train)

#checking dimension of created data frame
dim(df_train)

#combining together train and test data into one data frame
a_df<-rbind(df_test, df_train)

#checking dimension of created data frame
dim(a_df)

#creating list of .txt files in folder UCI HAR Dataset
list_all<-list.files('./dataPA03/UCI HAR Dataset', pattern = '.txt',full.names = TRUE)


act_names<-read.table(list_all[2])
act_names<-as.character(act_names[,2])

#getting activity labels
act_lab<-read.table(list_all[1])
act_lab

#assigning names to columns
colnames(a_df)[1]<-'subject.id'
colnames(a_df)[2]<-'activity'
colnames(a_df)[3:length(colnames(a_df))]<-act_names

#cheking if assigmnent worked
colnames(a_df)

#using data.table library to change activity labels from numbers to full name of activity
x<-data.table(a_df, key='activity')
y<-data.table(act_lab, key='V1')
df<-x[y]
df[,2]<-df[,564]
df<-df[,1:563]

#tidying up column names, removing unwanted characters
x<-colnames(df)
x<-gsub('-','.',x)
x<-sub('\\()','',x)
x<-sub('\\(','.',x)
x<-gsub('\\)','',x)
x<-gsub(',','.',x)
x<-sub('BodyBody','Body',x)
colnames(df)<-x

#changing class to be data frame
df<-as.data.frame(df)

#creating vector of characters containing desired names of colums
a<-c('subject.id','activity',grep('mean()' ,colnames(df), value=TRUE),grep('std()' ,colnames(df), value=TRUE))

#subseting data frame and creating new data frame which includes only desired columns
new_df<-df[,a]
dim(new_df)

#summarising data using dplyr to create final tidy data frame
final_df <- new_df %>%
  group_by(subject.id, activity) %>%
  summarise_all(funs(mean))

#checking if data contains missing values
sum(is.na(final_df))

#saving final data as txt file
write.table(final_df, file = 'final.txt', row.name=FALSE)

