
read_char <- function(path, ...) {
  readChar(path, nchars = file.info(path)$size, ...)
}

win2unix <- function(str) {
  gsub("\r\n", "\n", str, fixed = TRUE)
}

#' @importFrom utils download.file

download_file <- function(url, quiet = TRUE) {
  download.file(url, tmp <- tempfile(), quiet = quiet)
  on.exit(unlink(tmp), add = TRUE)
  readLines(tmp)
}

is_string <- function(x) {
  is.character(x) && length(x) == 1 && !is.na(x)
}
