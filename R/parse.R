
parse_check_output <- function(output, package = NULL, version = NULL,
                               rversion = NULL, platform = NULL,
                               description = NULL) {

  entries <- strsplit(paste0("\n", output$stdout), "\n* ", fixed = TRUE)[[1]][-1]

  res <- structure(
    list(
      output   = output,
      errors   = grep(" ...\\s+ERROR\n",   entries, value = TRUE),
      warnings = grep(" ...\\s+WARNING\n", entries, value = TRUE),
      notes    = grep(" ...\\s+NOTE\n",    entries, value = TRUE),
      package  = package %||% parse_package(entries),
      version  = version %||% parse_version(entries),
      rversion = rversion %||% parse_rversion(entries),
      platform = platform %||% parse_platform(entries),
      checkdir = parse_checkdir(entries)
    ),
    class = "rcmdcheck"
  )

  res$install_out <- get_install_out(res$checkdir)
  res$description <- description %||% get_check_description(res$checkdir)

  if (isTRUE(output$timeout)) {
    res$errors = c(res$errors, "R CMD check timed out")
  }

  res
}

parse_package <- function(entries) {
  line <- grep("^this is package .* version", entries, value = TRUE)
  sub(
    "^this is package .([a-zA-Z0-9\\.]+)[^a-zA-Z0-9\\.].*$",
    "\\1",
    line,
    perl = TRUE
  )
}

parse_version <- function(entries) {
  line <- grep("^this is package .* version", entries, value = TRUE)
  sub(
    "^this is package .[a-zA-Z0-9\\.]+. version .([-0-9\\.]+)[^-0-9\\.].*$",
    "\\1",
    line,
    perl = TRUE
  )
}

parse_rversion <- function(entries) {
  line <- grep("^using R version", entries, value = TRUE)
  sub("^using R version ([^\\s]+)\\s.*$", "\\1", line, perl = TRUE)
}

parse_platform <- function(entries) {
  line <- grep("^using platform:", entries, value = TRUE)
  sub("^using platform: ([^\\s]+)\\s.*$", "\\1", line, perl = TRUE)
}

parse_checkdir <- function(entries) {
  line <- grep("^using log directory", entries, value = TRUE)
  sub("^using log directory\\s+[^/\\\\]+([/\\\\].+\\.Rcheck).*$", "\\1",
      line, perl = TRUE)
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
