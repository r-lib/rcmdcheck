
test_that("load_env", {
  path_ <- NULL
  mockery::stub(
    load_env,
    "load_env_file",
    function(path, envir) path_ <<- path
  )

  withr::local_envvar(RCMDCHECK_LOAD_CHECK_ENV = "false", NOT_CRAN = "true")
  load_env("foo", "bar", "package")
  expect_null(path_)

  withr::local_envvar(RCMDCHECK_LOAD_CHECK_ENV = NA, NOT_CRAN = NA)
  load_env("foo", "bar", "package")
  expect_null(path_)

  tmp <- tempfile()
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
  envfile <- file.path(tmp, "pkg", "tools", "check.env")
  dir.create(dirname(envfile), recursive = TRUE, showWarnings = FALSE)
  cat("foo=bar\n#comment\n\nbar=foobar\n", file = envfile)

  withr::local_envvar(RCMDCHECK_LOAD_CHECK_ENV = "true", NOT_CRAN = NA)
  load_env(file.path(tmp, "pkg"))
  expect_true(file.exists(path_))
  path_ <- NULL

  withr::local_envvar(RCMDCHECK_LOAD_CHECK_ENV = NA, NOT_CRAN = "true")
  load_env(file.path(tmp, "pkg"))
  expect_true(file.exists(path_))
  path_ <- NULL

  tarfile <- tempfile(fileext = ".tar.gz")
  withr::with_dir(
    tmp,
    tar(tarfile, "pkg", tar = "internal")
  )

  load_env(tarfile, tarfile, "pkg")
  expect_false(is.null(path_))
  path_ <- NULL
})

test_that("load_env_file", {
  envfile <- tempfile()
  on.exit(unlink(envfile, recursive = TRUE), add = TRUE)
  cat("foo=bar\n#comment\n\nbar=foobar\n", file = envfile)

  withr::local_envvar(foo = "notbar", bar = NA)
  do <- function() {
    load_env_file(envfile)
    expect_equal(Sys.getenv("foo"), "bar")
    expect_equal(Sys.getenv("bar"), "foobar")
  }

  do()

  expect_equal(Sys.getenv("foo"), "notbar")
  expect_equal(Sys.getenv("bar", ""), "")
})

test_that("load_env_file error", {
  envfile <- tempfile()
  on.exit(unlink(envfile, recursive = TRUE), add = TRUE)
  cat("foo=bar\n#comment\n\nbarfoobar\n", file = envfile)

  withr::local_envvar(foo = "notbar", bar = NA)
  do <- function() {
    load_env_file(envfile)
  }

  expect_error(do(), "Cannot parse check.env")

  expect_equal(Sys.getenv("foo"), "notbar")
  expect_equal(Sys.getenv("bar", ""), "")
})
