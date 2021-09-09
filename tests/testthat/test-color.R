
test_that("colors can be turned on and off", {
  # clean up state
  withr::local_options(rcmdcheck.num_colors = NULL)
  withr::local_envvar(RCMDCHECK_NUM_COLORS = NA_character_)

  # by default let cli decide
  withr:::local_options(cli.num_colors = 100)
  expect_equal(rcmdcheck_color(cli::num_ansi_colors)(), 100)

  # env var overrides
  withr::local_envvar(RCMDCHECK_NUM_COLORS = 200)
  expect_equal(rcmdcheck_color(cli::num_ansi_colors)(), 200)

  # option overrides that
  withr::local_options(rcmdcheck.num_colors = 300)
  expect_equal(rcmdcheck_color(cli::num_ansi_colors)(), 300)
})
