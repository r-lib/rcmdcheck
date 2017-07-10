
#' @importFrom withr with_dir

build_package <- function(path, tmpdir) {

  dir.create(tmpdir)

  ## If not a tar.gz, build it. Otherwise just leave it as it is
  ## (but sanitize the file name).
  if (file.info(path)$isdir) {
    file.copy(path, tmpdir, recursive = TRUE)

    build_status <- with_dir(
      tmpdir,
      rcmd_safe("build", basename(path))
    )
    unlink(file.path(tmpdir, basename(path)), recursive = TRUE)
    report_system_error("Build failed", build_status)

    ## This assumes that the built package doesn't contain a .tar.gz file
    ## on its root.
    target_path <- file.path(
      tmpdir,
      list.files(tmpdir, pattern = "\\.tar\\.gz$")
    )
  } else {
    target_path <- file.path(tmpdir, sanitize_tar_gz_name(basename(path)))
    file.copy(path, target_path)
  }

  target_path
}

sanitize_tar_gz_name <- function(name) {
  pkg_name_rx <- "[a-zA-Z][a-zA-Z0-9.]*[a-zA-Z0-9]"
  pkg_version_rx <- "[0-9.-]+"
  extension_rx <- "\\.tar\\.gz"
  gsub(
    paste0("^(", pkg_name_rx, "_", pkg_version_rx, ").*(", extension_rx, ")$"),
    "\\1\\2",
    name
  )
}
