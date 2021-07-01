
return()

test_that("http interrupts", {
  message("start")
  err <- tryCatch(
    withCallingHandlers(
      download_files(
        "https://httpbin.org/drip?duration=10&numbytes=1000",
        tmp <- tempfile()
      ),
      interrupt = function(cnd) { message("resume"); invokeRestart("resume") }
    ),
    error = function(err) err
  )

  print(err)
})
