
sleep_spinner <- function(dt) {
  phases <- c("-", "\\", "|", "-")
  refresh_interval <- as.difftime(0.1, units = "secs")
  at <- 1
  while (dt > 0) {
    cat("\r", phases[at], "\r", sep = "")
    towait <- min(refresh_interval, dt)
    Sys.sleep(towait)
    dt <- dt - towait
    at <- at + 1; if (at > length(phases)) at <- 1
  }
}

make_replay_function <- function(name, sleep = FALSE) {
  file <- file.path("fixtures", paste0(name, ".rds"))
  rec <- readRDS(file)

  start <- rec[[1]][[1]]
  rec <- c(list(list(start, "")), rec)
  nex <- 2

  function() {
    if (nex > length(rec)) {
      NA_character_
    } else {
      out <- rec[[nex]][[2]]
      if (sleep) sleep_spinner(rec[[nex]][[1]] - rec[[nex-1]][[1]])
      nex <<- nex + 1
      out
    }
  }
}

replay <- function(name, sleep = FALSE) {
  f <- make_replay_function(name, sleep)
  cb <- block_callback()
  while (TRUE) {
    outp <- f()
    if (is.na(outp)) break;
    cb(outp)
  }
}

# Wrapper because from edition 3 'class' must be a scalar

expect_error_classes <- function(expr, class) {
  err <- tryCatch(expr, error = function(e) e)
  for (c in class) {
    expect_s3_class(err, c)
  }
}

cran_app <- function() {
  app <- webfakes::new_app()
  app$get(
    list(
      webfakes::new_regexp("/nosvn/R.check/(?<flavour>[-.a-zA-Z0-9_+]+)/(?<name>[-.a-zA-Z0-9_]+)$"),
      webfakes::new_regexp("/web/checks/(?<name>[-.a-zA-Z0-9_+]+)$")
    ),
    function(req, res) {
      flavour <- req$params$flavour %||% ""
      path <- testthat::test_path("fixtures", "checks", flavour, req$params$name)
      if (file.exists(path)) {
        res$send_file(path)
      } else {
        res$send_status(404)
      }
    }
  )

  app
}
