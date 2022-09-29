## ----load_raster_file---------------------------------------------------------

raster_dir_name <- file.path(system.file("extdata", package = "NeuroDecodeR"), "Zhang_Desimone_7object_raster_data_small_rda")
full_file_name <- file.path(raster_dir_name, "bp1001spk_01A_raster_data.rda")

# test the file is in valid raster format
NeuroDecodeR::test_valid_raster_format(full_file_name)

# load the data to see the variables in it
load(full_file_name)
head(raster_data[, 1:10])


## ----load_binned_file---------------------------------------------------------

binned_file_name <- system.file("extdata/ZD_150bins_50sampled.Rda", package="NeuroDecodeR")


# test the file is in valid binned format using an internal function
NeuroDecodeR:::test_valid_binned_format(binned_file_name)


# load the data to see the variables in it
load(binned_file_name)
head(binned_data[, 1:10])



