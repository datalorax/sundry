% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_files.R
\name{read_files}
\alias{read_files}
\title{Read a batch of files}
\usage{
read_files(dir = ".", pat = "*.csv|*.sav|*.xls|*.xlsx|*.txt", df = TRUE,
  ...)
}
\arguments{
\item{dir}{Directory where files are stored. Defaults to the current
working directory}

\item{pat}{Optional string pattern of files in the directory}

\item{df}{Logical. Should the function try to read the files in as a single
data frame? Defaults to \code{TRUE}. A list of data frames are returned
if \code{FALSE}.}

\item{...}{Additonal arguments passed to \code{\link[rio]{import}} (e.g.,
\code{delim}).}
}
\description{
Read a batch of files
}
