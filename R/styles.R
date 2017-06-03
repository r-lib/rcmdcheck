
#' @importFrom crayon red green make_style bold

style <- function(..., sep = "") {

  args <- list(...)
  st <- names(args)

  styles <- list(
    "ok"     = green,
    "note"   = make_style("orange"),
    "warn"   = make_style("orange") $ bold,
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
