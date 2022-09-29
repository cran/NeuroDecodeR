## ----attach_libraries, message=FALSE, warning=FALSE---------------------------

library(NeuroDecodeR)
library(ggplot2)
library(dplyr)
library(tidyr)


## ----bin_data, results = 'hide', message = FALSE------------------------------

raster_dir_name <- file.path(system.file("extdata", package = "NeuroDecodeR"), 
                             "Zhang_Desimone_7object_raster_data_small_rda")

bin_width <- 400
step_size <- 400
start_time <- 100
end_time <- 500
save_dir_name <- tempdir()

# Note: this code might run quicker if more parallel cores are used
binned_file_name <- create_binned_data(raster_dir_name, file.path(save_dir_name, "ZD"), 
                                       bin_width, step_size, start_time, end_time, 
                                       num_parallel_cores = 2)


# The name of a binned file that has data from more neurons in it that will be
# used for subsequent analyses. This raster data went into this binned format
# data was excluded from the NeuroDecodeR package to keep the package size small.
binned_file_name <- system.file(file.path("extdata", 
                                          "ZD_400bins_400sampled_start100_end500.Rda"),
                                package="NeuroDecodeR")



## ----cl_fp_and_rm_objects-----------------------------------------------------

cl <- cl_max_correlation()
fps <- list(fp_zscore())
rms <- list(rm_main_results(), rm_confusion_matrix())


## ----ds_generalization_create-------------------------------------------------

id_base_levels <- c("hand", "flower", "guitar", "face", "kiwi", "couch",  "car")   

train_levels <- NULL
test_levels <- NULL

for (i in seq_along(id_base_levels)){
   
  train_levels[[i]] <- c(paste(id_base_levels[i], "upper",sep = '_'), 
                              paste(id_base_levels[i], "middle",sep = '_'))
  
  test_levels[[i]] <- paste(id_base_levels[i], "lower",sep = '_')
  
}


ds <- ds_generalization(binned_file_name, 'combined_ID_position', num_cv_splits = 18,  
                       train_label_levels = train_levels, test_label_levels = test_levels)


## ----ds_generalization_run----------------------------------------------------

# create the cross-validator
cv <- cv_standard(datasource = ds, 
                  classifier = cl, 
                  feature_preprocessors = fps, 
                  result_metrics = rms, 
                  num_resample_runs = 2)

# run the decoding analysis (and time how long it takes to run)
tictoc::tic()
DECODING_RESULTS <- run_decoding(cv)
tictoc::toc()

# show the zero-one loss decoding accuracy (chance is 1/7)
DECODING_RESULTS$rm_main_results$zero_one_loss


## ----generalization_analysis_all_locations------------------------------------
 

results_dir_name <- trimws(file.path(tempdir(), "position_invariance_results", " "))


# If this code has been run before, delete any results that have been saved 
if (file.exists(results_dir_name)){
  the_files <- paste0(results_dir_name, list.files(results_dir_name))
  file.remove(the_files)
  file.remove(results_dir_name)
} 


dir.create(results_dir_name)

id_base_levels <- c("hand", "flower", "guitar", "face", "kiwi", "couch",  "car")   
pos_base_levels <- c("upper", "middle", "lower")
 

# loop over all training and test position permutations
for (iTrainPos in 1:3) {
  for (iTestPos in 1:3) { 
   
    # create the training and test label levels
    train_levels <- list()
    test_levels <- list()
    for (iID in 1:7) {
        train_levels[[iID]] <- c(paste(id_base_levels[iID], pos_base_levels[iTrainPos], sep = '_'))
        test_levels[[iID]] <- c(paste(id_base_levels[iID], pos_base_levels[iTestPos], sep = '_'))
    }
    
    
    # create the ds_generalization data source
    ds <- ds_generalization(binned_file_name, 'combined_ID_position', num_cv_splits = 18,  
                       train_label_levels = train_levels, test_label_levels = test_levels)

    
    # create the cross-validator
    cv <- cv_standard(datasource = ds, 
                  classifier = cl, 
                  feature_preprocessors = fps, 
                  result_metrics = rms, 
                  num_resample_runs = 2)
    
    # run the decoding analysis (and time how long it takes to run
    tictoc::tic()
    DECODING_RESULTS <- run_decoding(cv)
    tictoc::toc()

    # create a name for the saved results
    result_name <- paste("train ", pos_base_levels[iTrainPos], "test", pos_base_levels[iTestPos])
    
    # save the results
    log_save_results(DECODING_RESULTS, results_dir_name, result_name)


  }
}



## ----plot_results-------------------------------------------------------------
 

# compile all the results that were saved

all_results <- data.frame()

for (iTrainPos in 1:3) {
  for (iTestPos in 1:3) { 
    
    # get the name of the result and load them 
    result_name <- paste("train ", pos_base_levels[iTrainPos], "test", pos_base_levels[iTestPos])

    DECODING_RESULTS <- log_load_results_from_result_name(result_name, results_dir_name)

    curr_results <- data.frame(decoding_accuracy = 100 * DECODING_RESULTS$rm_main_results$zero_one_loss,
                                        train_location = paste("Train", pos_base_levels[iTrainPos]),
                                        test_location = pos_base_levels[iTestPos])
    
    all_results <- rbind(all_results, curr_results)
    
  }
}



# plot the results

all_results |>
  ggplot(aes(test_location, decoding_accuracy)) + 
  geom_col(fill = "blue") + 
  geom_hline(yintercept = 1/7 * 100) + 
  facet_wrap(~train_location) + 
  ylab("Decoding Accuracy") + 
  xlab("Test location")  



