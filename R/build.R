
#' @importFrom withr with_dir

build_package <- function(path, tmpdir, build_args = character(), quiet) {

  dir.create(tmpdir)
  file.copy(path, tmpdir, recursive = TRUE)

  ## If not a tar.gz, build it. Otherwise just leave it as it is.
  if (file.info(path)$isdir) {
    build_status <- with_dir(
      tmpdir,
      rcmd_safe("build", basename(path), cmdargs = build_args,
                block_callback = if (!quiet) block_callback())
    )
    unlink(file.path(tmpdir, basename(path)), recursive = TRUE)
    report_system_error("Build failed", build_status)
  }

  ## replace previous handler, no need to clean up any more
  on.exit(NULL)

  file.path(
    tmpdir,
    list.files(tmpdir, pattern = "\\.tar\\.gz$")
  )
}
