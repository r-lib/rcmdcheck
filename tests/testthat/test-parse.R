context("parse")

test_that("can parse basic package information from file", {
  check <- parse_check(test_path("bikedata-ok.log"))

  expect_equal(check$package, "bikedata")
  expect_equal(check$version, "0.0.3")
  expect_equal(check$rversion, "3.4.1")
})

test_that("install log is captured", {
  path <- test_path("RSQLServer-install")
  check <- parse_check(path, checkdir = path)

  expect_equal(check$checkdir, path)
  expect_match(check$install_out, "unable to load shared object")

  expect_output_file(print(check), file = "parse-install-fail.txt", update = TRUE)
})

test_that("test failures are captured", {
  path <- test_path("dataonderivatives-test")
  check <- parse_check(path, checkdir = path)

  expect_named(check$test_fail, "testthat")
  expect_match(check$test_fail[[1]], "BSDR API accesible")

  expect_output_file(print(check), file = "parse-test-fail.txt", update = TRUE)

})

# data frame coercion -----------------------------------------------------

test_that("can coerce to data frame", {
  check <- parse_check(test_path("REDCapR-fail.log"))
  df <- as.data.frame(check, which = "new")

  expect_equal(nrow(df), 1)
  expect_equal(df$type, "error")
})

test_that("successful check yields zero rows", {
  check <- parse_check(test_path("bikedata-ok.log"))
  df <- as.data.frame(check, which = "new")

  expect_equal(nrow(df), 0)
})
