
context("rcmdcheck")

test_that("rcmdcheck works", {

  bad1 <- rcmdcheck("bad1")
  expect_match(bad1$warnings[1], "Non-standard license specification")

})
