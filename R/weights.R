#' Calculate Akaike Weights for a set of models.
#'
#' @param ... The candidate models to compare
#' @return Vector of Akaike weights
#' @export

aic_weights <- function(...) {
  l <- list(...)
  aics <- vapply(l, AIC, numeric(1))
  delta <- aics - min(aics)

  round(exp(-delta/2) / sum(exp(-delta/2)), 2)
}
