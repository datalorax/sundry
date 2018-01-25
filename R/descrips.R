#' Pipe-friendly descriptive stats
#'
#' Generate any set of descriptive statistics through the pipeline
#' and return a tidy data frame. The function works with any number
#' of variables, as well as with \code{\link[dplyr]{group_by}}.
#'
#' @param data The data frame that includes the variables to compute
#' descriptive statistics on.
#' @param ... The set of variables to compute descriptive statistics on.
#' @param .funs The functions to use in the descriptive statistics. Uses
#' the \code{\link[dplyr]{funs}} function. Defaults to the number of
#' observations, min, max, mean, and standard deviation.
#' @return A tidy data frame with the requested descriptive statistics
#' for the requested variables
#' @export
#' @examples
#'
#' library(dplyr)
#' library(magrittr)
#' storms %>%
#'   descrips(wind, pressure)
#'
#' storms %>%
#'   group_by(year) %>%
#'   descrips(wind, pressure)
#'
#' storms %>%
#'   group_by(year) %>%
#'   descrips(wind, pressure, .funs = funs(median, n()))
descrips <- function(data,
                     ...,
                     .funs = dplyr::funs(n(),
                                         min(., na.rm = TRUE),
                                         max(., na.rm = TRUE),
                                         mean(., na.rm = TRUE),
                                         sd(., na.rm = TRUE))) {
  variables <- quos(...)
  smry <- summarise_at(data, vars(!!!variables), .funs)

  if(is_grouped_df(data)) {
    grouping <- names(attr(data, "labels"))
  } else {
    grouping <- NULL
  }
  if(length(variables) == 1) {
    return(smry)
  }
  gather_spread_descrips(smry, grouping, names(.funs))
}

#' Formatting for descrips
#'
#' Internal function to format the descrips in a more eye-ball
#' friendly format
#'
#' @param smry The smry output from \code{\link{descrips}}
#' @param grouping String stating the grouping factor, and NULL
#' otherwise.
#' @param order The order the columns should be displayed in the
#' final output

gather_spread_descrips <- function(smry, grouping, order) {
  if(!is.null(grouping)) {
    smry %>%
      gather("var", "val", -grouping) %>%
      separate(.data$var, c("variable", "stat")) %>%
      spread(.data$stat, .data$val) %>%
      select(grouping, .data$variable, order)
  }
  else {
    smry %>%
      gather("var", "val") %>%
      separate(.data$var, c("variable", "stat")) %>%
      spread(.data$stat, .data$val) %>%
      select(.data$variable, order)
  }
}
