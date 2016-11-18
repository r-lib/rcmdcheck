
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
#' @param path Path to a package tarball or a directory.
#' @param quiet Whether to print check output during checking.
#' @param args Character vector of arguments to pass to
#'   \code{R CMD check}.
#' @param libpath The library path to set for the check.
#'   The default uses the current library path.
#' @param repos The \code{repos} option to set for the check.
#'   This is needed for cyclic dependency checks if you use the
#'   \code{--as-cran} argument. The default uses the current value.
#' @return An S3 object (list) with fields \code{errors},
#'   \code{warnings} and \code{nodes}. These are all character
#'   vectors containing the output for the failed check.
#'
#' @export
#' @importFrom rprojroot find_package_root_file
#' @importFrom withr with_dir
#' @importFrom callr rcmd_safe

rcmdcheck <- function(path = ".", quiet = FALSE, args = character(),
                      libpath = .libPaths(), repos = getOption("repos")) {

  if (file.info(path)$isdir) {
    path <- find_package_root_file(path = path)
  } else {
    path <- normalizePath(path)
  }

  targz <- build_package(path, tmp <- tempfile())
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  with_dir(
    dirname(targz),
    out <- rcmd_safe(
      "check",
      cmdargs = c(basename(targz), args),
      libpath = libpath,
      repos = repos,
      callback = if (!quiet) check_callback()
    )
  )

  invisible(parse_check_output(out))
}
