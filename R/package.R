
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
#'   `warnings` and `notes`. These are all character
#'   vectors containing the output for the failed check.
#'
#' @export
#' @importFrom rprojroot find_package_root_file
#' @importFrom withr with_dir
#' @importFrom callr rcmd_safe
#' @importFrom desc desc

rcmdcheck <- function(path = ".", quiet = FALSE, args = character(),
                      libpath = .libPaths(), repos = getOption("repos"),
                      timeout = Inf) {

  if (file.info(path)$isdir) {
    path <- find_package_root_file(path = path)
  } else {
    path <- normalizePath(path)
  }

  targz <- build_package(path, tmp <- tempfile())

  dsc <- desc(targz)
  dsc$write(tmpdesc <- tempfile())
  on.exit(unlink(tmpdesc), add = TRUE)
  package_name <- unname(dsc$get("Package"))
  package_version <- unname(dsc$get("Version"))

  out <- with_dir(
    dirname(targz),
    do_check(targz, package_name, package_version, args, libpath, repos,
             quiet, timeout)
  )

  if (isTRUE(out$timeout)) message("R CMD check timed out")

  res <- new_rcmdcheck(
    stdout = out$result$stdout,
    timeout = out$result$timeout,
    session_info = out$session_info,
    package = package_name,
    version = package_version,
    rversion = R.Version()$version.string, # should be the same
    platform = R.Version()$platform,       # should be the same
    description = read_char(tmpdesc)
  )

  # Automatically delete temporary files when this object disappears
  res$cleaner <- auto_clean(tmp)

  res
}

#' @importFrom withr with_envvar

do_check <- function(targz, package, version, args, libpath, repos,
                     quiet, timeout) {

  profile <- tempfile()
  session_output <- tempfile()
  on.exit(unlink(c(profile, session_output)), add = TRUE)

  last <- substitute(
    function() {
      si <- utils::sessionInfo()
      l <- if (file.exists(`__output__`)) {
        readRDS(`__output__`)
      } else {
        list()
      }
      saveRDS(c(l, list(si)), `__output__`)
    },
    list(`__output__` = session_output)
  )

  cat(".Last <-", deparse(last), file = profile, sep = "\n")

  res <- with_envvar(
    c(R_PROFILE_USER = profile),
    rcmd_safe(
      "check",
      cmdargs = c(basename(targz), args),
      libpath = libpath,
      user_profile = TRUE,
      repos = repos,
      block_callback = if (!quiet) block_callback(),
      spinner = !quiet,
      timeout = timeout,
      fail_on_status = FALSE
    )
  )

  session_info <- tryCatch(
    Filter(
      function(so) package %in% names(so$otherPkgs),
      suppressWarnings(readRDS(session_output))
    )[[1]],
    error = function(e) NULL,
    warning = function(w) NULL
  )

  list(result = res, session_info = session_info)
}
