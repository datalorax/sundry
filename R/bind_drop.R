#' Bind the rows of a list of data frames while dropping all columns not in
#' common
#'
#' @param l A list of dataframes
#'
#' @return A single dataframe that has all the rows from the original list of
#' data frames, but only the columns that are represented in all data frames.
#' Note that no identifier is provided from where the rows came from at present
#'
#' @export
#'

bind_rows_drop <- function(l) {
  common <- Reduce(intersect, lapply(l, names))
  new <- lapply(l, "[", common)
  do.call(rbind, new)
}

#' Bind the rows of a list of data frames while dropping all columns not in
#' common
#'
#' This function is exactly equivalent to \link{bind_rows_drop} but uses
#' functions from the purrr package. It is much faster than the base version,
#' but includes the purrr, rlang, and dplyr dependencies.
#'
#' @param l A list of dataframes
#' @param ... Variables that must be coerced prior to applying
#' `dplyr::bind_rows`.
#' @return A single dataframe that has all the rows from the original list of
#' data frames, but only the columns that are represented in all data frames.
#' Note that no identifier is provided from where the rows came from at present
#' @export
#'

tidy_bind_drop <- function(l, ...) {
  common <- reduce(map(l, names), intersect)
  new <- map(l, `[`, common)

  convert <- quos(...)
  new <- map(new, ~mutate_at(., vars(!!!convert),
                                    as.character))

  bind_rows(new, .id = "dataset")
}
