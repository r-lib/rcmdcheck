rcmdcheck_comparison <- function(old, new) {
  stopifnot(is.list(old))
  stopifnot(inherits(new, "rcmdcheck"))

  # Generate single dataframe of comparisons
  old_df <- do.call(rbind, lapply(old, checks_as_df))
  new_df <- checks_as_df(new)

  cmp <- rbind(
    data_frame(which = "old", old_df),
    data_frame(which = "new", new_df)
  )

  structure(
    list(
      old = old,
      new = new,
      cmp = cmp
    ),
    class = "rcmdcheck_comparison"
  )
}

checks_as_df <- function(check) {

  entries <- list(
    type = c(
      rep("error", length(check$errors)),
      rep("warning", length(check$warnings)),
      rep("note", length(check$notes))
    ),
    output = c(check$errors, check$warnings, check$notes)
  )

  data_frame(
    platform = check$platform %||% NA_character_,
    rversion = check$rversion %||% NA_character_,
    package = check$package %||% NA_character_,
    version = check$version %||% NA_character_,
    type = entries$type,
    output = entries$output,
    hash = hash_check(entries$output)
  )
}

#' @importFrom digest digest

hash_check <- function(check) {
  cleancheck <- gsub("[^a-zA-Z0-9]", "", first_line(check))
  vapply(cleancheck, digest, "")
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
        x$old[[1]]$package, " ",
        x$old[[1]]$version,
        " vs ",
        if (x$old[[1]]$package != x$new$package)
          paste0(x$new$package, " "),
        x$new$version
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
