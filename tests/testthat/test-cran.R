
cran <- webfakes::new_app_process(cran_app())
withr::local_envvar(
  RCMDCHECK_BASE_URL = paste0(cran$url(), "web/checks/"),
  RCMDCHECK_FLAVOURS_URL = paste0(cran$url(), "web/checks/check_flavors.html"),
  RCMDCHECK_DETAILS_URL = paste0(cran$url(), "nosvn/R.check/")
)

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

test_that("when package unspecified, cran check flavours are returned", {
  flavours <- cran_check_flavours()

  expect_true(all(grepl("r-devel|r-patched|r-release|r-oldrel", flavours)))
})
