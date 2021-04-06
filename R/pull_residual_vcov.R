#' Pull the residual variance-covariance matrix from an lme4::lmer model
#'
#' This function wraps the code supplied by Ben Bolker from StackOverflow here: https://stackoverflow.com/a/45655597.
#'
#' @param model A fitted lme4::lmer model
#'
#' @return The residual variance covariance matrix (which is a sparse matrix)
#'
#' @export
#'

pull_residual_vcov <- function(model) {
  var_d <- crossprod(getME(model, "Lambdat"))
  Zt <- getME(model, "Zt")
  vr <- sigma(model)^2

  var_b <- vr * (t(Zt) %*% var_d %*% Zt)
  sI <- vr * Diagonal(nrow(model@frame))

  var_b + sI
}
