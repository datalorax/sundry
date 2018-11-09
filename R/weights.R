#' Calculate Akaike Weights for a set of models.
#'
#' @param ... The models to compare
#' @return A data frame containing the delta AIC values and corresponding
#'   weights for each model
#' @export

aic_weights <- function(...) {
  l <- list(...)
  aics <- vapply(l, AIC, numeric(1))
  formulas <- vapply(l, function(x) {
    as.character(formula(x))[3]
    },
    character(1))
  delta <- aics - min(aics)

  weights <- round(exp(-delta/2) / sum(exp(-delta/2)), 2)
  out <- data.frame(predictors  = formulas,
             delta  = delta,
             weight = weights)
  out[order(out$weight, decreasing = TRUE), ]
}
