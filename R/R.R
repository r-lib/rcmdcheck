
R <- function(..., callback = NULL) {

  rbin <- file.path(R.home("bin"), "R")

  args <- as.character(unlist(list(...)))

  safe_system(rbin, args = args, callback = callback)
}
