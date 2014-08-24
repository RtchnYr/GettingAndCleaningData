Objectives of this project described in https://class.coursera.org/getdata-
006/human_grading/view/courses/972584/assessments/3/submissions:
"
 You should create one R script called run_analysis.R that does the following. 

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
"

Script run_analysis.R: 
-merge trainig and test data in dataframe named "data"
-load information about features and activity labels
-create list of features with "mean(" or "std(" in feature description (dataframe "filtered_features") 
-processed data to result1 dataframe using smaller feature set, adding activity labels and descriptive "variable" (I suppose columns) names
-group by data by subject and activity labels, calculating average values for filtered features

I use "sqldf" package to know it's capability, and I'm familiar with SQL so it's convenient for me to do "joins" and "group by" in SQL.  
