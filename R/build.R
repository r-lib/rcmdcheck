
#' @importFrom pkgbuild pkgbuild_process
#' @importFrom withr with_envvar

build_package <- function(path, tmpdir, build_args, libpath, quiet) {
  path <- normalizePath(path)

  dir.create(tmpdir, recursive = TRUE, showWarnings = FALSE)
  tmpdir <- normalizePath(tmpdir)

  if (file.info(path)$isdir) {
    if (!quiet) cat_head("R CMD build")
    with_envvar(
      c("R_LIBS_USER" = paste(libpath, collapse = .Platform$path.sep)), {
        proc <- pkgbuild_process$new(
          path,
          tmpdir,
          args = build_args,
          manual = TRUE
        )
        on.exit(proc$kill(), add = TRUE)
        callback <- detect_callback()
        while (proc$is_incomplete_output() ||
               proc$is_incomplete_error()
               || proc$is_alive()) {
          proc$poll_io(-1)
          out <- proc$read_output()
          err <- proc$read_error()
          if (!quiet) {
            out <- sub("(checking for file .)/.*DESCRIPTION(.)",
                       "\\1.../DESCRIPTION\\2", out, perl = TRUE)
            callback(out)
            callback(err)
          }
        }
        proc$get_built_file()
      }
    )

  } else {
    dest <- file.path(tmpdir, basename(path))
    if (!file.exists(dest) || normalizePath(dest) != path) {
      file.copy(path, dest, overwrite = TRUE)
    }
    dest
  }
}
