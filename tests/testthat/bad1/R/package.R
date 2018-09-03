
foobar <- function(argument) {
  argument
}

#' foobar2
#' @export
#' @examples
#' foobar2()

foobar2 <- function() {
  l <- list(alpha = 1, beta = 2, gamma = 3)
  attr(l, "attribute") <- 41
  x1 <- l$alp
  x2 <- attr(l, "at")
  foobar(arg = x1 + x2)
}
