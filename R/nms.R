#' Easily see variable index locations
#' 
#' Function returns the variable names and their location in a matrix
#' 
#' @param d Data frame from which to report variable names and their locations
#' 
#' @return Matrix of the names from the dataset and their location
#' 

nms <- function(d) cbind(names(d), 1:ncol(d))