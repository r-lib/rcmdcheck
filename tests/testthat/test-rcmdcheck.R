
context("rcmdcheck")

test_that("rcmdcheck works", {

  Sys.unsetenv("R_TESTS")

  bad1 <- rcmdcheck("bad1", quiet = TRUE)
  expect_match(bad1$warnings[1], "Non-standard license specification")

  expect_output(
    print(bad1),
    "Non-standard license specification"
  )
})

test_that("non-quiet mode works", {

  Sys.unsetenv("R_TESTS")

  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)

  sink(tmp)

  bad1 <- rcmdcheck("bad1", quiet = FALSE)
  expect_match(bad1$warnings[1], "Non-standard license specification")

  expect_output(
    print(bad1),
    "Non-standard license specification"
  )

  sink(NULL)

  out <- read_char(tmp)
  expect_match(out, "Non-standard license specification")
})
