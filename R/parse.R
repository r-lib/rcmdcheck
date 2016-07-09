
parse_check_output <- function(output) {

  entries <- strsplit(paste0("\n", output$stdout), "\n* ", fixed = TRUE)[[1]][-1]

  structure(
    list(
      output   = output,
      errors   = grep(" ... ERROR\n",   entries, value = TRUE, fixed = TRUE),
      warnings = grep(" ... WARNING\n", entries, value = TRUE, fixed = TRUE),
      notes    = grep(" ... NOTE\n",    entries, value = TRUE, fixed = TRUE)
    ),
    class = "rcmdcheck"
  )
}

#' Parse \code{R CMD check} results from a file or string
#'
#' At most one of \code{file} or \code{text} can be given.
#' If both are \code{NULL}, then the current working directory
#' is checked for a \code{00check.log} file.
#'
#' @param file The \code{00check.log} file, or a directory that
#'   contains that file. It can also be a connection object.
#' @param text The contentst of a \code{00check.log} file.
#' @return An \code{rcmdcheck} object, the check results.
#'
#' @seealso \code{\link{parse_check_url}}
#' @export

parse_check <- function(file = NULL, text = NULL) {

  ## If no text, then find the file, and read it in
  if (is.null(text)) {
    file <- find_check_file(file)
    text <- readLines(file)
  }

  output <- list(
    stdout = paste(text, collapse = "\n"),
    stderr = "",
    status = 0
  )

  parse_check_output(output)
}

#' Shorthand to parse R CMD check results from a URL
#'
#' @param url URL to parse the results from. Note that it should
#'   not contain HTML markup, just the text output.
#' @param quiet Passed to \code{download.file}.
#' @return An \code{rcmdcheck} object, the check results.
#'
#' @seealso \code{\link{parse_check}}
#' @export

parse_check_url <- function(url, quiet = TRUE) {
  parse_check(text = download_file(url, quiet = quiet))
}

find_check_file <- function(file) {

  if (is.null(file)) file <- "."

  if (file.exists(file) && file.info(file)$isdir) {
    find_check_file_indir(file)
  } else if (file.exists(file)) {
    file
  } else {
    stop("Cannot find R CMD check output file")
  }
}

find_check_file_indir <- function(dir) {
  if (file.exists(logfile <- file.path(dir, "00check.log"))) {
    logfile
  } else {
    stop("Cannot find R CMD check output file")
  }
}
