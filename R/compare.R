
#' Compare a set of check results to another check result
#'
#' @param old A check result, or a list of check results.
#' @param new A check result.
#' @return An `rcmdcheck_comparison` object.
#'
#' @family check comparisons
#' @export

compare_checks <- function(old, new) {
  if (inherits(old, "rcmdcheck")) old <- list(old)
  structure(
    list(old = old, new = new, cmp = compare_checks_really(old, new)),
    class = "rcmdcheck_comparison"
  )
}

#' Compare a check result to CRAN check results
#'
#' @param check A check result.
#' @param flavours CRAN check flavour(s) to use. By default all
#'   platforms are used.
#' @return An `rmdcheck_comparison` object.
#'
#' @family check comparisons
#' @export

compare_to_cran <- function(check,
                            flavours = cran_check_flavours(check$package)) {
  pkg <- check$package
  cran <- cran_check_results(pkg, flavours = flavours)
  compare_checks(old = cran, new = check)
}

compare_checks_really <- function(old, new) {

  old_df <- do.call(rbind, lapply(old, checks_as_df))
  new_df <- checks_as_df(new)

  rbind(
    data_frame(which = "old", old_df),
    data_frame(which = "new", new_df)
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

#' @export
#' @importFrom crayon bgRed white

summary.rcmdcheck_comparison <- function(object, ...) {

  make_summary <- function(type) {
    recs <- object$cmp[object$cmp$type == type, , drop = FALSE]
    old <- unique(recs$hash[recs$which == "old"])
    new <- unique(recs$hash[recs$which == "new"])
    c(both  = length(intersect(old, new)),
      fixed = length(setdiff(old, new)),
      broke = length(setdiff(new, old)))
  }

  error_summary   <- make_summary("error")
  warning_summary <- make_summary("warning")
  note_summary    <- make_summary("note")

  re_install_failed <-
    "can be installed \\.\\.\\.\\s*ERROR\\s*Installation failed"

  sum_status <-
    if (isTRUE(object$new$output$timeout)) {
      white(bgRed("T"))
    } else if (any(grepl(re_install_failed, object$new$errors)) ||
               any(grepl(re_install_failed, unlist(lapply(object$old, "[[",
                                                          "errors"))))) {
      white(bgRed("I"))
    } else if ((error_summary + warning_summary +
                  note_summary)["broke"] == 0) {
      green(symbol$tick)
    } else {
      red(symbol$cross)
    }

  format_summary <- function(x) {
    paste0(
      x[["both"]],
      if (x[["fixed"]]) green(paste0("-", x[["fixed"]])) else "  ",
      if (x[["broke"]]) red(paste0("+", x[["broke"]])) else "  "
    )
  }

  oldversion <- paste(unique(vapply(object$old, "[[", "", "version")),
                      collapse = ", ")
  newversion <- object$new$version
  package_version <- if (oldversion == newversion) {
    oldversion
  } else {
    paste0(newversion, " vs ", oldversion)
  }

  header <- paste0(
    sum_status, " ",
    object$new$package, " ",
    package_version
  )

  structure(
    list(
      object = object,
      header = header,
      error_summary = error_summary,
      warning_summary = warning_summary,
      note_summary = note_summary,
      formatted_error_summary = format_summary(error_summary),
      formatted_warning_summary = format_summary(warning_summary),
      formatted_note_summary = format_summary(note_summary)
    ),
    class = "rcmdcheck_comparison_summary"
  )
}

#' @export

print.rcmdcheck_comparison_summary <- function(x, ...) {

  pale <- make_style("darkgrey")

  cat(
    pale(paste0(
      col_align(x$header, width = 40),
      " ", symbol$line, symbol$line, " ",
      "E: ", x$formatted_error_summary, " | ",
      "W: ", x$formatted_warning_summary, " | ",
      "N: ", x$formatted_note_summary
    )),
    "\n",
    sep = ""
  )

  invisible(x)
}
