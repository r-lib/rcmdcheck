
make_fake_profile  <- function(package, session_output, libdir) {
  profile <- tempfile()

  args <- list(
    `__output__` = session_output,
    `__package__` = package,
    `__libdir__` = libdir
  )

  expr <- substitute({
    local({
      reg.finalizer(
        .GlobalEnv,
        function(...) {
          tryCatch({
            .libPaths(c(`__libdir__`, .libPaths()))
            si <- sessioninfo::session_info(pkgs = `__package__`)
            saveRDS(si, `__output__`)
          }, error = function(e) NULL)
        },
        onexit = TRUE
      )
      Sys.unsetenv("R_TESTS")
    })
  }, args)

  cat(deparse(expr), sep = "\n", file = profile)
  
  profile
}

get_session_info <- function(package, session_output) {

  ## Extract session info for this package
  session_info <- tryCatch(
    suppressWarnings(readRDS(session_output)),
    error = function(e) NULL
  )

  session_info
}
