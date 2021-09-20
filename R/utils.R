
read_char <- function(path, encoding = "", ...) {
  txt <- readChar(path, nchars = file.info(path)$size, useBytes = TRUE, ...)
  iconv(txt, encoding, "UTF-8", sub = "byte")
}

win2unix <- function(str) {
  gsub("\r\n", "\n", str, fixed = TRUE, useBytes = TRUE)
}

is_string <- function(x) {
  is.character(x) && length(x) == 1 && !is.na(x)
}

is_count <- function(x) {
  is.numeric(x) && length(x) == 1 && !is.na(x) && round(x) == x
}

`%notin%` <- function(needle, haystack) {
  ! (needle %in% haystack)
}

`%||%` <- function(l, r) if (is.null(l)) r else l

#' Alternative to data.frame
#'
#' * Sets stringsAsFactors to FALSE by default
#' * If any columns have zero length, the result will have
#'   zero rows.
#' * If a column is a scalar, then it will be recycled.
#' * Non-matching number of rows gives an error, except for
#'   lengths zero and one.
#'
#' @param ... Named data frame columns, or data frames.
#' @param stringsAsFactors Just leave it on `FALSE`. `:)`
#' @return Data frame.
#'
#' @keywords internal

data_frame <- function(..., stringsAsFactors = FALSE) {
  cols <- list(...)
  stopifnot(length(cols) > 0)

  len <- vapply(cols, NROW, 1L)
  maxlen <- max(len)
  stopifnot(all(len %in% c(0, 1, maxlen)))

  ## recycle, only scalars. If one empty, all empty
  res_len <- if (0 %in% len) 0 else maxlen
  cols2 <- lapply(cols, function(x) myrep(x, res_len))
  names(cols2) <- names(cols)

  res <- do.call(
    data.frame,
    c(cols2, list(stringsAsFactors = stringsAsFactors))
  )
  reset_row_names(res)
}

#' Recycle a vector or a data frame (rows)
#'
#' @param x Vector or data frame to replicate. Must be length 0, 1, or
#'   len.
#' @param len Expected length.
#'
#' @keywords internal

myrep <- function(x, len) {

  stopifnot(len == 0 || NROW(x) == len || NROW(x) == 1)

  if (NROW(x) == len) {
    x

  } else if (is.data.frame(x)) {
    x[ rep(1, len), ]

  } else {
    rep(x, length.out = len)
  }
}

reset_row_names <- function(df) {
  rownames(df) <- NULL
  df
}

first_line <- function(x) {
  l <- strsplit(x, "\n", fixed = TRUE)
  vapply(l, "[[", "", 1)
}

last_char <- function(x) {
  l <- nchar(x)
  substr(x, l, l)
}

cat0 <- function(..., sep = "") {
  cat(..., sep = "")
}

get_install_out <- function(path, encoding = "") {
  install_out <- file.path(path, "00install.out")
  if (is_string(install_out) && file.exists(install_out)) {
    win2unix(read_char(install_out, encoding = encoding))
  } else {
    "<00install.out file does not exist>"
  }
}

col_align <- function(text, width = cli::console_width(),
                      align = c("left", "center", "right")) {

  align <- match.arg(align)
  nc <- cli::ansi_nchar(text, type = "width")

  if (width <= nc) {
    text

  } else if (align == "left") {
    paste0(text, make_space(width - nc))

  } else if (align == "center") {
    paste0(make_space(ceiling((width - nc) / 2)),
           text,
           make_space(floor((width - nc) / 2)))

  } else {
    paste0(make_space(width - nc), text)
  }
}

strrep <- function(x, times) {
  x <- as.character(x)
  if (length(x) == 0L) return(x)
  r <- .mapply(
    function(x, times) {
      if (is.na(x) || is.na(times)) return(NA_character_)
      if (times <= 0L) return("")
      paste0(replicate(times, x), collapse = "")
    },
    list(x = x, times = times), MoreArgs = list())
  unlist(r, use.names = FALSE)
}

make_space <- function(num, filling = " ") {
  strrep(filling, num)
}

cat_line <- function(..., style = NULL) {
  text <- paste0(..., collapse = "")
  if (!is.null(style)) {
    text <- style(text)
  }

  cat(text, "\n", sep = "")
}

duration <- function(start) {
  as.double(Sys.time() - start, units = "secs")
}

as_integer <- function(x) {
  suppressWarnings(as.integer(x))
}

YES_WORDS <- c("true",  "yes", "on",  "1", "yep",  "yeah")
NO_WORDS  <- c("false", "no",  "off", "0", "nope", "nah")

as_flag <- function(x, default = FALSE, name = "") {
  x1 <- trimws(tolower(x))
  if (is.na(x1)) return(default)
  if (x1 == "") return(default)
  if (x1 %in% YES_WORDS) return(TRUE)
  if (x1 %in% NO_WORDS) return(FALSE)
  warning(
    "Invalid ",
    if (nchar(name)) paste0(encodeString(name, quote = "`"), " "),
    "option value: ",
    encodeString(x, quote = "`"),
    ", must be TRUE or FALSE"
  )
  default
}

no_timing <- function(x) {
  gsub("\\[[0-9]+s(/[0-9]+s)?\\] ([A-Z]+)", "\\2", x, useBytes = TRUE)
}

should_use_rs_pandoc <- function() {
  ev <- Sys.getenv("RCMDCHECK_USE_RSTUDIO_PANDOC", "")

  if (tolower(ev) == "true") {
    TRUE

  } else if (tolower(ev) == "false") {
    FALSE

  } else {
    !nzchar(Sys.which("pandoc")) && nzchar(Sys.getenv("RSTUDIO_PANDOC"))
  }
}

data_literal <- function(...) {
  cl <- match.call(expand.dots = FALSE)
  rows <- vapply(cl$..., function(x) paste(deparse(x), collapse = " "), "")
  utils::read.table(
    textConnection(rows),
    strip.white = TRUE,
    sep = "|",
    header = TRUE,
    colClasses = "character"
  )
}
