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
})
