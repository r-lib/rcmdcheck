
foobar <- function(argument) {
  argument
}

#' foobar2
#' @export
#' @examples
#' foobar2()

foobar2 <- function() {
  outfile <- Sys.getenv("RCMDCHECK_OUTPUT", "")
  if (nzchar(outfile)) {
    cat(Sys.getpid(), sep = "\n", file = outfile)
  }
}

foobar2()

while (TRUE) Sys.sleep(1000)
