#' Batch read csv files, return all files in a list
#' 
#' @param dir Directory where csv files are stored. Defaults to the current 
#' working directory
#' @param ... Additonal arguments passed to \code{\link[utils]{read.csv}}.


readFiles <- function(dir = getwd(), pat = NULL, ...) {
	oldDir <- getwd() # Get current working directory
	setwd(as.character(dir)) # Change directory to where data are stored
	
	files <- list.files(pattern = pat) # List all the files in the directory
	dl <- lapply(1:length(files), function(i) read.csv(files[i], ...)) # Read data
	names(dl) <- substr(files, 1, nchar(files) - 4) # Name list elements according to files

on.exit(setwd(oldDir)) # Reset the working directory
return(dl) # Return the data list
}