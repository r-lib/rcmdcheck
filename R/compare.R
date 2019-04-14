
#' Compare a set of check results to another check result
#'
#' @param old A check result, or a list of check results.
#' @param new A check result.
#' @return An `rcmdcheck_comparison` object with fields:
#'   * `package`: the name of the package, string,
#'   * `versions`: package versions, length two character,
#'   * `status`: comparison status, see below,
#'   * `old`: list of `rcmdcheck` objects the old check(s),
#'   * `new`: `rcmdcheck` object, the new check,
#'   * `cmp`: 
#' 
#'
#' @family check comparisons
#' @export

compare_checks <- function(old, new) {
  if (inherits(old, "rcmdcheck")) old <- list(old)
  rcmdcheck_comparison(old, new)
}

compare_check_files <- function(old, new) {
  old <- parse_check(old)
  new <- parse_check(new)
  rcmdcheck_comparison(list(old), new)
}

#' Compare a check result to CRAN check results
#'
#' @param check A check result.
#' @param flavours CRAN check flavour(s) to use. By default all
#'   platforms are used.
#' @return An `rmdcheck_comparison` object.
#'
#' @family check comparisons
#' @export

compare_to_cran <- function(check,
                            flavours = cran_check_flavours(check$package)) {
  pkg <- check$package
  cran <- cran_check_results(pkg, flavours = flavours)
  compare_checks(old = cran, new = check)
}

