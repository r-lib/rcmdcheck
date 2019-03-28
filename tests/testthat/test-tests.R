
context("tests")

test_that("parsing tests for multiple architectures", {

  tgz <- test_path("fixtures", "bad-tests.tar.gz")
  dir.create(tmp <- tempfile())
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  file.copy(tgz, tmp)
  withr::local_dir(tmp)
  untar(basename(tgz), tar = "internal")

  chk <- parse_check("ps.Rcheck")
  expect_equal(length(chk$test_fail), 2)
  expect_equal(names(chk$test_fail),
               c("testthat (i386)", "testthat (x64)"))
})
