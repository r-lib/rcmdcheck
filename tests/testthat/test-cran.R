
context("compare_to_cran")

test_that("can get results (windows)", {
  skip_on_cran()
  xx <- cran_check_results("rcmdcheck", "r-release-windows-ix86+x86_64")
  expect_s3_class(xx[[1]], "rcmdcheck")
})

test_that("can get UTF-8 results", {
  skip_on_cran()
  xx <- cran_check_results("rcmdcheck", "r-devel-linux-x86_64-debian-gcc")
  expect_s3_class(xx[[1]], "rcmdcheck")  
})

test_that("can get ISO-8859-15 results", {
  skip_on_cran()
  xx <- cran_check_results("rcmdcheck", "r-devel-linux-x86_64-debian-clang")
  expect_s3_class(xx[[1]], "rcmdcheck")  
})
