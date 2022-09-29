## ---- echo = FALSE, warning=FALSE---------------------------------------------
library(NeuroDecodeR)

## -----------------------------------------------------------------------------

data_file_name <- system.file("extdata/ZD_150bins_50sampled.Rda", package="NeuroDecodeR")
ds <- ds_basic(data_file_name, 'stimulus_ID', 18)

all_cv_data <- get_data(ds)  
 
names(all_cv_data)


## ---- echo = FALSE, message=FALSE, warning=FALSE------------------------------
library(NeuroDecodeR)
library(dplyr)

## -----------------------------------------------------------------------------

# create a ds_basic to get the data
data_file_name <- system.file("extdata/ZD_150bins_50sampled.Rda", package="NeuroDecodeR")
ds <- ds_basic(data_file_name, 'stimulus_ID', 18)
cv_data <- get_data(ds)  
 

# an example of spliting the data into a training and test set, 
# this is done in the cross-validator
training_set <- dplyr::filter(cv_data, 
                              time_bin == "time.100_250", 
                              CV_1 == "train") %>%       # get data from the first CV split
  dplyr::select(starts_with("site"), train_labels)
        
test_set <- dplyr::filter(cv_data, CV_1 == "test") %>%   # get data from the first CV split
  dplyr::select(starts_with("site"), test_labels, time_bin) 



# use the fp object to normalize the data 
fp <- fp_zscore()
processed_data <- preprocess_data(fp, training_set, test_set)

# prior to z-score normalizing the mean (e.g. for site 1) is not 0
mean(training_set$site_0001)

# after normalizing the data the mean is pretty much 0
mean(processed_data$training_set$site_0001)



## ---- echo = FALSE, message=FALSE, warning=FALSE------------------------------
library(NeuroDecodeR)
library(dplyr)

## -----------------------------------------------------------------------------

# create a ds_basic to get the data
data_file_name <- system.file("extdata/ZD_150bins_50sampled.Rda", package="NeuroDecodeR")
ds <- ds_basic(data_file_name, 'stimulus_ID', 18)
cv_data <- get_data(ds)  
 

# an example of spliting the data into a training and test set, 
# this is done in the cross-validator
training_set <- dplyr::filter(cv_data, 
                              time_bin == "time.100_250", 
                              CV_1 == "train") %>%       # get data from the first CV split
  dplyr::select(starts_with("site"), train_labels)
        
test_set <- dplyr::filter(cv_data, CV_1 == "test") %>%   # get data from the first CV split
  dplyr::select(starts_with("site"), test_labels, time_bin) 



# use the cl object to make predictions 
cl <- cl_max_correlation()
predictions <- get_predictions(cl, training_set, test_set)

names(predictions)


# see how accurate the predictions are (chance is 1/7)
predictions_at_100ms <- dplyr::filter(predictions, test_time == "time.100_250")
mean(predictions_at_100ms$actual_labels == predictions_at_100ms$predicted_labels)



