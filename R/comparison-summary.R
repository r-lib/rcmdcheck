
#' @export

summary.rcmdcheck_comparison <- function(object, ...) {
  structure(list(object), class = "rcmdcheck_comparison_summary")
}

#' @export

print.rcmdcheck_comparison_summary <- function(x, ...) {
  object <- x[[1]]

  sum_status <- switch(object$status,
    "t-" = white(bgRed("T")),
    "t+" = "T",
    "i-" = white(bgRed("I")),
    "i+" = "I",
    "+" = green(symbol$tick),
    "-" = red(symbol$cross)
  )
  header <- paste0(sum_status, " ", object$package, " ", object$versions[[1]])

  cat_line(
    col_align(header, width = 40), " ",
    symbol$line, symbol$line, " ",
    change_summary(object$cmp, "error"), " | ",
    change_summary(object$cmp, "warning"), " | ",
    change_summary(object$cmp, "note"),
    style = make_style("darkgrey")
  )

  invisible(x)
}

change_summary <- function(rows, type) {
  rows <- rows[rows$type == type, , drop = FALSE]
  n <- function(change) sum(rows$change == change)

  paste0(
    toupper(substr(type, 1, 1)), ": ",
    n(0),
    if (n(-1)) green(paste0("-", n(-1))) else "  ",
    if (n(1)) red(paste0("+", n(1))) else "  "
  )
}

