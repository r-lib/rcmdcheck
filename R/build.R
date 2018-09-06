
#' @importFrom pkgbuild build
#' @importFrom withr with_envvar

build_package <- function(path, tmpdir, build_args, libpath, quiet) {
  dir.create(tmpdir)

  if (file.info(path)$isdir) {
    if (!quiet) cat_head("R CMD build")
    with_envvar(
      c("R_LIBS_USER" = paste(libpath, collapse = .Platform$path.sep)),
      build(path, tmpdir, args = build_args, quiet = quiet)
    )

  } else {
    file.copy(path, tmpdir)
    file.path(tmpdir, basename(path))
  }
}
