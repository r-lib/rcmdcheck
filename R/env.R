
load_env <- function(path, targz, package, envir = parent.frame()) {
  should_load <- as_flag(
    Sys.getenv("RCMDCHECK_LOAD_CHECK_ENV"),
    as_flag(Sys.getenv("NOT_CRAN"))
  )
  if (!should_load) return()

  env <- NULL
  if (file.info(path)$isdir) {
    env_path <- file.path(path, "tools", "check.env")
  } else {
    dir.create(tmp <- tempfile())
    on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
    untar(
      targz,
      file.path(package, "tools", "check.env"),
      exdir = tmp, tar = "internal"
    )
    env_path <- file.path(tmp, package, "tools", "check.env")
  }

  if (file.exists(env_path)) {
    load_env_file(env_path, envir = envir)
  }
}

load_env_file <- function(path, envir = parent.frame()) {
  env <- readLines(path, warn = FALSE)
  env <- ignore_comments(env)
  env <- ignore_empty_lines(env)
  if (length(env) == 0) return(invisible())

  env <- lapply(env, parse_dot_line)
  envc <- structure(
    vapply(env, "[[", character(1), "value"),
    names = vapply(env, "[[", character(1), "key")
  )
  withr::local_envvar(envc, .local_envir = envir)
}

ignore_comments <- function(lines) {
  grep("^#", lines, invert = TRUE, value = TRUE)
}

ignore_empty_lines <- function(lines) {
  grep("^\\s*$", lines, invert = TRUE, value = TRUE)
}

line_regex <- paste0(
  "^\\s*",                  # leading whitespace
  "(?<export>export\\s+)?", # export, if given
  "(?<key>[^=]+)",          # variable name
  "=",                      # equals sign
  "(?<q>['\"]?)",           # quote if present
  "(?<value>.*)",           # value
  "\\g{q}",                 # the same quote again
  "\\s*",                   # trailing whitespace
  "$"                       # end of line
)

parse_dot_line <- function(line) {
  match <- regexpr(line_regex, line, perl = TRUE)
  if (match == -1) {
    stop("Cannot parse check.env: ", substr(line, 1, 40), call. = FALSE)
  }
  as.list(extract_match(line, match)[c("key", "value")])
}

extract_match <- function(line, match) {
  tmp <- mapply(
    attr(match, "capture.start"),
    attr(match, "capture.length"),
    FUN = function(start, length) {
      tmp <- substr(line, start, start + length - 1)
    }
  )
  names(tmp) <- attr(match, "capture.names")
  tmp
}
