
#' @export
#' @importFrom callr rcmd_bg_safe

rcmdcheck_bg <- function(path = ".", args = character(),
                         libpath = .libPaths(),
                         repos = getOption("repos")) {

  if (file.info(path)$isdir) {
    path <- find_package_root_file(path = path)
  } else {
    path <- normalizePath(path)
  }

  targz <- build_package(path, tmp <- tempfile())

  proc <- with_dir(
    dirname(targz),
    rcmd_bg_safe(
      "check",
      cmdargs = c(basename(targz), args),
      libpath = libpath,
      repos = repos
    )
  )

  list(process = proc, targz = targz)
}
