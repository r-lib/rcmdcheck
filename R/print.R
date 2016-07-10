
#' @export
#' @importFrom clisymbols symbol

print.rcmdcheck <- function(x, ...) {

  cat("\n")

  print_header("R CMD check results", paste(x$package, x$version))

  if (length(x$errors)) {
    lapply(x$errors, print_entry)
  }

  if (length(x$warnings)) {
    lapply(x$warnings, print_entry)
  }

  if (length(x$notes)) {
    lapply(x$notes, print_entry)
  }

  summary(x, ...)
}

make_line <- function(x) {
  paste(rep(symbol$line, x), collapse = "")
}

lines <- vapply(1:100, FUN.VALUE = "", make_line)

header_line <- function(left = "", right = "",
                        width = getOption("width")) {

  ncl <- nchar(left)
  ncr <- nchar(right)

  if (ncl) left <- paste0(" ", left, " ")
  if (ncr) right <- paste0(" ", right, " ")
  ndashes <- width - ((ncl > 0) * 2  + (ncr > 0) * 2 + ncl + ncr)

  if (ndashes < 4) {
    right <- substr(right, 1, ncr - (4 - ndashes))
    ncr <- nchar(right)

  }

  dashes <- if (ndashes <= length(lines)) {
    lines[ndashes]
  } else {
    make_line(ndashes)
  }

  res <- paste0(
    substr(dashes, 1, 2),
    left,
    substr(dashes, 3, ndashes - 4),
    right,
    substr(dashes, ndashes - 3, ndashes)
  )[1]

  substring(res, 1, width)
}

#' @importFrom crayon cyan

print_header <- function(left, right = "") {
  str <- header_line(left, right)
  cat(cyan(str), "\n\n", sep = "")
}

#' @importFrom crayon red make_style

print_entry <- function(entry) {

  greyish <- make_style("darkgrey")

  lines <- strsplit(entry, "\n", fixed = TRUE)[[1]]

  first <- paste0(symbol$pointer, " ", lines[1])
  cat(red(first), "\n", sep = "")

  cat(paste0("  ", greyish(lines[-1])), sep = "\n", "")
}

#' @export

summary.rcmdcheck <- function(object, ...) {

  cat(symbol$line, symbol$line, " ", sep = "")
  summary_entry(object, "errors")
  cat(" | ")
  summary_entry(object, "warnings")
  cat(" | ")
  summary_entry(object, "notes")
  cat("\n")
}

#' @importFrom crayon green red

summary_entry <- function(x, name) {

  len <- length(x[[name]])

  if (len == 0) {
    cat(green(paste(len, name, symbol$tick)))

  } else if (len == 1) {
    cat(red(paste(len, sub("s$", "", name), symbol$cross)))

  } else {
    cat(red(paste(len, name, symbol$cross)))
  }
}
