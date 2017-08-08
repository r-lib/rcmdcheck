context("auto_clean")

test_that("auto_clean deletes files on gc()", {
  tmp <- tempfile()
  writeLines("abc", tmp)

  auto_clean(tmp)
  gc()

  expect_false(file.exists(tmp))
})
