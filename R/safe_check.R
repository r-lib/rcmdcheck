
safe_check_packages <- function(..., quiet) {

  lib <- paste(.libPaths(), collapse = ":")

  with_envvar(
    c(R_LIBS = lib,
      R_LIBS_USER = lib,
      R_LIBS_SITE = lib,
      R_PROFILE_USER = tempfile()),
    R("CMD", "check", ..., callback = if (!quiet) check_callback())
  )
}
