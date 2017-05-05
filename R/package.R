
#' Run R CMD check from R and Capture Results
#'
#' Run R CMD check form R programatically, and capture the results of the
#' individual checks.
#'
#' @docType package
#' @name rcmdcheck
NULL

#' Run `R CMD check` on a package or a directory
#'
#' @param path Path to a package tarball or a directory.
#' @param quiet Whether to print check output during checking.
#' @param args Character vector of arguments to pass to
#'   `R CMD check`.
#' @param libpath The library path to set for the check.
#'   The default uses the current library path.
#' @param repos The `repos` option to set for the check.
#'   This is needed for cyclic dependency checks if you use the
#'   `--as-cran` argument. The default uses the current value.
#' @param timeout Timeout for the check, in seconds, or as a
#'  [base::difftime] object. If it is not finished before this, it will be
#'   killed. `Inf` means no timeout. If the check is timed out,
#'   that is added as an extra error to the result object.
#' @return An S3 object (list) with fields `errors`,
#'   `warnings` and `nodes`. These are all character
#'   vectors containing the output for the failed check.
#'
#' @export
#' @importFrom rprojroot find_package_root_file
#' @importFrom withr with_dir
#' @importFrom callr rcmd_safe

rcmdcheck <- function(path = ".", quiet = FALSE, args = character(),
                      libpath = .libPaths(), repos = getOption("repos"),
                      timeout = Inf) {

  if (file.info(path)$isdir) {
    path <- find_package_root_file(path = path)
  } else {
    path <- normalizePath(path)
  }

  targz <- build_package(path, tmp <- tempfile())
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  out <- with_dir(
    dirname(targz),
    do_check(targz, args, libpath, repos, quiet, timeout)
  )

  if (out$timeout) message("R CMD check timed out")

  invisible(parse_check_output(out))
}

do_check <- function(targz, args, libpath, repos, quiet, timeout) {
  res <- rcmd_safe(
    "check",
    cmdargs = c(basename(targz), args),
    libpath = libpath,
    repos = repos,
    block_callback = if (!quiet) block_callback(),
    spinner = !quiet,
    timeout = timeout,
    fail_on_status = FALSE
  )
  res$install_out <- get_install_out(".")
  res$description <- get_check_description(".")

  res
}
