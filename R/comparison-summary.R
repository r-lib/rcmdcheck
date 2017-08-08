
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
    if (isTRUE(object$new$timeout)) {
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
