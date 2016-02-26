
#' @export
#' @importFrom clisymbols symbol

print.rcmdcheck <- function(x, ...) {

  if (length(x$errors)) {
    print_header(paste(symbol$cross, "Error(s)"))
    lapply(x$errors, print_entry)
  }

  if (length(x$warnings)) {
    print_header(paste("!", "Warning(s)"))
    lapply(x$warnings, print_entry)
  }

  if (length(x$notes)) {
    print_header(paste(symbol$info, "Note(s)"))
    lapply(x$notes, print_entry)
  }

  summary(x, ...)
}

#' @importFrom crayon magenta

print_header <- function(text) {
  width <- min(getOption("width", 80), 80)
  str <- paste0(
    "-- ",
    text,
    " ",
    paste(rep("-", width - nchar(text) - 4), collapse = "")
  )
  cat(magenta(str), "\n\n", sep = "")
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

  cat("-- ")
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
    cat(red(paste(len, name, symbol$cross)))

  } else {
    cat(red(paste(len, name, symbol$cross)))
  }
}
