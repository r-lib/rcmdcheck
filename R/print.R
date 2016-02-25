
#' @export
#' @importFrom clisymbols symbol

print.rcmdcheck <- function(x, ...) {

  if (length(x$errors)) {
    print_header(paste(symbol$cross, "Error(s)"))
    lapply(x$errors, print_entry)
  }

  if (length(x$warnings)) {
    print_header(paste(symbol$warning, "Warning(s)"))
    lapply(x$warnings, print_entry)
  }

  if (length(x$notes)) {
    print_header(paset(symbol$info, "Note(s)"))
    lapply(x$notes, print_entry)
  }
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

#' @importFrom crayon red

print_entry <- function(entry) {
  lines <- strsplit(entry, "\n", fixed = TRUE)[[1]]

  first <- paste0(symbol$pointer, " ", lines[1])
  cat(red(first), "\n", sep = "")

  cat(paste0("  ", lines[-1]), sep = "\n", "")
}
