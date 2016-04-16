library(testthat)
library(rcmdcheck)

if (Sys.getenv("NOT_CRAN") != "") {
  test_check("rcmdcheck")
}
