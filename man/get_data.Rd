% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generic_functions.R
\name{get_data}
\alias{get_data}
\title{A datasource (DS) method to generate training and test sets}
\usage{
get_data(ds_obj)
}
\arguments{
\item{ds_obj}{The datasource object.}
}
\value{
This method returns a data frame where each row corresponds to a
data from one time point on a single trial.
\itemize{
\item \emph{train_labels}: The labels that should be used when training the classifier.
\item \emph{test_labels}: The labels that should be used when the classifier
is tested. Note, this can be different than the training labels when
remapping the data using the \code{\link[=ds_generalization]{ds_generalization()}} data source.
\item \emph{time_bin}: The time bin where the data point came from.
\item \emph{site_XXXX}: A set of columns with neural activity from each site.
\item \emph{CV_XX}: A set of columns that indicate for each
cross-validation split whether a data point belongs to the training or test
set.
}
}
\description{
This is a function that must be implemented by all DS objects. This method
should not be called directly but instead it is used internally by the
cross-validator (CV) object.
}
\seealso{
\code{\link[=ds_basic]{ds_basic()}}, \code{\link[=ds_generalization]{ds_generalization()}}
}
\keyword{internal}
