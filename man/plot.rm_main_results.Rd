% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rm_main_results.R
\name{plot.rm_main_results}
\alias{plot.rm_main_results}
\title{A plot function for the rm_main_results object}
\usage{
\method{plot}{rm_main_results}(x, ..., results_to_show = "zero_one_loss", type = "TCD")
}
\arguments{
\item{x}{A rm_main_result object that has aggregated runs from a
decoding analysis, e.g., if DECODING_RESULTS are the out from the
run_decoding(cv) then this argument should be
\code{DECODING_RESULTS$rm_main_results}.}

\item{...}{This is needed to conform to the plot generic interface.}

\item{results_to_show}{A string specifying the types of results to plot. Options
are: 'zero_one_loss', 'normalized_rank', 'decision_values', or 'all'.}

\item{type}{A string specifying the type of results to plot. Options are
'TCD' to plot a temporal cross decoding matrix or 'line' to create a line
plot of the decoding results as a function of time.}
}
\value{
Returns a ggplot object that plots the main results.
}
\description{
This function can create a line plot of the results or temporal
cross-decoding results for the the zero-one loss, normalized rank and/or
decision values after the decoding analysis has been run (and all results
have been aggregated).
}
\seealso{
Other result_metrics: 
\code{\link{plot.rm_confusion_matrix}()},
\code{\link{plot_main_results}()},
\code{\link{rm_confusion_matrix}()},
\code{\link{rm_main_results}()}
}
\concept{result_metrics}
