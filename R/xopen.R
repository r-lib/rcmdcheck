
#' Open the check directory in a file browser window
#'
#' @param target `rcmdcheck()` result.
#' @inheritParams xopen::xopen
#' 
#' @export
#' @importFrom xopen xopen

xopen.rcmdcheck <- function(target, app = NULL, quiet = FALSE, ...) {
  xopen(target$checkdir, app = app, quiet = quiet, ...)
}
