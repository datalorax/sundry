#' sundry: A sundry of convenience functions
#'
#' This pacakge contains miscellaneous convenience functions to make
#' data analysis and manipulation more efficient.
#' @docType package
#' @name sundry
#' @importFrom purrr safely reduce map pmap_dbl map_df
#' @importFrom tidyr gather separate spread
#' @importFrom rlang !!! enquo quos .data
#' @importFrom dplyr filter select mutate mutate_at vars bind_rows funs n summarise_at
#' is_grouped_df everything
#' @importFrom fs dir_ls
#' @importFrom rio import
#' @importFrom stats sd median na.omit var AIC formula
#' @importFrom utils read.csv write.table
#' @importFrom magrittr "%>%"
NULL

if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
