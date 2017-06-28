#' Calculate the se of the mean
#' 
#' This function is pretty simple. Just calculates the standard error of the
#' mean for a generic vector. For some odd reason this is not included in the 
#' base \emph{stats} package, so I put it in mine. Removes missing data by
#' default
#' 
#' @param v Vector to calculate the se of the mean on.
#' 
#' @export
#' 
se <- function(v) sqrt(var(v, na.rm = TRUE)/length(na.omit(v)))