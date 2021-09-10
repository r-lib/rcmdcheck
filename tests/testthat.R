library(testthat)
library(rcmdcheck)

test_check("rcmdcheck", reporter = "summary")
