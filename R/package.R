
#' Run R CMD check from R and Capture Results
#'
#' Run R CMD check form R programatically, and capture the results of the
#' individual checks.
#'
#' @docType package
#' @name rcmdcheck
NULL

#' Run \code{R CMD check} on a package or a directory
#'
#' @param path Path to a package tarball or a directory
#' @return An S3 object (list) with fields \code{errors},
#'   \code{warnings} and \code{nodes}. These are all character
#'   vectors containing the output for the failed check.
#'
#' @export

rcmdcheck <- function(path) {
  out <- safe_check_packages(path)
  parse_check_output(out)
}
