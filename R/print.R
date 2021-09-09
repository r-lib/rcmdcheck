
#' Print R CMD check results
#' @param x Check result object to print.
#' @param header Whether to print a header.
#' @param test_output if `TRUE`, include the test output in the results, even
#'   if there are no test failures.
#' @param ... Additional arguments, currently ignored.
#' @export
#' @importFrom cli symbol
#' @importFrom prettyunits pretty_sec

print.rcmdcheck <- function(x, header = TRUE, test_output = getOption("rcmdcheck.test_output", FALSE), ...) {

  if (header) {
    cat_head("R CMD check results", paste(x$package, x$version))
    cat_line("Duration: ", pretty_sec(x$duration))
    cat_line()
  }

  if (length(x$errors)) {
    lapply(x$errors, print_entry, entry_style = "err")
  }

  if (length(x$warnings)) {
    lapply(x$warnings, print_entry, entry_style = "warn")
  }

  if (length(x$notes)) {
    lapply(x$notes, print_entry, entry_style = "note")
  }

  if (install_failed(x$stdout)) {
    cat_head("Install failure")
    cat_line()
    cat(x$install_out)
    cat_line()
  }

  for (fail in names(x$test_fail)) {
    cat_head("Test failures", fail)
    cat_line()
    cat(x$test_fail[[fail]])
    cat_line()
  }

  if (isTRUE(test_output)) {
    for (name in names(x$test_output)) {
      cat_head("Test results", name)
      cat_line()
      cat(x$test_output[[name]])
      cat_line()
    }
  }

  print(summary(x, ...), line = FALSE)
}

make_line <- function(x) {
  paste(rep(symbol$line, x), collapse = "")
}

header_line <- function(left = "", right = "",
                        width = cli::console_width()) {

  ncl <- nchar(left)
  ncr <- nchar(right)

  if (ncl) left <- paste0(" ", left, " ")
  if (ncr) right <- paste0(" ", right, " ")
  ndashes <- width - ((ncl > 0) * 2  + (ncr > 0) * 2 + ncl + ncr)

  if (ndashes < 4) {
    right <- substr(right, 1, ncr - (4 - ndashes))
    ncr <- nchar(right)

  }

  dashes <- make_line(ndashes)

  res <- paste0(
    substr(dashes, 1, 2),
    left,
    substr(dashes, 3, ndashes - 4),
    right,
    substr(dashes, ndashes - 3, ndashes)
  )[1]

  substring(res, 1, width)
}

cat_head <- function(left, right = "", style = cyan) {
  str <- header_line(left, right)
  cat_line(str, style = style)
}

print_entry <- function(entry, entry_style) {

  lines <- strsplit(entry, "\n", fixed = TRUE)[[1]]

  if (grepl(paste0("^(checking tests)|",
                   "(running tests for arch)|",
                   "(checking whether package)"), lines[1])) {
    lines <- c(lines[1], "See below...")
  }

  first <- paste0(symbol$pointer, " ", lines[1])
  head <- do.call(style, structure(list(first), names = entry_style))
  cat(head, "\n", sep = "")

  cat(paste0("  ", lines[-1]), sep = "\n", "")
}

#' @export

summary.rcmdcheck <- function(object, ...) {
  structure(list(object), class = "rcmdcheck_summary")
}

print.rcmdcheck_summary <- function(x, ..., line = TRUE) {
  object <- x[[1]]

  if (line) {
    cat(symbol$line, symbol$line, " ", sep = "")
  }

  summary_entry(object, "errors")
  cat(" | ")
  summary_entry(object, "warnings")
  cat(" | ")
  summary_entry(object, "notes")
  cat("\n")
}

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
