% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/collapse_dems.R
\name{collapse_dems}
\alias{collapse_dems}
\title{Collapse demographic variables across *n* years}
\usage{
collapse_dems(d, pat, seed = 100, print = TRUE)
}
\arguments{
\item{d}{Data frame which includes the variables to be collapsed}

\item{pat}{Common string pattern represented in all variables to be
collapsed.}

\item{seed}{Seed to set for reproducibility. Defaults to 100.}

\item{print}{Logical. Should the number of students who were assigned
based on a majority rule and the number of students who were randomly
assigned be printed to the console? Defaults to \code{TRUE}.}
}
\value{
Factor vector of demographic data with the properties described
above. The number of
}
\description{
This function will collapse demographic variables across years into a single
vector. If demographics vary across years, it will return the most common
value (i.e., majority rule). If there is a tie, it will randomly select from
the tied demographic values. If there are missing data across any of the
years, the value from the observed years will be retained. In other words,
the function can be helpful for collapsing demographic data even when no
demographic values vary.
}
