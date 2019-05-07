
context("rcmdcheck")

test_that("rcmdcheck works", {

  skip_on_cran()
  Sys.unsetenv("R_TESTS")

  ## This is to test passing libpath to R CMD check subprocesses
  ## In the bad1 package, there is an example that reads out
  ## RCMDCHECK_OUTPUT, and write the .libPaths() there.

  dir.create(tmp_lib <- tempfile())
  tmp_lib <- normalizePath(tmp_lib)
  tmp_out1 <- tempfile(fileext = ".rda")
  tmp_out2 <- tempfile(fileext = ".rda")
  Sys.setenv(RCMDCHECK_OUTPUT = tmp_out1)
  Sys.setenv(RCMDBUILD_OUTPUT = tmp_out2)
  on.exit(unlink(c(tmp_lib, tmp_out1, tmp_out2), recursive = TRUE),
          add = TRUE)
  on.exit(Sys.unsetenv("RCMDCHECK_OUTPUT"), add = TRUE)
  on.exit(Sys.unsetenv("RCMDBUILD_OUTPUT"), add = TRUE)

  bad1 <- rcmdcheck(
    test_path("bad1"),
    quiet = TRUE,
    libpath = c(tmp_lib, .libPaths()))

  expect_match(bad1$warnings[1], "Non-standard license specification")

  expect_output(
    print(bad1),
    "Non-standard license specification"
  )

  ## This fails without LaTex, which is not available on Appveyor
  if (!identical(Sys.getenv("APPVEYOR"), "True")) {
    expect_equal(length(bad1$errors), 0)
  }
  expect_true(length(bad1$warnings) >= 1)
  expect_equal(length(bad1$notes), 0)

  expect_true(bad1$cran)
  expect_false(bad1$bioc)

  ## Check that libpath was passed to R CMD check subprocesses
  expect_true(file.exists(tmp_out1))
  lp1 <- readRDS(tmp_out1)
  expect_true(tmp_lib %in% normalizePath(lp1, mustWork = FALSE))

  expect_true(file.exists(tmp_out2))
  lp2 <- readRDS(tmp_out2)
  expect_true(tmp_lib %in% normalizePath(lp2, mustWork = FALSE))

  ## This currently fails with devtools::check(), so it also fails
  ## on Travis
  skip_on_travis()
  expect_s3_class(bad1$session_info, "session_info")
})

test_that("background gives same results", {

  skip_on_cran()
  Sys.unsetenv("R_TESTS")

  ## This is to test passing libpath to R CMD check subprocesses
  ## In the bad1 package, there is an example that reads out
  ## RCMDCHECK_OUTPUT, and write the .libPaths() there.

  dir.create(tmp_lib <- tempfile())
  tmp_lib <- normalizePath(tmp_lib)
  tmp_out1 <- tempfile(fileext = ".rda")
  tmp_out2 <- tempfile(fileext = ".rda")
  Sys.setenv(RCMDCHECK_OUTPUT = tmp_out1)
  Sys.setenv(RCMDBUILD_OUTPUT = tmp_out2)
  on.exit(unlink(c(tmp_lib, tmp_out1, tmp_out2), recursive = TRUE),
          add = TRUE)
  on.exit(Sys.unsetenv("RCMDCHECK_OUTPUT"), add = TRUE)
  on.exit(Sys.unsetenv("RCMDBUILD_OUTPUT"), add = TRUE)

  bad1 <- rcmdcheck_process$new(
     test_path("bad1"),
     libpath = c(tmp_lib, .libPaths()))
  bad1$read_all_output_lines()
  res <- bad1$parse_results()

  expect_match(res$warnings[1], "Non-standard license specification")
  expect_match(res$description, "Advice on R package building")

  ## Check that libpath was passed to R CMD check subprocesses
  expect_true(file.exists(tmp_out1))
  lp1 <- readRDS(tmp_out1)
  expect_true(tmp_lib %in% normalizePath(lp1, mustWork = FALSE))

  expect_true(file.exists(tmp_out2))
  lp2 <- readRDS(tmp_out2)
  expect_true(tmp_lib %in% normalizePath(lp2, mustWork = FALSE))

  ## This currently fails with devtools::check(), so it also fails
  ## on Travis
  skip_on_travis()
  expect_s3_class(res$session_info, "session_info")
})

test_that("Installation errors", {

  skip_on_cran()
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

  skip_on_cran()
  Sys.unsetenv("R_TESTS")

  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)

  out <- capture_output({
    bad1 <- rcmdcheck(test_path("bad1"), quiet = FALSE)
    expect_match(bad1$warnings[1], "Non-standard license specification")
  })

  expect_output(
    print(bad1),
    "Non-standard license specification"
  )

  expect_match(out, "Non-standard license specification")
})

test_that("build arguments", {

  skip_on_cran()
  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)

  out <- capture_output(
    o1 <- expect_error(
      rcmdcheck(test_path("bad1"), build_args = "-v")
    )
  )
  expect_match(out, "R add-on package builder")
})

test_that("check arguments", {

  skip_on_cran()
  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)

  out <- capture_output(
    rcmdcheck(test_path("fixtures/badpackage_1.0.0.tar.gz"), args = "-v")
  )

  expect_match(out, "R add-on package check")
})

test_that("check_dir argument", {
  wd <- NULL
  mockery::stub(rcmdcheck, "do_check", function(...) {
    wd <<- getwd()
    stop("enough")
  })
  tmp <- tempfile(pattern = "foo bar")
  on.exit(unlink(tmp))
  expect_error(rcmdcheck(test_path("fixtures/badpackage_1.0.0.tar.gz"),
                         check_dir = tmp))

  expect_true(file.exists(tmp))
  expect_equal(normalizePath(wd), normalizePath(tmp))
})

test_that("check_dir and rcmdcheck_process", {
  skip_on_cran()
  tmp <- tempfile(pattern = "foo bar")
  on.exit(unlink(tmp))
  px <- rcmdcheck_process$new(test_path("fixtures/badpackage_1.0.0.tar.gz"),
                              check_dir = tmp)
  on.exit(px$kill(), add = TRUE)
  expect_true(file.exists(tmp))
  expect_true("badpackage_1.0.0.tar.gz" %in% dir(tmp))
})
