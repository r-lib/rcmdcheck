
#' Run an `R CMD check` process in the background
#'
#' rcmdcheck_process is an R6 class, that extends the
#' [callr::rcmd_process] class (which in turn extends [processx::process].
#'
#' @section Usage:
#' ```
#' cp <- rcmdcheck_process$new(path = ".", args = character(),
#'          libpath = .libPaths(), repos = getOption("repos"))
#'
#' cp$parse_results()
#' ```
#'
#' Other methods are inherited from [callr::rcmd_process] and
#' [processx::process].
#'
#' Note that you calling the `get_output_connection` and
#' `get_error_connection` method on this is not a good idea, because
#' then the stdout and/or stderr of the process will not be collected
#' for `parse_results()`.
#'
#' You can still use the `read_output_lines()` and `read_error_lines()`
#' methods to read the standard output and error, `parse_results()` is
#' not affected by that.
#'
#' @section Arguments:
#' * `cp`: A new rcmdcheck_process object.
#' * `path`: Path to a package tree or a package archive file. This is the
#'   package to check.
#' * `args`: Command line arguments to `R CMD check`.
#' * `build_args`: Command line arguments to `R CMD build`.
#' * `libpath`: The library path to set for the check.
#' * `repos`: The `repos` option to set for the check.
#'   This is needed for cyclic dependency checks if you use the
#'   `--as-cran` argument. The default uses the current value.
#'
#' @section Details:
#' Most methods are inherited from [callr::rcmd_process] and
#' [processx::process].
#'
#' `cp$parse_results()` parses the results, and returns an S3 object with
#' fields `errors`, `warnnigs` and `notes`, just like [rcmdcheck()]. It
#' is an error to call it before the process has finished. Use the
#' `wait()` method to wait for the check to finish, or the `is_alive()`
#' method to check if it is still running.
#'
#' @importFrom R6 R6Class
#' @name rcmdcheck_process
NULL

#' @export

rcmdcheck_process <- R6Class(
  "rcmdcheck_process",
  inherit = callr::rcmd_process,

  public = list(

    initialize = function(path = ".", args = character(),
      build_args = character(), libpath = .libPaths(),
      repos = getOption("repos"))
      rcc_init(self, private, super, path, args = args,
               build_args = build_args, libpath, repos),

    parse_results = function()
      rcc_parse_results(self, private),

    read_output_lines = function(...) {
      l <- super$read_output_lines(...)
      private$cstdout <- c(private$cstdout, paste0(l, "\n"))
      l
    },

    read_error_lines = function(...) {
      l <- super$read_error_lines(...)
      private$cstderr <- c(private$cstderr, paste0(l, "\n"))
      l
    },

    read_output = function(...) {
      l <- super$read_output(...)
      private$cstdout <- c(private$cstdout, l)
      l
    },

    read_error = function(...) {
      l <- super$read_error(...)
      private$cstderr <- c(private$cstderr, l)
      l
    },

    kill = function(...) {
      private$killed <- TRUE
      super$kill(...)
    }

  ),
  private = list(
    path  = NULL,
    tmp   = NULL,
    targz = NULL,
    description = NULL,
    cstdout = character(),
    cstderr = character(),
    killed = FALSE
  )
)

#' @importFrom callr rcmd_process rcmd_process_options
#' @importFrom desc desc

rcc_init <- function(self, private, super, path, args, build_args,
                     libpath, repos) {

  if (file.info(path)$isdir) {
    path <- find_package_root_file(path = path)
  } else {
    path <- normalizePath(path)
  }

  targz <- build_package(path, tmp <- tempfile(), build_args = build_args,
                         quiet = TRUE)

  private$description <- desc(path)
  private$path  <- path
  private$tmp   <- tmp
  private$targz <- targz

  options <- rcmd_process_options(
    cmd = "check",
    cmdargs = c(basename(targz), args),
    libpath = libpath,
    repos = repos
  )

  with_dir(
    dirname(targz),
    super$initialize(options)
  )

  invisible(self)
}

rcc_parse_results <- function(self, private) {
  if (self$is_alive()) stop("Process still alive")

  ## Make sure all output is read out
  self$read_output_lines()
  self$read_error_lines()

  new_rcmdcheck(
    stdout =      paste(win2unix(private$cstdout), collapse = ""),
    stderr =      paste(win2unix(private$cstderr), collapse = ""),
    description = private$description,
    status =      self$get_exit_status(),
    duration =    duration(self$get_start_time()),
    timeout =     private$killed
  )
}
