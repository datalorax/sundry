#' Easily see variable index locations
#'
#' Function returns the variable names and their location in a data frame (the
#' row names index their locations)
#'
#' @param d Data frame from which to report variable names and their locations
#'
#' @return data frame of the names from the dataset and their location as the
#' row names
#' @export

nms <- function(d) as.data.frame(names(d))
