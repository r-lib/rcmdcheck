
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

test_that("protection against ~ deletion", {
  local_mocked_bindings(dir = function(...) c("foo", "~", "bar"))
  expect_error(
    check_for_tilde_file(tempfile()),
    "delete your entire home directory"
  )
})

test_that("inst/doc can be kept", {
  bad3 <- test_path("bad3")
  rubbish <- test_path("bad3", "inst", "doc", "rubbish")
  on.exit(unlink(test_path("bad3", "inst"), recursive = TRUE), add = TRUE)
  dir.create(dirname(rubbish), showWarnings = FALSE, recursive = TRUE)
  cat("DELETE ME!\n", file = rubbish)
  pkg <- build_package(bad3, tempfile(), character(), .libPaths(), TRUE)
  expect_true(file.exists(rubbish))
})
