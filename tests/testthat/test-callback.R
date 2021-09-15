
test_that("block_callback by line", {
  withr::local_options(rcmdcheck.timestamp_limit = 1000)
  chk <- readLines(test_path("fixtures", "test-error.txt"))
  cb <- block_callback()
  expect_snapshot(
    for (line in chk) cb(paste0(line, "\n"))
  )
})

test_that("block_callback by chunks", {
  withr::local_options(rcmdcheck.timestamp_limit = 1000)
  fx <- test_path("fixtures", "test-error.txt")
  chk <- readChar(fx, file.info(fx)$size, useBytes = TRUE)

  # We don't make this random, so the partial lines are always the same
  # and the snapshot does not change
  pszs <- c(
    1694L, 1751L, 1886L, 1986L, 2476L, 2529L, 2772L, 2832L, 3036L,
    3165L, 3202L, 3389L, 3616L, 3867L, 4304L, 4491L, 4789L, 4818L,
    4993L, 5331L
  )
  szs <- c(1, pszs, nchar(chk) + 1L)
  chunks <- lapply(seq_along(szs)[-1], function(i) {
    substr(chk, szs[i-1], szs[i] - 1L)
  })

  cb <- block_callback()
  expect_snapshot(
    for (ch in chunks) cb(ch)
  )
})

test_that("block_callback shows running time", {
  cb <- block_callback()
  out <- capture.output({
    cb("* Doing something")
    Sys.sleep(1/2)
    cb(" ... OK\n")
  })
  expect_match(out[1], "Doing something [(][0-9]+m?s[)]$")
})

test_that("notes, errors, warnings", {
  withr::local_options(rcmdcheck.timestamp_limit = 1000)
  cb <- block_callback()
  out <- c(
    "* Step one ... NOTE\n   More note text.\n",
    "* Step two ... WARNING\n   More warning text.\n",
    "* Step three ... ERROR\n   More error text.\n"
  )
  expect_snapshot(
    for (line in out) cb(line)
  )
})

test_that("tests", {
  withr::local_options(rcmdcheck.timestamp_limit = 1000)
  txt <- c(
    "* checking for unstated dependencies in 'tests' ... OK",
    "* checking tests ... ERROR",
    "  Running 'testthat.R'",
    "Running the tests in 'tests/testthat.R' failed.",
    "Complete output:",
    "  > library(testthat)",
    "  > library(lpirfs)",
    "  > ",
    "  > test_check(\"lpirfs\")",
    "  Error in parse(con, n = -1, srcfile = srcfile, encoding = \"UTF-8\") : ",
    "    test-diagnost_ols.R:19:8: unexpected $end",
    "  18: ",
    "  19: lm_modeÄ",
    "             ^",
    "  Calls: test_check ... doWithOneRestart -> force -> lapply -> FUN -> source_file -> parse",
    "  Execution halted",
    "* checking for unstated dependencies in vignettes ... OK"
  )

  cb <- block_callback()
  expect_snapshot(
    for (line in txt) cb(paste0(line, "\n"))
  )
})

test_that("multi-arch tests", {
  withr::local_options(rcmdcheck.timestamp_limit = 1000)
  txt <- c(
    "* checking for unstated dependencies in 'tests' ... OK",
    "* checking tests ...",
    "** running tests for arch 'i386' ... [2s] ERROR",
    "  Running 'testthat.R' [2s]",
    "Running the tests in 'tests/testthat.R' failed.",
    "Complete output:",
    "  > library(\"testthat\")",
    "  > library(\"GMSE\")",
    "  > ",
    "  > test_check(\"GMSE\")",
    "** running tests for arch 'x64' ... [3s] OK",
    "  Running 'testthat.R' [2s]",
    "* checking for unstated dependencies in vignettes ... OK"
  )

  cb <- block_callback()
  expect_snapshot(
    for (line in txt) cb(paste0(line, "\n"))
  )
})

test_that("multiple test file run times are measured properly", {
  txt <- list(
    list("* checking examples ... ", 5),
    list("OK\n", 0),
    list("* checking for unstated dependencies in ‘tests’ ... OK\n", 0),
    list("* checking tests ... \n", 0),
    list("  Running ‘first_edition.R’", 13.2),
    list("\n", 0),
    list("  Running ‘second_edition.R’", 14.3),
    list("\n", 0),
    list(" OK\n", 0),
    list("* checking for unstated dependencies in vignettes ... OK\n", 0),
    list("* checking package vignettes in ‘inst/doc’ ... OK\n", 0)
  )

  replay <- function(frames) {
    time <- Sys.time()
    timer <- function() time
    cb <- block_callback(sys_time = timer)
    for (frame in frames) {
      cb(frame[[1]])
      if (frame[[2]] > 0) {
        time <- time + frame[[2]]
      }
    }
  }

  out <- capture.output(replay(txt))
  expect_snapshot(out)
})
