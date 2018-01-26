#' Remove rows with empty data
#'
#' This function works similarly to \link[janitor]{remove_empty_rows} function
#' from the janitor package, except that you can pass the list of columns to
#' remove missing data from. You can then easily eliminate any rows that have
#' complete missing data across any generic set of columns
#'
#' @param d The data frame.
#' @param ... Optional columns to include. If included, rows will only be
#' removed if the data are missing across all columns included. If \code{NULL}
#' only rows with complete missing data across all columns will be removed
#' (i.e., equivalent to \link[janitor]{remove_empty_rows})
#' @export

rm_empty_rows <- function(d, ...) {
  rem <- quos(...)

  if(length(rem) == 0) {
    d %>%
      mutate(missing = pmap_dbl(., ~sum(is.na(c(...))))) %>%
      filter(missing != ncol(.)) %>%
      select(-missing)
  }
  else {
    d %>%
      mutate(missing = pmap_dbl(select(., !!!rem), ~sum(is.na(c(...))))) %>%
      filter(missing != ncol(select(d, !!!rem))) %>%
      select(-missing)
  }
}
