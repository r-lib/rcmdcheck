
#' @importFrom withr with_dir

build_package <- function(path) {

  path <- normalizePath(path)

  tmpdir <- tempfile()
  dir.create(tmpdir)
  on.exit(unlink(tmpdir, recursive = TRUE))

  file.copy(path, tmpdir, recursive = TRUE)

  ## If not a tar.gz, build it. Otherwise just leave it as it is.
  if (file.info(path)$isdir) {
    with_dir(
      tmpdir,
      R("CMD", "build", basename(path))
    )
    unlink(file.path(tmpdir, basename(path)), recursive = TRUE)
  }

  ## replace previous handler, no need to clean up any more
  on.exit(NULL)

  file.path(
    tmpdir,
    list.files(tmpdir, pattern = "\\.tar\\.gz$")
  )
}
