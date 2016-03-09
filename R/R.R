
R <- function(..., args = NULL, callback = NULL) {

  rbin <- file.path(R.home("bin"), "R")

  args <- c(as.character(unlist(list(...))), args)

  safe_system(rbin, args = args, callback = callback)
}
