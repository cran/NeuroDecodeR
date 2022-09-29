## ----load_ZD_data-------------------------------------------------------------


# load a raster format data file
raster_dir_name <- file.path(system.file("extdata", package = "NeuroDecodeR"), "Zhang_Desimone_7object_raster_data_small_rda")
file_name <- "bp1001spk_01A_raster_data.rda"
load(file.path(raster_dir_name, file_name))


# load the 150 ms binned data
binned_file_name <- system.file("extdata/ZD_150bins_50sampled.Rda", package="NeuroDecodeR")
load(binned_file_name)


