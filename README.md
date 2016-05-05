# UCI HAR Processor README


Following script is used: run_analysis.R
Code book is CodeBook.md

To run analysis, execute run_analysis.R

Requirements:


 * dplyr package is installed
 * data.table package is installed
 * UCI HAR data files are present, in the following structure (relative to working directory):
   * features.txt
   * activity_labels.txt
   * \test\subject_test.txt
   * \test\X_test.txt 
   * \test\y_test.txt
   * \train\subject_train.txt
   * \train\X_train.txt 
   * \train\y_train.txt

Processing is structured as follows:

 * process train data from the original set to get only std and mean aggregations along with matched activity and subject info 
 * process test data from the original set to get only std and mean aggregations along with matched activity and subject info 
 * merges 2 sets, cleans up column names, and performs summarization (mean) by activities and subjects


Full data set is saved as 
 
 * fullSet.csv
 
Summarized set is saved as 

 * summary.csv
