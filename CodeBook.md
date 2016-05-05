# UCI HAR CodeBook


For source data, see http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Full data set is  
 
 * fullSet.csv
 
Summarized set is 

 * summary.csv

To derive data sets, source data had undergone following transformations:

 * Removal of all variables not containing "std()" or "mean()" patterns
 * Integration of SUBJECT and ACTIVITY columns into the set
 * Merging of "train" and "test" sets
 * For summarized set, mean across subject and activity variables was taken
 * In addition, variable names had been adjusted for clarity and readability

Variables (in addition to the ones described in features.txt in the original data set:

 * Activity: Activity name
 * Subject: subject ID (1 through 30)

Following changes were made to retained variables from the original set (described in features_info.txt)

* Removed "t" prefix
* Changed "f" prefix to "FFT_"
* Changed std() and mean() to "std" and "mean", respectively
* Changed all punctuation in variable names to single underscores ("_")
