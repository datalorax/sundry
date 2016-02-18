#' Scatterplot of any two variables, as well as the regression line with the 
#' correlation reported. Alternatively, a regression model can be fed to the
#' function with an equivalent plot reported.
#' 
#' @param x Predictor variable (plotted on the x-axis)
#' @param y Outcome (plotted on the y-axis)
#' @param mod Fitted regression model from \code{\link[stats]{lm}}. Alternative
#' to supplying \code{x} and \code{y}.
#' @param lcol Color of the regression line. Defaults to blue.
#' @param se Logical, defaults to \code{TRUE}. Should the standard error
#' around the regression line be plotted?
#' @param secol Color and transparency of the standard error shading. Vector
#' of four elements as follows: red, green, blue, alpha, where alpha is the
#' transparency parameter (higher values increase the opacity). 
#' 
#' @return Scatterplot of the relation between two variables (linear 
#' regression)

regPlot <- function(x, y, lcol = "blue", 
				se = TRUE, secol = c(0, 0, 0.5, 0.2), ...) UseMethod("regPlot")

regPlot.default <- function(x, y, lcol = "blue", 
				se = TRUE, secol = c(0, 0, 0.5, 0.2), ...) {

	mod <- lm(y ~ x)
	nd <- data.frame(x = seq(min(x, na.rm = TRUE) - sd(x, na.rm = TRUE), 
							 max(x, na.rm = TRUE) + sd(x, na.rm = TRUE), 
							 length.out = length(x)))
	pred <- predict(mod, 
		newdata = nd, 
		se.fit = TRUE)
	
	plot(x, y, ...)
	abline(mod, col = lcol, lwd = 2)
	
	if(se == TRUE) {
		polygon(c(nd$x, rev(nd$x)), 
			c(pred$fit - (1.96 * pred$se.fit), 
				rev(pred$fit + (1.96 * pred$se.fit))),
		col = rgb(secol[1], secol[2], secol[3], secol[4]), border = NA)
	}
}

regPlot.lm <- function(mod, x, y, lcol = "blue", 
				se = TRUE, secol = c(0, 0, 0.5, 0.2), ...) {
	x <- mod$model[[2]]
	y <- mod$model[[1]]
	regPlot.default(x, y, lcol, se, secol, ...)
}


