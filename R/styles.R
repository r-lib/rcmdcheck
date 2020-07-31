rcmdcheck_color <- function(f) {
  function(...) {
    if (identical(Sys.getenv("RCMDCHECK_COLOR", "false"), "true")) {
      withr::local_options(c(crayon.enabled = TRUE))
    }
    f(...)
  }
}

style <- function(..., sep = "") {

  args <- list(...)
  st <- names(args)

  styles <- list(
    "ok"     = green,
    "note"   = make_style("blue"),
    "warn"   = make_style("magenta"),
    "err"    = red,
    "pale"   = make_style("darkgrey"),
    "timing" = make_style("cyan")
  )

  nms <- names(args)
  x <- lapply(seq_along(args), function(i) {
    if (nzchar(nms[i])) styles[[nms[i]]](args[[i]]) else args[[i]]
  })

  paste(unlist(x), collapse = sep)
}

red <- rcmdcheck_color(crayon::red)
green <- rcmdcheck_color(crayon::green)
yellow <- rcmdcheck_color(crayon::yellow)
bold <- rcmdcheck_color(crayon::bold)
underline <- rcmdcheck_color(crayon::underline)
bgRed <- rcmdcheck_color(crayon::bgRed)
white <- rcmdcheck_color(crayon::white)
cyan <- rcmdcheck_color(crayon::cyan)
make_style <- rcmdcheck_color(crayon::make_style)
