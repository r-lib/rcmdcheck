
read_char <- function(path, ...) {
  readChar(path, nchars = file.info(path)$size, ...)
}

win2unix <- function(str) {
  gsub("\r\n", "\n", str, fixed = TRUE)
}
