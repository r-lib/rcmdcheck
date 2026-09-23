test_that("show_env_vars", {
  # Unset any env vars that would otherwise leak in from the check env
  current <- names(Sys.getenv())
  leaked <- current[grepl("_R_CHECK|NOT_CRAN|RCMDCHECK|R_TESTS", current)]
  unset <- stats::setNames(rep(NA_character_, length(leaked)), leaked)

  withr::local_envvar(c(
    unset,
    NOT_CRAN = "true",
    X = "true",
    Y = "false",
    `_R_CHECK_CRAN_INCOMING_` = "false"
  ))

  expect_snapshot(show_env_vars())
})
