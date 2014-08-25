install.packages("sqldf")
library(sqldf)
library(stringr)

#Objectives of this scipts described in  
#https://class.coursera.org/getdata-006/human_grading/view/courses/972584/assessments/3/submissions

getData<-function(type)
{
    #Get training or testing data.
    #Input parameter "type" should be "test" or "train" 
    #"UCI HAR Dataset" directory with appropriate file should be in working directory
    
    x<-read.table(str_replace_all("./UCI HAR Dataset/TYPE/X_TYPE.txt", 
                                  "TYPE", type))
    y<-read.table(str_replace_all("./UCI HAR Dataset/TYPE/y_TYPE.txt", 
                                  "TYPE", type))
    subject<-read.table(str_replace_all("./UCI HAR Dataset/TYPE/subject_TYPE.txt", 
                                        "TYPE", type))
    colnames(y)[1] = "ActivityID"
    colnames(subject)[1] = "SubjectID"    
    cbind(x, y, subject)    
}

#Task:  "1. Merges the training and the test sets to create one data set."
data<-rbind(getData("test"), getData("train"))

#Tasks: "2. Extracts only the measurements on the mean and standard deviation for each measurement." 
#       "3. Uses descriptive activity names to name the activities in the data set."
#       "4. Appropriately labels the data set with descriptive variable names." 

#Comment:   Use only features with "mean(" or "std(" in features names.
#           "Descriptive activity names" take from activity_labels.txt
#           "Descriptive variable names" take from features.txt    
#           Required by tasks 2-4 dataset will be in result1 dataframe.

activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels)[1] = "ActivityID"
colnames(activity_labels)[2] = "ActivityLabel"

features<-read.table("./UCI HAR Dataset/features.txt")
sql<-"
select V1 as ID, V2 as feature 
from features 
where V2 like '%mean(%' or V2 like '%std(%'"
filtered_features<-sqldf(sql)

sqlFieldList<-""
for(row in 1:nrow(filtered_features))
{
    sqlFieldList<-paste0(sqlFieldList, ", V", filtered_features$ID[row], " AS ",
                         "[", filtered_features$feature[row], "]")
}
sql<-paste0("
    select activity_labels.ActivityLabel, data.SubjectID",
            sqlFieldList,        
            "        
    from data inner join activity_labels on 
    activity_labels.ActivityID = data.ActivityID    
    ")
result1<-sqldf(sql)

#Task:  "5. Creates a second, independent tidy data set with the average of each 
#       variable for each activity and each subject."

sqlFieldList<-""

for(row in 1:nrow(filtered_features))
{
    sqlFieldList<-paste0(sqlFieldList, ", avg(V", filtered_features$ID[row],")")
}
sql<-paste0("
    select activity_labels.ActivityLabel, data.SubjectID",
    sqlFieldList,        
    "        
    from data inner join activity_labels on 
    activity_labels.ActivityID = data.ActivityID
    group by data.ActivityID, activity_labels.ActivityLabel, data.SubjectID
    order by activity_labels.ActivityLabel, data.SubjectID
    ")
result2<-sqldf(sql)
for(row in 1:nrow(filtered_features))
{
    colnames(result2)[row+2] = filtered_features$feature[row]
}
write.table(result2, file ="./result.txt", row.names = FALSE)
result2
