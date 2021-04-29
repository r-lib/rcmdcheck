
test_that("can parse basic package information from file", {
  skip_on_cran()
  outfile <- "bikedata-ok.log"
  check <- parse_check(test_path(outfile))

  expect_equal(check$package, "bikedata")
  expect_equal(check$version, "0.0.3")
  expect_equal(check$rversion, "3.4.1")
})

cli::test_that_cli("install log is captured", {
  skip_on_cran()
  outfile <- "RSQLServer-install"
  path <- test_path(outfile)
  check <- parse_check(path)

  expect_match(check$install_out, "unable to load shared object")

  expect_snapshot(
    print(check)
  )
})

cli::test_that_cli("test failures are captured", {
  skip_on_cran()
  outfile <- "dataonderivatives-test"
  path <- test_path(outfile)
  check <- parse_check(path)

  expect_named(check$test_fail, "testthat")
  expect_match(check$test_fail[[1]], "BSDR API accesible")

  expect_snapshot(
    print(check)
  )
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
