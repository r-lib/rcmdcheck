
context("rcmdcheck")

test_that("rcmdcheck works", {

  Sys.unsetenv("R_TESTS")

  bad1 <- rcmdcheck(test_path("bad1"), quiet = TRUE)
  expect_match(bad1$warnings[1], "Non-standard license specification")

  expect_output(
    print(bad1),
    "Non-standard license specification"
  )

  expect_equal(length(bad1$errors), 0)
  expect_equal(length(bad1$warnings), 1)
  expect_equal(length(bad1$notes), 1)

  expect_true(bad1$cran)
  expect_false(bad1$bioc)

  ## This currently fails with devtools::check(), so it also fails
  ## on Travis
  skip_on_travis()
  expect_s3_class(bad1$session_info[[1]], "sessionInfo")
})

test_that("background gives same results", {

  skip_on_cran()
  Sys.unsetenv("R_TESTS")

  bad1 <- rcmdcheck_process$new(test_path("bad1"))
  bad1$wait()
  res <- bad1$parse_results()

  expect_match(res$warnings[1], "Non-standard license specification")
  expect_match(res$description, "Advice on R package building")

  ## This currently fails with devtools::check(), so it also fails
  ## on Travis
  skip_on_travis()
  expect_s3_class(res$session_info[[1]], "sessionInfo")
})

test_that("Installation errors", {

  bad2 <- rcmdcheck(test_path("bad2"), quiet = TRUE)
  expect_match(bad2$errors[1], "Installation failed")

  expect_output(
    print(bad2),
    "installing .source. package"
  )

  expect_equal(length(bad2$errors), 1)
  expect_equal(length(bad2$warnings), 0)
  expect_equal(length(bad2$notes), 0)

  expect_false(bad2$cran)
  expect_true(bad2$bioc)
})

test_that("non-quiet mode works", {

  Sys.unsetenv("R_TESTS")

  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)

  sink(tmp)

  bad1 <- rcmdcheck(test_path("bad1"), quiet = FALSE)
  expect_match(bad1$warnings[1], "Non-standard license specification")

  expect_output(
    print(bad1),
    "Non-standard license specification"
  )

  sink(NULL)

  out <- read_char(tmp)
  expect_match(out, "Non-standard license specification")
})

test_that("build arguments", {

  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)

  sink(tmp)

  o1 <- expect_error(
    rcmdcheck(test_path("bad1"), build_args = "-v")
  )

  sink(NULL)

  out <- read_char(tmp)
  expect_match(out, "R add-on package builder")
})

test_that("check arguments", {

  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)

  sink(tmp)

  rcmdcheck(test_path("fixtures/badpackage_1.0.0.tar.gz"), args = "-v")

  sink(NULL)

  out <- read_char(tmp)
  expect_match(out, "R add-on package check")
})
