context("comparison")

test_that("basic metadata stored in comparison object", {
  cf <- compare_check_files(test_path("REDCapR-ok.log"), test_path("REDCapR-fail.log"))

  expect_equal(cf$package, "REDCapR")
  expect_equal(cf$versions, c("0.9.8", "0.9.8"))
})
