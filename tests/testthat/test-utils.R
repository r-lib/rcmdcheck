
test_that("as_flag", {
  expect_true(as_flag("true"))
  expect_true(as_flag("TRUE"))
  expect_true(as_flag(TRUE))
  expect_true(as_flag(1))
  expect_true(as_flag(NA, TRUE))

  expect_false(as_flag("false"))
  expect_false(as_flag("FALSE"))
  expect_false(as_flag(FALSE))
  expect_false(as_flag(0))
  expect_false(as_flag(NA, FALSE))

  expect_warning(
    expect_false(as_flag("boo", FALSE)),
    "Invalid"
  )
  expect_warning(
    expect_true(as_flag("boo", TRUE)),
    "Invalid"
  )

  expect_snapshot(
    as_flag("boo", FALSE)
  )
  expect_snapshot(
    as_flag("boo", TRUE, "thisthat")
  )
})

test_that("should_use_rs_pandoc", {
  withr::local_envvar(RCMDCHECK_USE_RSTUDIO_PANDOC = "false")
  expect_false(should_use_rs_pandoc())
  
  withr::local_envvar(RCMDCHECK_USE_RSTUDIO_PANDOC = "true")
  expect_true(should_use_rs_pandoc())

  withr::local_envvar(RCMDCHECK_USE_RSTUDIO_PANDOC = NA_character_)
  mockery::stub(should_use_rs_pandoc, "Sys.which", "")
  withr::local_envvar(RSTUDIO_PANDOC = "yes")
  expect_true(should_use_rs_pandoc())

  withr::local_envvar(RSTUDIO_PANDOC = NA_character_)
  expect_false(should_use_rs_pandoc())

  mockery::stub(should_use_rs_pandoc, "Sys.which", "pandoc")
  withr::local_envvar(RSTUDIO_PANDOC = "yes")
  expect_false(should_use_rs_pandoc())
})
