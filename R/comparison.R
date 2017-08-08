rcmdcheck_comparison <- function(old, new) {
  stopifnot(is.list(old))
  stopifnot(inherits(new, "rcmdcheck"))

  # Generate single dataframe of comparisons
  old_df <- do.call(rbind, lapply(old, as.data.frame, which = "old"))
  new_df <- as.data.frame(new, which = "new")
  cmp_df <- rbind(old_df, new_df)

  old_versions <- vapply(old, "[[", "version", FUN.VALUE = character(1))

  structure(
    list(
      package = new$package,
      versions = c(new$version, old_versions),
      old = old,
      new = new,
      cmp = cmp_df
    ),
    class = "rcmdcheck_comparison"
  )
}


#' Print R CMD check result comparisons
#'
#' See [compare_checks()] and [compare_to_cran()].
#'
#' @param x R CMD check result comparison object.
#' @param header Whether to print the header. You can suppress the
#'   header if you want to use the printout as part of another object's
#'   printout.
#' @param ... Additional arguments, currently ignored.
#' @export
#' @importFrom crayon red

print.rcmdcheck_comparison <- function(x, header = TRUE, ...) {

  if (header) {
    print_header(
      "R CMD check comparison",
      paste0(
        x$package, " ",
        paste0(x$versions, collapse = " / ")
      )
    )
  }

  print_comparison_fixed(x)
  print_comparison_same(x)
  print_comparison_new(x)

  invisible(x)
}

#' @importFrom crayon red green

print_comparison_new <- function(x) {
  print_comparison_x(x, red, setdiff, "Newly failing")
}

print_comparison_same <- function(x) {
  print_comparison_x(x, red, intersect, "Still failing")
}

print_comparison_fixed <- function(x) {
  print_comparison_x(x, green, function(x, y) setdiff(y, x), "Fixed")
}

print_comparison_x <- function(x, color, func, str) {
  old <- x$cmp$hash[x$cmp$which == "old"]
  new <- x$cmp$hash[x$cmp$which == "new"]

  chn <- func(unique(new), unique(old))

  symb <- if (str == "Fixed") green(symbol$tick) else red(symbol$cross)

  if (length(chn)) {
    cat(color(paste0(symbol$line, symbol$line, " ", str, "\n\n")))
    for (i in match(chn, x$cmp$hash)) {
      cat(symb, first_line(x$cmp$output[i]), "\n")
    }
    cat("\n")
  }
}
