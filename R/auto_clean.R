auto_clean <- function(paths) {
  env <- new.env(parent = emptyenv())
  reg.finalizer(env, onexit = TRUE, function(e) {
    try(unlink(paths, recursive = TRUE), silent = TRUE)
  })

  env
}
