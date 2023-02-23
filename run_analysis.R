library(tidyverse)

# 1. Merges the training and the test sets to create one data set.
train_df <- read.table('data/uci-har-dataset/train/X_train.txt')
test_df <- read.table('data/uci-har-dataset/test/X_test.txt')
one_df <- rbind(train_df, test_df)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
col_names <- read.table('data/uci-har-dataset/features.txt')
col_names_mean <- col_names |>
  filter(grepl('mean()', V2, fixed = TRUE))

col_names_std <- col_names |>
  filter(grepl('std()', V2, fixed = TRUE))

col_names_mean_std <- rbind(col_names_mean, col_names_std)

col_names_mean_std_index <- col_names_mean_std[['V1']]

df <- one_df |>
  select(col_names_mean_std_index)

# 3. Uses descriptive activity names to name the activities in the data set
train_activity_df <- read.table('data/uci-har-dataset/train/Y_train.txt')
test_activity_df <- read.table('data/uci-har-dataset/test/Y_test.txt')
activity_names_ids <- rbind(train_activity_df, test_activity_df)

activity_labels <- read.table('data/uci-har-dataset/activity_labels.txt')

activity_names <- activity_names_ids |>
  inner_join(activity_labels)

df$activities = activity_names[[2]]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(df) <- append( col_names_mean_std[[2]], 'activities')

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
train_subject_df <- read.table('data/uci-har-dataset/train/subject_train.txt')
test_subject_df <- read.table('data/uci-har-dataset/test/subject_test.txt')
subjects_df <- rbind(train_subject_df, test_subject_df)

df$subject <- subjects_df[[1]]

step5df <- df |>
  group_by(activities, subject) |>
  summarise(across(1:66, mean))

# write final data frame
write.table(step5df, 'df.txt', row.names = FALSE)
