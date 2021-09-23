
#' Run R CMD check from R and Capture Results
#'
#' Run R CMD check from R programmatically, and capture the results of the
#' individual checks.
#'
#' @docType package
#' @name rcmdcheck
NULL

#' Run `R CMD check` on a package or a directory
#'
#' Runs `R CMD check` as an external command, and parses its output and
#' returns the check failures.
#'
#' See [rcmdcheck_process] if you need to run `R CMD check` in a background
#' process.
#'
#' # Turning off package checks
#'
#' Sometimes it is useful to programmatically turn off some checks that
#' may report check NOTEs.
#' rcmdcehck provides two ways to do this.
#'
#' First, you may declare in `DESCRIPTION` that you don't want to see
#' NOTEs that are accepted on CRAN, with this entry:
#'
#' ```
#' Config/rcmdcheck/ignore-inconsequential-notes: true
#' ```
#'
#' Currently, this will make rcmdcheck ignore the following notes:
#' `r format_env_docs()`.
#'
#' The second way is more flexible, and lets you turn off individual checks
#' via setting environment variables.
#' You may provide a `tools/check.env` _environment file_ in your package
#' with the list of environment variable settings that rcmdcheck will
#' automatically use when checking the package.
#' See [Startup] for the format of this file.
#'
#' Here is an example `tools/check.env` file:
#' ```
#' # Report if package size is larger than 10 megabytes
#' _R_CHECK_PKG_SIZES_THRESHOLD_=10
#'
#' # Do not check Rd cross references
#' _R_CHECK_RD_XREFS_=false
#'
#' # Do not report if package requires GNU make
#' _R_CHECK_CRAN_INCOMING_NOTE_GNU_MAKE_=false
#'
#' # Do not check non-ASCII strings in datasets
#' _R_CHECK_PACKAGE_DATASETS_SUPPRESS_NOTES_=true
#' ```
#'
#' See the ["R internals" manual](https://cran.r-project.org/doc/manuals/r-devel/R-ints.html)
#' and the [R source code](https://github.com/wch/r-source) for the
#' environment variables that control the checks.
#'
#' Note that `Config/rcmdcheck/ignore-inconsequential-notes` and the
#' `check.env` file are only supported by rcmdcheck, and running
#' `R CMD check` from a shell (or GUI) will not use them.
#'
#' @param path Path to a package tarball or a directory.
#' @param quiet Whether to print check output during checking.
#' @param args Character vector of arguments to pass to `R CMD check`. Pass each
#'   argument as a single element of this character vector (do not use spaces to
#'   delimit arguments like you would in the shell). For example, to skip
#'   running of examples and tests, use `args = c("--no-examples",
#'   "--no-tests")` and not `args = "--no-examples --no-tests"`. (Note that
#'   instead of the `--output` option you should use the `check_dir` argument,
#'   because  `--output` cannot deal with spaces and other special characters on
#'   Windows.)
#' @param build_args Character vector of arguments to pass to `R CMD build`.
#'   Pass each argument as a single element of this character vector (do not use
#'   spaces to delimit arguments like you would in the shell). For example,
#'   `build_args = c("--force", "--keep-empty-dirs")` is a correct usage and
#'   `build_args = "--force --keep-empty-dirs"` is incorrect.
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
#'   error. Its default can be modified with the `RCMDCHECK_ERROR_ON`
#'   environment variable. If that is not set, then `"never"` is used.
#' @param env A named character vector, extra environment variables to
#'   set in the check process.
#' @return An S3 object (list) with fields `errors`,
#'   `warnings` and `notes`. These are all character
#'   vectors containing the output for the failed check.
#'
#' @export
#' @importFrom rprojroot find_package_root_file
#' @importFrom withr local_path with_dir
#' @importFrom callr rcmd_safe
#' @importFrom desc desc

rcmdcheck <- function(
    path = ".",
    quiet = FALSE,
    args = character(),
    build_args = character(),
    check_dir = NULL,
    libpath = .libPaths(),
    repos = getOption("repos"),
    timeout = Inf,
    error_on = Sys.getenv(
      "RCMDCHECK_ERROR_ON",
      c("never", "error", "warning", "note")[1]
    ),
    env = character()) {

  error_on <- match.arg(error_on, c("never", "error", "warning", "note"))

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

  # Add pandoc to the PATH, for R CMD build and R CMD check
  if (should_use_rs_pandoc()) local_path(Sys.getenv("RSTUDIO_PANDOC"))

  pkgbuild::without_cache(pkgbuild::local_build_tools())

  targz <- build_package(path, check_dir, build_args = build_args,
                         libpath = libpath, quiet = quiet)

  start_time <- Sys.time()
  desc <- desc(targz)
  set_env(path, targz, desc)

  out <- with_dir(
    dirname(targz),
    do_check(targz,
      package = desc$get("Package")[[1]],
      args = args,
      libpath = libpath,
      repos = repos,
      quiet = quiet,
      timeout = timeout,
      env = env
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
                     quiet, timeout, env) {

  # if the pkg.Rcheck directory already exists, unlink it
  unlink(paste0(package, ".Rcheck"), recursive = TRUE)

  # set up environment, start with callr safe set
  chkenv <- callr::rcmd_safe_env()

  # if R_TESTS is set here, we'll skip the session_info, because we are
  # probably inside test cases of some package
  if (Sys.getenv("R_TESTS", "") == "") {
    session_output <- tempfile()
    libdir <- file.path(dirname(targz), paste0(package, ".Rcheck"))
    profile <- make_fake_profile(package, session_output, libdir)
    on.exit(unlink(profile), add = TRUE)
    chkenv["R_TESTS"] <- profile
  } else {
    session_output <- NULL
  }

  # user supplied env vars take precedence
  if (length(env)) chkenv[names(env)] <- env

  if (!quiet) cat_head("R CMD check")
  callback <- if (!quiet) detect_callback(as_cran = "--as-cran" %in% args)
  res <- rcmd_safe(
    "check",
    cmdargs = c(basename(targz), args),
    libpath = libpath,
    user_profile = FALSE,
    repos = repos,
    stderr = "2>&1",
    block_callback = callback,
    spinner = !quiet && should_add_spinner(),
    timeout = timeout,
    fail_on_status = FALSE,
    env = chkenv
  )

  # To print an incomplete line on timeout or crash
  if (!is.null(callback) && (res$timeout || res$status != 0)) callback("\n")

  # Non-zero status is an error, the check process failed
  # R CMD check returns 1 for installation errors, we don't want to error
  # for those.
  if (res$status != 0 && res$status != 1) {
    stop(
      call. = FALSE,
      "R CMD check process failed with exit status ", res$status,
      "\n\nStandard output and error:\n",
      res$stdout
    )
  }

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
