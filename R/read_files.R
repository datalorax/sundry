#' Read a batch of files
#'
#' @param dir Directory where files are stored. Defaults to the current
#' working directory
#' @param pat Optional string pattern of files in the directory
#' @param df Logical. Should the function try to read the files in as a single
#' data frame? Defaults to \code{TRUE}. A list of data frames are returned
#' if \code{FALSE}.
#' @param ... Additonal arguments passed to \code{\link[rio]{import}} (e.g.,
#' \code{delim}).


read_files <- function(dir = ".", pat = "*.csv|*.sav|*.xls|*.xlsx|*.txt", df = TRUE, ...) {
	pat <- paste0("*.", pat)
  files <- dir_ls(dir, glob = pat)
  if(length(files) == 0) {
    stop("No files in the directory matching the given pattern")
  }
  safe_map_df <- safely(map_df)
	full_data <- safe_map_df(files, ~import(., setclass = "tbl_df"), .id = "file")
  if(!is.null(full_data$error) | df == FALSE) {
    map(files, ~import(., setclass = "tbl_df"))
  }
	else {
	  d <- full_data$result
	  d$file <- gsub("^\\.(\\/.+\\/)", "", d$file)
    d$file <- gsub("(\\.).+$", "", d$file)
    d
	}
}
