
context("throwing errors")

test_that("error is thrown as needed, with the correct type", {

  cle1 <- list()
  
  err1 <- list(errors = 1)
  err2 <- list(errors = 1, warnings = 1)
  err3 <- list(errors = 1, warnings = 2, notes = 3)

  wrn1 <- list(warnings = 1)
  wrn2 <- list(warnings = 1, notes = 2)

  nte1 <- list(notes = 1)

  expect_silent(handle_error_on(cle1, "note"))
  expect_silent(handle_error_on(cle1, "warning"))
  expect_silent(handle_error_on(cle1, "error"))

  expect_error(capture_output(handle_error_on(err1, "note")),
               class = c("rcmdcheck_error", "rcmdcheck_failure"))
  expect_error(capture_output(handle_error_on(err1, "warning")),
               class = c("rcmdcheck_error", "rcmdcheck_failure"))
  expect_error(capture_output(handle_error_on(err1, "error")),
               class = c("rcmdcheck_error", "rcmdcheck_failure"))
  expect_error(capture_output(handle_error_on(err2, "note")),
               class = c("rcmdcheck_error", "rcmdcheck_warning"))
  expect_error(capture_output(handle_error_on(err2, "warning")),
               class = c("rcmdcheck_error", "rcmdcheck_warning"))
  expect_error(capture_output(handle_error_on(err2, "error")),
               class = c("rcmdcheck_error", "rcmdcheck_warning"))
  expect_error(capture_output(handle_error_on(err3, "note")),
               class = c("rcmdcheck_error", "rcmdcheck_warning",
                 "rcmdcheck_note"))
  expect_error(capture_output(handle_error_on(err3, "warning")),
               class = c("rcmdcheck_error", "rcmdcheck_warning",
                 "rcmdcheck_note"))
  expect_error(capture_output(handle_error_on(err3, "error")),
               class = c("rcmdcheck_error", "rcmdcheck_warning",
                 "rcmdcheck_note"))

  expect_error(capture_output(handle_error_on(wrn1, "note")),
               class = "rcmdcheck_warning")
  expect_error(capture_output(handle_error_on(wrn1, "warning")),
               class = "rcmdcheck_warning")
  expect_silent(handle_error_on(wrn1, "error"))
  expect_error(capture_output(handle_error_on(wrn2, "note")),
               class = c("rcmdcheck_warning", "rcmdcheck_note"))
  expect_error(capture_output(handle_error_on(wrn2, "warning")),
               class = c("rcmdcheck_warning", "rcmdcheck_note"))
  expect_silent(handle_error_on(wrn2, "error"))

  expect_error(capture_output(handle_error_on(nte1, "note")),
               class = "rcmdcheck_note")
  expect_silent(handle_error_on(nte1, "warning"))
  expect_silent(handle_error_on(nte1, "error"))
})
