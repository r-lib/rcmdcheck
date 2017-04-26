
#' @importFrom R6 R6Class
NULL

#' @export

rcmdcheck_process <- R6Class(
  "rcmdcheck_process",
  inherit = callr::rcmd_process,
  public = list(
    initialize = function(path = ".", args = character(),
      libpath = .libPaths(), repos = getOption("repos"))
      rcc_init(self, private, super, path, args, libpath, repos)
  ),
  private = list(
    path  = NULL,
    tmp   = NULL,
    targz = NULL
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
