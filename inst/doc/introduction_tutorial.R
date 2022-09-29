## ----load_libraries, message=FALSE, warning=FALSE-----------------------------

library(NeuroDecodeR)
library(ggplot2)
library(dplyr)
library(tidyr)


## ----load_raster_file---------------------------------------------------------

raster_dir_name <- file.path(system.file("extdata", package = "NeuroDecodeR"),
                             "Zhang_Desimone_7object_raster_data_small_rda")
file_name <- "bp1001spk_01A_raster_data.rda"
load(file.path(raster_dir_name, file_name))

test_valid_raster_format(file.path(raster_dir_name, file_name))


## ----plot_raster_file---------------------------------------------------------

plot(raster_data)


## ----bin_data, eval = FALSE---------------------------------------------------
#  
#  library(NeuroDecodeR)
#  
#  save_dir_name <- tempdir()
#  
#  binned_file_name <- create_binned_data(raster_dir_name, file.path(save_dir_name, "ZD"),
#                                         150, 50, num_parallel_cores = 2)
#  

## ----label_repetitions--------------------------------------------------------

binned_file_name <- system.file("extdata/ZD_150bins_50sampled.Rda", package="NeuroDecodeR")
label_rep_info <- get_num_label_repetitions(binned_file_name, "stimulus_ID") 
plot(label_rep_info)  


## ----datasource---------------------------------------------------------------

binned_file_name <- system.file(file.path("extdata", "ZD_150bins_50sampled.Rda"),
                                package="NeuroDecodeR")
variable_to_decode <- "stimulus_ID"
num_cv_splits <- 20
  
ds <- ds_basic(binned_file_name, variable_to_decode, num_cv_splits)
  

## ----feature_preprocessor-----------------------------------------------------

# note that the FP objects are stored in a list
#  which allows multiple FP objects to be used in one analysis
 
fps <- list(fp_zscore())


## ----classifier---------------------------------------------------------------
 
cl <- cl_max_correlation()


## ----result_metrics-----------------------------------------------------------
 
rms <- list(rm_main_results(), rm_confusion_matrix())


## ----cross_validator----------------------------------------------------------
 
cv <- cv_standard(datasource = ds, 
                  classifier = cl, 
                  feature_preprocessors = fps, 
                  result_metrics = rms, 
                  num_resample_runs = 2)


## ----run_decoding-------------------------------------------------------------
 
DECODING_RESULTS <- run_decoding(cv)


## ----plot_tcd-----------------------------------------------------------------

plot(DECODING_RESULTS$rm_main_results)


## ----plot_line----------------------------------------------------------------

plot(DECODING_RESULTS$rm_main_results, results_to_show = 'all', type = 'line')


## ----plot_confusion_matrix----------------------------------------------------

plot(DECODING_RESULTS$rm_confusion_matrix)


## ----plot_MI------------------------------------------------------------------

plot(DECODING_RESULTS$rm_confusion_matrix, results_to_show = "mutual_information")


## ----save_results-------------------------------------------------------------

results_dir_name <- file.path(tempdir(), "results", "")
dir.create(results_dir_name)

log_save_results(DECODING_RESULTS, results_dir_name)


## ----ndr_piping_example-------------------------------------------------------

basedir_file_name <- system.file(file.path("extdata", "ZD_500bins_500sampled.Rda"), 
                                   package="NeuroDecodeR")
  
  DECODING_RESULTS <- basedir_file_name |>
    ds_basic('stimulus_ID', 6, num_label_repeats_per_cv_split = 3) |>
    cl_max_correlation() |>
    fp_zscore() |>
    rm_main_results() |>
    rm_confusion_matrix() |>
    cv_standard(num_resample_runs = 2) |>
    run_decoding()
  
  plot(DECODING_RESULTS$rm_confusion_matrix)


