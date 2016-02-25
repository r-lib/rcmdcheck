
#' Run R CMD check from R and Capture Results
#'
#' Run R CMD check form R programatically, and capture the results of the
#' individual checks.
#'
#' @docType package
#' @name rcmdcheck
NULL


#' @export

rcmdcheck <- function(path) {
  out <- safe_check_packages(path)
  parse_check_output(out)
}
