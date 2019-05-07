context("parse")

test_that("can parse basic package information from file", {
  skip_on_cran()
  outfile <- "bikedata-ok.log"
  check <- parse_check(test_path(outfile))

  expect_equal(check$package, "bikedata")
  expect_equal(check$version, "0.0.3")
  expect_equal(check$rversion, "3.4.1")
})

test_that("install log is captured", {
  skip_on_cran()
  outfile <- "RSQLServer-install"
  known <- "parse-install-fail.txt"
  path <- test_path(outfile)
  check <- parse_check(path)

  expect_match(check$install_out, "unable to load shared object")

  expect_output_file(
    withr::with_options(list(cli.unicode = TRUE), print(check)),
    file = known, update = FALSE)
})

test_that("test failures are captured", {
  skip_on_cran()
  outfile <- "dataonderivatives-test"
  known <- "parse-test-fail.txt"
  path <- test_path(outfile)
  check <- parse_check(path)

  expect_named(check$test_fail, "testthat")
  expect_match(check$test_fail[[1]], "BSDR API accesible")

  expect_output_file(
    withr::with_options(list(cli.unicode = TRUE), print(check)),
    file = known, update = FALSE)
})

test_that("test failure, ERROR in new line", {
  skip_on_cran()
  outfile <- "fixtures/test-error.txt"
  check <- parse_check(test_path(outfile))
  expect_equal(length(check$errors), 1)
  expect_equal(length(check$warnings), 0)
  expect_equal(length(check$notes), 3)
})

# data frame coercion -----------------------------------------------------

test_that("can coerce to data frame", {
  skip_on_cran()
  outfile <- "REDCapR-fail.log"
  check <- parse_check(test_path(outfile))
  df <- as.data.frame(check, which = "new")

  expect_equal(nrow(df), 1)
  expect_equal(df$type, "error")
})

test_that("successful check yields zero rows", {
  skip_on_cran()
  outfile <- "bikedata-ok.log"
  check <- parse_check(test_path(outfile))
  df <- as.data.frame(check, which = "new")

  expect_equal(nrow(df), 0)
})
