
#' @importFrom crayon yellow red underline

report_system_error <- function(msg, status) {

  if (status$status == 0) return()

  if (status$stderr == "") {
    stop(
      msg, ", unknown error, standard output:\n",
      yellow(status$stdout),
      call. = FALSE
    )

  } else {
    stop(
      underline(yellow(paste0("\n", msg, ", standard output:\n\n"))),
      yellow(status$stdout), "\n",
      underline(red("Standard error:\n\n")), red(status$stderr),
      call. = FALSE
    )
  }
}
