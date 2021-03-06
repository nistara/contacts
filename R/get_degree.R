#' Find node degree for epi_contacts objects
#'
#' This function computes the number of contacts per cases in a \code{\link{epi_contacts}}
#' dataset. Whenever contacts are directed, the argument 'type' can be used to specify which kind of
#' contact should be considered: 'in' (towards the case), 'out' (from the case), or 'both'.
#'
#' @export
#'
#' @author Thibaut Jombart (\email{thibautjombart@@gmail.com})
#'
#' @param x an \code{\link{epi_contacts}} object
#'
#' @param type the type of degree to be computed (see description); if contacts are not directed,
#' this will be forced to 'both'
#'
#' @param only_linelist a logical indicating if cases whose degree is computed should be from the
#' linelist exclusively
#'
#' @examples
#' x <- make_epi_contacts(ebola.sim$linelist, ebola.sim$contacts,
#'                        id="case.id", to="case.id", from="infector",
#'                        directed=TRUE)
#' x
#' deg_in <- get_degree(x)
#' deg_out <- get_degree(x, "out")
#' deg_both <- get_degree(x, "both")
#' head(deg_in)
#' table(deg_in)
#' head(deg_out)
#' table(deg_out)
#' head(deg_both)
#' table(deg_both)
#'
get_degree <- function(x, type=c("in", "out", "both"), only_linelist=FALSE){
    ## checks
    if (!inherits(x, "epi_contacts")) {
        stop("x is not an 'epi_contacts' object")
    }
    type <- match.arg(type)

    if (only_linelist) {
        all_nodes <- x$linelist$id
    } else {
        all_nodes <- unique(c(x$contacts$from, x$contacts$to))
    }

    if (!x$directed) {
        type <- "both"
    }

    ## compute degrees
    if (type=="in") {
        out <- vapply(all_nodes, function(e) sum(e==x$contacts$to), FUN.VALUE=0L)
    }
    if (type=="out") {
        out <- vapply(all_nodes, function(e) sum(e==x$contacts$from), FUN.VALUE=0L)
    }
    if (type=="both") {
        out <- vapply(all_nodes, function(e) sum(e==c(x$contacts$from, x$contacts$to)), FUN.VALUE=0L)
    }


    ## name, shape and return
    names(out) <- all_nodes
    return(out)

}
