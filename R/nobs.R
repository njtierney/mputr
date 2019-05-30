#' Take the number of observations from the first Amelia melded model
#'
#' @param object Amelia melded model
#' @param ... other options to pass to `nobs`
#'
#' @return integer
#' @importFrom stats nobs
#' @method nobs melded
#' @export
nobs.melded <- function(object, ...) {
  stats::nobs(object[[1]])
}
