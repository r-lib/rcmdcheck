
new_rcmdcheck <- function(stdout,
                          stderr,
                          description,
                          status = 0L,
                          duration = 0L,
                          timeout = FALSE,
                          test_fail = NULL,
                          session_info = NULL) {

  stopifnot(inherits(description, "description"))

  # Make sure we don't have \r on windows
  stdout <- win2unix(stdout)
  stderr <- win2unix(stderr)

  entries <- strsplit(paste0("\n", stdout), "\n\\*+[ ]")[[1]][-1]
  checkdir <- parse_checkdir(entries)

  notdone <- function(x) grep("^DONE", x, invert = TRUE, value = TRUE)

  res <- structure(
    list(
      stdout      = stdout,
      stderr      = stderr,
      status      = status,
      duration    = duration,
      timeout     = timeout,

      rversion    = parse_rversion(entries),
      platform    = parse_platform(entries),
      errors      = notdone(grep("ERROR\n",   entries, value = TRUE)),
      warnings    = notdone(grep("WARNING\n", entries, value = TRUE)),
      notes       = notdone(grep("NOTE\n",    entries, value = TRUE)),

      description = description$str(normalize = FALSE),
      package     = description$get("Package")[[1]],
      version     = description$get("Version")[[1]],
      cran        = description$get_field("Repository", "") == "CRAN",
      bioc        = description$has_fields("biocViews"),

      checkdir    = checkdir,
      test_fail = test_fail %||% get_test_fail(checkdir),
      test_output = get_test_output(checkdir, pattern = "\\.Rout"),
      install_out = get_install_out(checkdir)
    ),
    class = "rcmdcheck"
  )

  res$session_info <- get_session_info(res$package, session_info)

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
  quotes <- "\\x91\\x92\u2018\u2019`'"

  line <- grep("^using log directory", entries, value = TRUE)
  sub(
    paste0("^using log directory [", quotes, "]([^", quotes, "]+)[", quotes, "]$"),
    "\\1",
    line,
    perl = TRUE
  )
}
get_test_fail <- function(path, encoding = "") {
  get_test_output(path, pattern = "\\.Rout\\.fail", encoding = encoding)
}

get_test_output <- function(path, pattern, encoding = "") {
  test_path <- file.path(path, dir(path, pattern = "^tests"))
  paths <- dir(test_path, paste0(pattern, "$"), full.names = TRUE)

  test_dirs <- basename(dirname(paths))
  rel_paths <- ifelse(
    test_dirs == "tests",
    basename(paths),
    paste0(basename(paths), " (", sub("^tests_", "", test_dirs), ")"))
  names(paths) <- gsub(pattern, "", rel_paths, useBytes = TRUE)

  trim_header <- function(x) {
    first_gt <- regexpr(">", x)
    substr(x, first_gt, nchar(x))
  }

  tests <- lapply(paths, read_char, encoding = encoding)
  tests <- lapply(tests, win2unix)
  lapply(tests, trim_header)
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
    platform = x$platform %|0|% NA_character_,
    rversion = x$rversion %|0|% NA_character_,
    package = x$package %|0|% NA_character_,
    version = x$version %|0|% NA_character_,
    type = entries$type,
    output = entries$output,
    hash = hash_check(entries$output)
  )
}

#' @importFrom digest digest

hash_check <- function(check) {
  cleancheck <- gsub(
    "[^a-zA-Z0-9]",
    "",
    no_timing(first_line(check)),
    useBytes = TRUE
  )
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
#' @param text The contents of a \code{00check.log} file.
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
    text <- readLines(file, encoding = "bytes", warn = FALSE)
  }
  stdout <- paste(reencode_log(text), collapse = "\n")

  # Remove timestamps from checks as these cause false failures (#128)
  stdout <- gsub("\\[[0-9]+s/[0-9]+s\\]", "", stdout)

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

validEnc <- function(x) {
  ## We just don't do this on older R, because the functionality is
  ## not available
  if (getRversion() >= "3.3.0") {
    asNamespace("base")$validEnc(x)
  } else {
    rep(TRUE, length(x))
  }
}

reencode_log <- function(log) {
  csline <- head(grep("^\\* using session charset: ",
                      log, perl = TRUE, useBytes = TRUE, value = TRUE), 1)
  if (length(csline)) {
    cs <- strsplit(csline, ": ")[[1]][2]
    log <- iconv(log, cs, "UTF-8", sub = "byte")
    if (any(bad <- !validEnc(log))) {
      log[bad] <- iconv(log[bad], to = "ASCII", sub = "byte")
    }
  } else {
    log <- iconv(log, to = "ASCII", sub = "byte")
  }
  log
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

parse_check_url <- function(url, quiet = FALSE) {
  parse_check(text = download_file_lines(url, quiet = quiet))
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
