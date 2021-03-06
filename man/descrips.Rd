% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/descrips.R
\name{descrips}
\alias{descrips}
\title{Pipe-friendly descriptive stats}
\usage{
descrips(data, ..., .funs = dplyr::funs(n(), min(., na.rm = TRUE), max(.,
  na.rm = TRUE), mean(., na.rm = TRUE), sd(., na.rm = TRUE)))
}
\arguments{
\item{data}{The data frame that includes the variables to compute
descriptive statistics on.}

\item{...}{The set of variables to compute descriptive statistics on.}

\item{.funs}{The functions to use in the descriptive statistics. Uses
the \code{\link[dplyr]{funs}} function. Defaults to the number of
observations, min, max, mean, and standard deviation.}
}
\value{
A tidy data frame with the requested descriptive statistics
for the requested variables
}
\description{
Generate any set of descriptive statistics through the pipeline
and return a tidy data frame. The function works with any number
of variables, as well as with \code{\link[dplyr]{group_by}}.
}
\examples{

library(dplyr)
library(magrittr)
storms \%>\%
  descrips(wind, pressure)

storms \%>\%
  group_by(year) \%>\%
  descrips(wind, pressure)

storms \%>\%
  group_by(year) \%>\%
  descrips(wind, pressure, .funs = funs(median, n()))
}
