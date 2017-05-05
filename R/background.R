
#' @importFrom R6 R6Class
NULL

#' @export

rcmdcheck_process <- R6Class(
  "rcmdcheck_process",
  inherit = callr::rcmd_process,

  public = list(

    initialize = function(path = ".", args = character(),
      libpath = .libPaths(), repos = getOption("repos"))
      rcc_init(self, private, super, path, args, libpath, repos),

    parse_results = function()
      rcc_parse_results(self, private),

    read_output_lines = function(...) {
      l <- super$read_output_lines(...)
      private$cstdout <- c(private$cstdout, l)
      l
    },

    read_error_lines = function(...) {
      l <- super$read_error_lines(...)
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
    cstdout = character(),
    cstderr = character(),
    killed = FALSE
  )
)

#' @importFrom callr rcmd_process rcmd_process_options

rcc_init <- function(self, private, super, path, args, libpath, repos) {

  if (file.info(path)$isdir) {
    path <- find_package_root_file(path = path)
  } else {
    path <- normalizePath(path)
  }

  targz <- build_package(path, tmp <- tempfile())

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

  out <- list(
    status = self$get_exit_status(),
    stdout = paste(private$cstdout, collapse = "\n"),
    stderr = paste(private$cstderr, collapse = "\n"),
    timeout = private$killed
  )

  install_out <- file.path(
    dir(private$tmp, pattern = "\\.Rcheck$", full.names = TRUE),
    "00install.out"
  )
  out$install_out <- if (file.exists(install_out)) {
    read_char(install_out)
  } else {
    "<00install.out file does not exist>"
  }

  parse_check_output(out)
}
