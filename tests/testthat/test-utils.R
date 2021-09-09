
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
