
#' @importFrom pkgbuild pkgbuild_process
#' @importFrom withr with_libpaths

build_package <- function(path, tmpdir, build_args, libpath, quiet) {
  path <- normalizePath(path)

  check_for_tilde_file(path)

  dir.create(tmpdir, recursive = TRUE, showWarnings = FALSE)
  tmpdir <- normalizePath(tmpdir)

  if (file.info(path)$isdir) {
    if (!quiet) cat_head("R CMD build")

    desc <- desc(path)
    clean_doc <- as_flag(desc$get("Config/build/clean-inst-doc"), NULL)

    with_libpaths(libpath, {
        proc <- pkgbuild_process$new(
          path,
          tmpdir,
          args = build_args,
          clean_doc = clean_doc,
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

check_for_tilde_file <- function(path) {
  lst <- dir(path)
  if ("~" %in% lst) {
    stop(
      "This package contains a file or directory named `~`. ",
      "Because of a bug in older R versions (before R 4.0.0), ",
      "building this package might delete your entire home directory!",
      "It is best to (carefully!) remove the file. rcmdcheck will exit now."
    )
  }
}
