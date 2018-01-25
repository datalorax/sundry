#' Collapse demographic variables across *n* years
#'
#' This function will collapse demographic variables across years into a single
#' vector. If demographics vary across years, it will return the most common
#' value (i.e., majority rule). If there is a tie, it will randomly select from
#' the tied demographic values. If there are missing data across any of the
#' years, the value from the observed years will be retained. In other words,
#' the function can be helpful for collapsing demographic data even when no
#' demographic values vary.
#'
#' @param d Data frame which includes the variables to be collapsed
#' @param pat Common string pattern represented in all variables to be
#' collapsed.
#' @param seed Seed to set for reproducibility. Defaults to 100.
#' @param print Logical. Should the number of students who were assigned
#' based on a majority rule and the number of students who were randomly
#' assigned be printed to the console? Defaults to \code{TRUE}.
#'
#' @return Factor vector of demographic data with the properties described
#' above. The number of
#' @export

collapse_dems <- function(d, pat, seed = 100, print = TRUE) {
	group <- d[ ,grep(as.character(pat), names(d))]

	full_miss <- apply(group, 1, function(x) sum(is.na(x)))
	if(any(full_miss == ncol(group))) {
		group[full_miss == ncol(group), ] <- "Missing"
	}

	tbls <- apply(group, 1, table)

	if(typeof(tbls) != "list")	{
		out <- apply(group, 1, function(x) names(table(x)))
		out <- ifelse(out  == "Missing", NA, out)
		return(as.factor(out))
	}

	names(tbls) <- paste(seq_along(tbls))
	patterns <- lapply(tbls, function(x) names(which(x == max(x))))

	lengths <- sapply(tbls, length)
	wandering_dems <- sum(lengths > 1)

	n_random_assign <- sum(sapply(patterns, function(x) length(x) > 1))


	if(print == TRUE) {
		perc_majority <- round(
							( (wandering_dems - n_random_assign) /
								length(tbls) )*100)
		perc_random_assign <- round( (n_random_assign / length(tbls) )*100)
		cat(
			paste0("n_majority = ", wandering_dems - n_random_assign),
			paste0("perc_majority = ", perc_majority),
			paste0("n_random_assign = ", n_random_assign),
			paste0("perc_random_assign = ", perc_random_assign),
			sep = "\n")
	}

	pick <- function(x) {
		if(length(x) > 1) {
			sample(x, 1)
		}
		else {
			x
		}
	}

	set.seed(seed) # for reproducibility
	out <- sapply(patterns, pick)
	out <- ifelse(out == "Missing", NA, out)
	out <- as.factor(out)
	#attributes(out) <- sum_tbl
out
}
