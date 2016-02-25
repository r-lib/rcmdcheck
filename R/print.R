
#' @export

print.rcmdcheck <- function(x, ...) {

  if (length(x$errors)) {
    print_header("Error(s)")
    lapply(x$errors, print_entry)
  }

  if (length(x$warnings)) {
    print_header("Warning(s)")
    lapply(x$warnings, print_entry)
  }

  if (length(x$notes)) {
    print_header("Note(s)")
    lapply(x$notes, print_entry)
  }
}

print_header <- function(text) {
  width <- min(getOption("width", 80), 80)
  cat("-- ", text, " ", rep("-", width - nchar(text) - 4), "\n\n", sep = "")
}

print_entry <- function(entry) {
  cat(entry, sep = "", "\n")
}
