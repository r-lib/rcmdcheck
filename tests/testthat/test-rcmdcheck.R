
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
  expect_equal(length(bad1$notes), 0)
})

test_that("background gives same results", {

  skip_on_cran()
  Sys.unsetenv("R_TESTS")

  bad1 <- rcmdcheck_process$new(test_path("bad1"))
  bad1$wait()
  res <- bad1$parse_results()

  expect_match(res$warnings[1], "Non-standard license specification")
  expect_match(res$description, "Advice on R package building")
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
