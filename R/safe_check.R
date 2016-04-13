
safe_check_packages <- function(..., args, quiet, libpath, repos) {

  lib <- paste(libpath, collapse = .Platform$path.sep)

  profile <- tempfile()
  cat("options(repos=", deparse(repos), ")\n", sep = "", file = profile)

  with_envvar(
    c(R_LIBS = lib,
      R_LIBS_USER = lib,
      R_LIBS_SITE = lib,
      R_PROFILE_USER = profile),
    R("CMD", "check", ..., args, callback = if (!quiet) check_callback())
  )
}
