
context("build")

test_that("input targz and targz to check can be the same", {
  f1 <- tempfile()
  on.exit(unlink(f1), add = TRUE)
  cat("foobar\n", file = f1)
  res <- build_package(f1, tempdir())
  expect_equal(normalizePath(res), normalizePath(f1))
  expect_equal(readLines(res), "foobar")
})

test_that("different packages in the same dir are fine", {

  dir.create(tmp <- tempfile())
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  f1 <- tempfile(tmpdir = tmp)
  on.exit(unlink(f1), add = TRUE)
  cat("foobar\n", file = f1)

  f2 <- tempfile()
  on.exit(unlink(f2), add = TRUE)
  cat("baz\n", file = f2)

  res <- build_package(f2, tmp)
  expect_false(res == f2)
  expect_equal(readLines(res), "baz")
  expect_equal(readLines(f1), "foobar")
})
