
torture_me <- function(expr) {
  out <- tryCatch(
    withCallingHandlers({
      p <- callr::r_bg(function(pid, num = 1000) {
        Sys.sleep(1)
        for (i in 1:num) {
          ps::ps_interrupt(ps::ps_handle(pid))
          Sys.sleep(0.01)
        }
      }, list(pid = Sys.getpid()))
      expr
    }, interrupt = function(cnd) { cat("int\n") ; invokeRestart("resume") }),
    error = function(err) err
  )
  p$kill()
  out
}

test_that("http interrupts", {
  skip_on_cran()
  if (getRversion() < "3.5.0") skip("Need R 3.5.0 for interrupts")

  withr::local_options(cli.progress_handlers_only = "logger")

  dl <- function() {
    download_files(
      "https://httpbin.org/drip?duration=5&numbytes=1000",
      tmp <- tempfile()
    )
  }

  out <- capture.output(resp <- torture_me(dl()))
  expect_equal(resp[[1]]$status_code, 200)
  expect_true(grepl("created", out[1]))
  expect_true(grepl("done", out[length(out)]))
  expect_true(any(out == "int"))
})
