
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

  out <- capture.output(replay(txt))
  expect_snapshot(out)
})

test_that("multi-arch test cases", {
  txt <- list(
    list("* using log directory 'C:/Users/csard/works/ps.Rcheck'\n", 0.01), 
    list("* using R version 4.1.1 (2021-08-10)\n", 0.01),
    list("* using platform: x86_64-w64-mingw32 (64-bit)\n", 0.01),
    list("* using session charset: ISO8859-1\n", 0.01),
    list("* checking for file 'ps/DESCRIPTION' ... OK\n", 0.01),
    list("* this is package 'ps' version '1.3.2.9000'\n", 0.01),
    list("* checking for unstated dependencies in 'tests' ... OK\n", 0.01),
    list("* checking tests ...\n", 0.01),
    list("** running tests for arch 'i386' ...\n", 0.01),
    list("  Running 'testthat.R'\n", 0.01),
    list(" OK\n", 0.01),
    list("** running tests for arch 'x64' ...\n", 0.01),
    list("  Running 'testthat.R'\n", 0.01),
    list(" OK\n", 0.01),
    list("* checking PDF version of manual ... OK\n", 0.01),
    list("* DONE\n", 0.01)
  )

  out <- capture.output(replay(txt))
  expect_snapshot(out)
})

test_that("failed test case", {
  txt <- readLines(test_path("fixtures", "checks", "test-error.txt"))[54:76]
  lines <- lapply(txt, function(x) list(paste0(x, "\n"), 0.001))
  out <- capture.output(replay(lines))
  expect_snapshot(out)
})

test_that("comparing test output", {
  txt <- readLines(test_path("fixtures", "checks", "comparing.txt"))[52:63]
  lines <- lapply(txt, function(x) list(paste0(x, "\n"), 0.001))
  out <- capture.output(replay(lines))
  expect_snapshot(out)
})

test_that("partial comparing line", {
  lines <- list(
    list("* checking tests ...\n", 0),
    list("  Running ‘test-1.R’\n", 0),
    list("  Comparing ‘test-1.Rout’ to ", 0),
    list("‘test-1.Rout.save’ ... OK\n", 0),
    list("  Running ‘test-2.R’\n", 0),
    list("  Comparing ‘test-2.Rout’ to ‘test-2.Rout.save’ ... OK\n", 0),
    list(" OK\n", 0.01),
    list("* checking PDF version of manual ... OK\n", 0.01),
    list("* DONE\n", 0.01)    
  )

  out <- capture.output(replay(lines))
  expect_snapshot(out)
})

test_that("multiple comparing blocks", {
  txt <- readLines(test_path("fixtures", "checks", "comparing2.txt"))[53:88]
  lines <- lapply(txt, function(x) list(paste0(x, "\n"), 0.001))
  out <- capture.output(replay(lines))
  expect_snapshot(out)  
})

test_that("simple_callback", {
  txt <- readLines(test_path("fixtures", "checks", "comparing.txt"))
  lines <- lapply(txt, function(x) list(paste0(x, "\n"), 0.001))
  out <- capture.output(replay(lines, simple_callback))
  expect_snapshot(out)
})

test_that("detect_callback", {
  mockery::stub(detect_callback, "block_callback", "block")
  mockery::stub(detect_callback, "simple_callback", "simple")

  withr::local_options(cli.dynamic = TRUE)
  expect_equal(detect_callback(), "block")
  
  withr::local_options(cli.dynamic = FALSE)
  expect_equal(detect_callback(), "simple")
})

test_that("should_add_spinner", {
  withr::local_options(cli.dynamic = TRUE)
  expect_true(should_add_spinner())
  withr::local_options(cli.dynamic = FALSE)
  expect_false(should_add_spinner())
})
