
read_char <- function(path, ...) {
  readChar(path, nchars = file.info(path)$size, ...)
}

win2unix <- function(str) {
  gsub("\r\n", "\n", str, fixed = TRUE)
}

#' @importFrom utils download.file

download_file <- function(url, quiet = TRUE) {
  download.file(url, tmp <- tempfile(), quiet = quiet)
  on.exit(unlink(tmp), add = TRUE)
  readLines(tmp)
}

is_string <- function(x) {
  is.character(x) && length(x) == 1 && !is.na(x)
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

get_install_out <- function(path) {
  install_out <- file.path(path, "00install.out")
  if (is_string(install_out) && file.exists(install_out)) {
    read_char(install_out)
  } else {
    "<00install.out file does not exist>"
  }
}

get_test_fail <- function(path) {
  test_path <- file.path(path, "tests")
  paths <- dir(test_path, pattern = "\\.Rout\\.fail$", full.names = TRUE)
  names(paths) <- gsub("\\.Rout.fail", "", basename(paths))

  trim_header <- function(x) {
    first_gt <- regexpr(">", x)
    substr(x, first_gt, nchar(x))
  }

  tests <- lapply(paths, read_char)
  lapply(tests, trim_header)
}


#' @importFrom crayon col_nchar

col_align <- function(text, width = getOption("width"),
                      align = c("left", "center", "right")) {

  align <- match.arg(align)
  nc <- col_nchar(text)

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
  as.numeric(Sys.time() - start)
}
