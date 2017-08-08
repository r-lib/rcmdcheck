context("comparison")

test_that("basic metadata stored in comparison object", {
  cf <- compare_check_files(test_path("REDCapR-ok.log"), test_path("REDCapR-fail.log"))

  expect_equal(cf$package, "REDCapR")
  expect_equal(cf$versions, c("0.9.8", "0.9.8"))
})

test_that("print message displays informative output", {
  cf <- compare_check_files(test_path("minimal-ee.log"), test_path("minimal-ewn.log"))

  expect_output_file({
    print(summary(cf))
    cat("\n\n")
    print(cf)
  }, file = "comparison-newly-failing.txt", update = TRUE)

})
