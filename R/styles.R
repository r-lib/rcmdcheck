
rcmdcheck_color <- function(f) {
  function(...) {
    num_cols <- as_integer(getOption(
      "rcmdcheck.num_colors",
      Sys.getenv("RCMDCHECK_NUM_COLORS", "NA")
    ))
    if (! is.na(num_cols)) {
      withr::local_options(c(cli.num_colors = num_cols))
    }
    f(...)
  }
}

the <- new.env(parent = emptyenv())

style <- function(..., sep = "") {

  args <- list(...)
  st <- names(args)

  the$styles <- the$styles %||% list(
    "ok"     = rcmdcheck_color(cli::col_green),
    "note"   = rcmdcheck_color(cli::col_blue),
    "warn"   = rcmdcheck_color(cli::col_magenta),
    "err"    = rcmdcheck_color(cli::col_red),
    "pale"   = rcmdcheck_color(cli::col_grey),
    "timing" = rcmdcheck_color(cli::col_cyan)
  )

  nms <- names(args)
  x <- lapply(seq_along(args), function(i) {
    if (nzchar(nms[i])) the$styles[[nms[i]]](args[[i]]) else args[[i]]
  })

  paste(unlist(x), collapse = sep)
}

red       <- NULL
green     <- NULL
yellow    <- NULL
bold      <- NULL
underline <- NULL
bgRed     <- NULL
white     <- NULL
cyan      <- NULL
darkgrey  <- NULL

.onLoad <- function(libname, pkgname) {
  red       <<- rcmdcheck_color(cli::col_red)
  green     <<- rcmdcheck_color(cli::col_green)
  yellow    <<- rcmdcheck_color(cli::col_yellow)
  bold      <<- rcmdcheck_color(cli::style_bold)
  underline <<- rcmdcheck_color(cli::style_underline)
  bgRed     <<- rcmdcheck_color(cli::bg_red)
  white     <<- rcmdcheck_color(cli::col_white)
  cyan      <<- rcmdcheck_color(cli::col_cyan)
  darkgrey  <<- rcmdcheck_color(cli::col_grey)
}
