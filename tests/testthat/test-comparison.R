context("comparison")

test_that("basic metadata stored in comparison object", {
  if (l10n_info()$`UTF-8`) {
    cf <- compare_check_files(test_path("REDCapR-ok.log"), test_path("REDCapR-fail.log"))
  } else {
    cf <- compare_check_files(test_path("REDCapR-ok-ascii.log"),
                              test_path("REDCapR-fail-ascii.log"))
  }

  expect_equal(cf$package, "REDCapR")
  expect_equal(cf$versions, c("0.9.8", "0.9.8"))
})

test_that("status correctly computed when both checks are ok", {
  if (l10n_info()$`UTF-8`) {
    cf <- compare_check_files(test_path("minimal-ok.log"), test_path("minimal-ok.log"))
  } else {
    cf <- compare_check_files(test_path("minimal-ok-ascii.log"),
                              test_path("minimal-ok-ascii.log"))
  }
  expect_equal(cf$status, "+")
})

test_that("print message displays informative output", {
  if (l10n_info()$`UTF-8`) {
    cf <- compare_check_files(test_path("minimal-ee.log"), test_path("minimal-ewn.log"))
  } else {
    cf <- compare_check_files(test_path("minimal-ee-ascii.log"),
                              test_path("minimal-ewn-ascii.log"))
  }

  expect_output_file({
    print(summary(cf))
    cat("\n\n")
    print(cf)
  }, file = "comparison-newly-failing-ascii.txt", update = FALSE)

})
