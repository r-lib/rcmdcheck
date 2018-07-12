
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
#' @param check_args Character vector of arguments to pass to
#'   `R CMD check`.
#' @param build_args Character vector of arguments to pass to
#'   `R CMD build`
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

rcmdcheck <- function(path = ".", quiet = FALSE, check_args = character(),
                      build_args = character(),
                      libpath = .libPaths(), repos = getOption("repos"),
                      timeout = Inf, error_on =
                        c("never", "error", "warning", "note")) {

  error_on <- match.arg(error_on)

  if (file.info(path)$isdir) {
    path <- find_package_root_file(path = path)
  } else {
    path <- normalizePath(path)
  }

  targz <- build_package(path, tmp <- tempfile(), build_args = build_args,
                         quiet = quiet)

  start_time <- Sys.time()
  desc <- desc(targz)

  out <- with_dir(
    dirname(targz),
    do_check(targz,
      package = desc$get("Package")[[1]],
      check_args = check_args,
      libpath = libpath,
      repos = repos,
      quiet = quiet,
      timeout = timeout
    )
  )

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
  res$cleaner <- auto_clean(tmp)

  handle_error_on(res, error_on)

  res
}

#' @importFrom withr with_envvar

do_check <- function(targz, package, check_args, libpath, repos,
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

  if (!quiet) cat_head("R CMD build")
  res <- with_envvar(
    c(R_PROFILE_USER = profile),
    rcmd_safe(
      "check",
      cmdargs = c(basename(targz), check_args),
      libpath = libpath,
      user_profile = TRUE,
      repos = repos,
      block_callback = if (!quiet) block_callback(),
      spinner = !quiet,
      timeout = timeout,
      fail_on_status = FALSE
    )
  )

  # Extract session info for this package
  session_info <- tryCatch(
    readRDS(session_output),
    error = function(e) NULL,
    warning = function(w) NULL
  )
  session_info <- Filter(
    function(so) package %in% names(so$otherPkgs),
    session_info
  )
  if (length(session_info) > 1) {
    session_info <- session_info[[1]]
  }

  list(result = res, session_info = session_info)
}

handle_error_on <- function(res, error_on) {
  level <- c(never = 0, error = 1, warning = 2, note = 3)[error_on]

  if (isTRUE(res$timeout)) {
    stop(make_error(res, "R CMD check timed out"))
  } else if (length(res$errors) && level >= 1) {
    stop(make_error(res, "R CMD check found ERRORs"))
  } else if (length(res$warnings) && level >= 2) {
    stop(make_error(res, "R CMD check found WARNINGs"))
  } else if (length(res$notes) && level >= 3) {
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
