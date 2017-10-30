# PA_Getting_and_Cleaning_Data
Transforming data info clean and tidy data set
## The repo includes the following files:

- 'README.md':  Gives information about repo content and steps for transforming data into clean data set.

- 'CodeBook.md': Shows information about data set and the variables.

- 'run_analysis.R': Script to clean data provided for Peer Assignment 'Getting and Cleaning Data.

## Work done to clean up the data:

1. Combined all provided data together into one data frame.
2. Changed numbers corresponding to 'Activities' for labels.
3. Removed all 'unwanted' characters from column's names.
4. Extracted only columns containing 'mean' and 'std' strings.
5. Summarised data by grouping by 'subject id' and 'activity' and calculating mean for each.
6. Saved final data frame as txt file.
