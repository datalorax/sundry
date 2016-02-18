#' Calculate Akaike Weights for a set of models.
#' 
#' @param icV Vector of information criteria.
#' @return Vector of Akaike weights
#' 

weights <- function(icV) {
	delta <- icV - min(icV)
	round(exp(-delta/2) / sum(exp(-delta/2)), 2)
}