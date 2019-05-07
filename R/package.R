
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
#'   `R CMD check`. (Note that instead of the `--output` option you
#'   should use the `check_dir` argument, because  `--output` cannot
#'   deal with spaces and other special characters on Windows.
#' @param build_args Character vector of arguments to pass to
#'   `R CMD build`
#' @param check_dir Path to a directory where the check is performed.
#'   If this is not `NULL`, then the a temporary directory is used, that
#'   is cleaned up when the returned object is garbage collected.
#' @param libpath The library path to set for the check.
#'   The default uses the current library path.
#' @param repos The `repos` option to set for the check.
#'   This is needed for cyclic dependency checks if you use the
#'   `--as-cran` argument. The default uses the current value.
#' @param timeout Timeout for the check, in seconds, or as a
#'  [base::difftime] object. If it is not finished before this, it will be
#'   killed. `Inf` means no timeout. If the check is timed out,
#'   that is added as an extra error to the result object.
#' @param error_on Whether to throw an error on `R CMD check` failures.
#'   Note that the check is always completed (unless a timeout happens),
#'   and the error is only thrown after completion. If `"never"`, then
#'   no errors are thrown. If `"error"`, then only `ERROR` failures
#'   generate errors. If `"warning"`, then `WARNING` failures generate
#'   errors as well. If `"note"`, then any check failure generated an
#'   error.
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
                      build_args = character(), check_dir = NULL,
                      libpath = .libPaths(), repos = getOption("repos"),
                      timeout = Inf, error_on =
                        c("never", "error", "warning", "note")) {

  error_on <- match.arg(error_on)

  if (file.info(path)$isdir) {
    path <- find_package_root_file(path = path)
  } else {
    path <- normalizePath(path)
  }

  if (is.null(check_dir)) {
    check_dir <- tempfile()
    cleanup <- TRUE
  } else {
    cleanup <- FALSE
  }

  targz <- build_package(path, check_dir, build_args = build_args,
                         libpath = libpath, quiet = quiet)

  start_time <- Sys.time()
  desc <- desc(targz)

  out <- with_dir(
    dirname(targz),
    do_check(targz,
      package = desc$get("Package")[[1]],
      args = args,
      libpath = libpath,
      repos = repos,
      quiet = quiet,
      timeout = timeout
    )
  )

  on.exit(unlink(out$session_info, recursive = TRUE), add = TRUE)

  if (isTRUE(out$timeout)) message("R CMD check timed out")

  res <- new_rcmdcheck(
    stdout = out$result$stdout,
    stderr = out$result$stderr,
    description = desc,
    status = out$result$status,
    duration = duration(start_time),
    timeout = out$result$timeout,
    session_info = out$session_info
  )

  # Automatically delete temporary files when this object disappears
  if (cleanup) res$cleaner <- auto_clean(check_dir)

  handle_error_on(res, error_on)

  res
}

#' @importFrom withr with_envvar

do_check <- function(targz, package, args, libpath, repos,
                     quiet, timeout) {

  session_output <- tempfile()
  profile <- make_fake_profile(session_output = session_output)
  on.exit(unlink(profile), add = TRUE)

  # if the pkg.Rcheck directory already exists, unlink it
  unlink(paste0(package, ".Rcheck"), recursive = TRUE)

  callr_version <- package_version(getNamespaceVersion("callr"))
  rlibsuser <- if (callr_version < "3.0.0.9001")
    paste(libpath, collapse = .Platform$path.sep)

  if (!quiet) cat_head("R CMD check")
  res <- with_envvar(
    c(R_PROFILE_USER = profile, R_LIBS_USER = rlibsuser),
    rcmd_safe(
      "check",
      cmdargs = c(basename(targz), args),
      libpath = libpath,
      user_profile = TRUE,
      repos = repos,
      stderr = "2>&1",
      block_callback = if (!quiet) detect_callback(),
      spinner = !quiet && should_add_spinner(),
      timeout = timeout,
      fail_on_status = FALSE
    )
  )

  list(result = res, session_info = session_output)
}

handle_error_on <- function(res, error_on) {
  level <- c(never = 0, error = 1, warning = 2, note = 3)[error_on]

  if (isTRUE(res$timeout)) {
    print(res)
    stop(make_error(res, "R CMD check timed out"))
  } else if (length(res$errors) && level >= 1) {
    print(res)
    stop(make_error(res, "R CMD check found ERRORs"))
  } else if (length(res$warnings) && level >= 2) {
    print(res)
    stop(make_error(res, "R CMD check found WARNINGs"))
  } else if (length(res$notes) && level >= 3) {
    print(res)
    stop(make_error(res, "R CMD check found NOTEs"))
  }
}

make_error <- function(res, msg) {
  structure(
    list(result = res, message = msg, call = NULL),
    class = c(
      if (isTRUE(res$timeout)) "rcmdcheck_timeout",
      if (length(res$errors)) "rcmdcheck_error",
      if (length(res$warnings)) "rcmdcheck_warning",
      if (length(res$notes)) "rcmdcheck_note",
      "rcmdcheck_failure",
      "error",
      "condition"
    )
  )
}
