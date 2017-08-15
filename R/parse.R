
new_rcmdcheck <- function(stdout,
                          stderr,
                          description,
                          status = 0L,
                          duration = 0L,
                          timeout = FALSE,
                          checkdir = NULL,
                          test_fail = NULL,
                          install_out = NULL,
                          session_info = NULL) {

  stopifnot(inherits(description, "description"))

  entries <- strsplit(paste0("\n", stdout), "\n* ", fixed = TRUE)[[1]][-1]
  checkdir <- checkdir %||% parse_checkdir(entries)

  res <- structure(
    list(
      stdout      = stdout,
      stderr      = stderr,
      status      = status,
      duration    = duration,
      timeout     = timeout,

      rversion    = parse_rversion(entries),
      platform    = parse_platform(entries),
      errors      = grep(" ...\\s+ERROR\n",   entries, value = TRUE),
      warnings    = grep(" ...\\s+WARNING\n", entries, value = TRUE),
      notes       = grep(" ...\\s+NOTE\n",    entries, value = TRUE),

      description = description$str(normalize = FALSE),
      package     = description$get("Package")[[1]],
      version     = description$get("Version")[[1]],

      checkdir    = checkdir,
      test_fail   = test_fail %||% get_test_fail(checkdir),
      install_out = install_out %||% get_install_out(checkdir),
      session_info = session_info
    ),
    class = "rcmdcheck"
  )

  if (isTRUE(timeout)) {
    res$errors <- c(res$errors, "R CMD check timed out")
  }

  res
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

#' @export
as.data.frame.rcmdcheck <- function(x,
                                    row.names = NULL,
                                    optional = FALSE,
                                    ...,
                                    which) {

  entries <- list(
    type = c(
      rep("error", length(x$errors)),
      rep("warning", length(x$warnings)),
      rep("note", length(x$notes))
    ),
    output = c(x$errors, x$warnings, x$notes)
  )

  data_frame(
    which = which,
    platform = x$platform %||% NA_character_,
    rversion = x$rversion %||% NA_character_,
    package = x$package %||% NA_character_,
    version = x$version %||% NA_character_,
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

#' Parse \code{R CMD check} results from a file or string
#'
#' At most one of \code{file} or \code{text} can be given.
#' If both are \code{NULL}, then the current working directory
#' is checked for a \code{00check.log} file.
#'
#' @param file The \code{00check.log} file, or a directory that
#'   contains that file. It can also be a connection object.
#' @param text The contentst of a \code{00check.log} file.
#' @param ... Other arguments passed onto the constructor.
#'   Used for testing.
#' @return An \code{rcmdcheck} object, the check results.
#'
#' @seealso \code{\link{parse_check_url}}
#' @export
#' @importFrom desc description

parse_check <- function(file = NULL, text = NULL, ...) {

  ## If no text, then find the file, and read it in
  if (is.null(text)) {
    file <- find_check_file(file)
    text <- readLines(file)
  }
  stdout <- paste(text, collapse = "\n")

  # Simulate minimal description from info in log
  entries <- strsplit(paste0("\n", stdout), "\n* ", fixed = TRUE)[[1]][-1]
  desc <- desc::description$new("!new")
  desc$set(
    Package = parse_package(entries),
    Version = parse_version(entries)
  )

  new_rcmdcheck(
    stdout = stdout,
    stderr = "",
    description = desc,
    ...
  )
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
