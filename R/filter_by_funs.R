#' Filter a data frame accoring to descriptive functions
#'
#' This function allows you to subset a data frame by any set
#' of descriptive statistics. For example, you could extract rows
#' that are eqaul to specific quantiles, or the min and the max.
#' This is a dplyr-like function, and works well with functions
#' such as \code{\link[dplyr]{group_by}}.
#'
#' @param data The data frame that includes the variables to compute
#' descriptive statistics on.
#' @param variable The variable to filter on.
#' @param .funs The functions to use in filtering.
#' @return A tidy data frame with the requested descriptive statistics
#' for the requested variables
#' @export
#' @examples
#'
#' library(dplyr)
#' storms %>%
#'  filter_by_funs(wind, funs(min,
#'                            quantile(., .25, na.rm = TRUE),
#'                            quantile(., .50, na.rm = TRUE),
#'                            quantile(., .75, na.rm = TRUE),
#'                            max))
#' storms %>%
#'   group_by(year) %>%
#'   filter_by_funs(wind, funs(min,max)) %>%
#'   arrange(year)

filter_by_funs <- function(data, variable, .funs) {
  call <- as.list(match.call())
  var <- enquo(variable)

  if(length(as.character(call$.funs)) > 1) {
    funs_gathered <- as.character(call$.funs)[-1]
    funs_gathered <- gsub("(\\(.*\\))", "", funs_gathered)

    if(anyDuplicated(funs_gathered)) {
      dups <- duplicated(funs_gathered) |
              duplicated(funs_gathered, fromLast = TRUE)

      funs_gathered[dups] <- paste0(funs_gathered[dups],
                                    "_",
                                    seq_along(funs_gathered[dups]))

       names(.funs) <- funs_gathered
    }

     mutated <- data %>%
      mutate_at(vars(!!var), .funs)
 }
  else {
    funs_gathered <- as.character(call$.funs)
    mutated <- data %>%
      mutate_at(vars(!!var), funs(tmp = .funs))
    names(mutated)[grep("tmp", names(mutated))] <- funs_gathered
  }
  mutated %>%
    gather("fun", "value", funs_gathered) %>%
    filter(.data$value == !!var) %>%
    select(-.data$value) %>%
    select(.data$fun, everything())
}
