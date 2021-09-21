
## This is the callback called for each line of the output
## We color it a bit, OK is green, NOTE is blue
## WARNING is magenta, ERROR is red.

#' @importFrom cli symbol
#' @importFrom utils head tail
#' @importFrom prettyunits pretty_dt

block_callback <- function(
    top_line = TRUE,
    sys_time = NULL,
    as_cran = NA) {

  sys_time <- sys_time %||% Sys.time
  partial_line <- ""

  state <- "OK"
  test_running <- FALSE
  should_time <- FALSE
  line_started <- sys_time()
  now <- NULL
  prev_line <- ""

  no <- function(x, what = "") {
    pattern <- paste0(" \\.\\.\\.[ ]?", what, "$")
    sub("^\\*+ ", "", sub(pattern, "", x))
  }

  time_if_long <- function() {
    limit <- as.numeric(getOption(
      "rcmdcheck.timestamp_limit",
      Sys.getenv("RCMDCHECK_TIMESTAMP_LIMIT", "0.33333")
    ))
    elapsed <- now - line_started
    line_started <<- now
    if (elapsed > as.difftime(limit, units = "secs")) {
      style(timing = paste0(" (", pretty_dt(elapsed), ")"))
    } else {
      ""
    }
  }

  do_line <- function(x) {

    should_time <<- FALSE
    now <<- sys_time()

    ## Test mode is special. It will change the 'state' back to 'OK',
    ## once it is done.
    xx <- if (state == "tests") {
      do_test_mode(x)
    } else if (is_new_check(x)) {
      do_new_check(x)
    } else if (grepl("^Status: ", x)) {
      ## We just skip the status, it is printed out anyway, as the return
      ## value
      NA_character_
    } else {
      do_continuation(x)
    }

    prev_line <<- x

    ## NA_character_ can omit output
    if (is.na(xx)) return()

    if (should_time) xx <- style(xx, timing = time_if_long())

    line_started <<- now

    cat(xx, "\n", sep = "")
    flush(stdout())
  }

  do_new_check <- function(x) {
    should_time <<- TRUE
    if (grepl(" \\.\\.\\. OK\\s*$", x)) {
      state <<- "OK"
      style(ok = symbol$tick, "  ", pale = no(x, "OK"))
    } else if (grepl(" \\.\\.\\. NOTE\\s*$", x)) {
      state <<- "NOTE"
      style(note = c("N  ", no(x, "NOTE")))
    } else if (grepl(" \\.\\.\\. WARNING\\s*$", x)) {
      state <<- "WARNING"
      style(warn = c("W  ", no(x, "WARNING")))
    } else if (grepl(" \\.\\.\\.\\s*(\\[[0-9ms]+\\])?\\s*ERROR\\s*$", x)) {
      state <<- "ERROR"
      style(err = c("E  ", no(x, "ERROR")))
    } else if (grepl("^\\* checking tests \\.\\.\\.[ ]?$", x)) {
      state <<- "tests"
      style(pale = c(symbol$line, "  ", no(x)))
    } else if (grepl("^\\*\\* running tests", x)) {
      state <<- "tests"
      test_running <<- FALSE
      style(pale = c(symbol$line, symbol$line, " ", no(x), "      "))
    } else if (grepl("^\\* DONE\\s*$", x)) {
      state <<- "OK"
      NA_character_
    } else {
      style(pale = c(symbol$line, "  ", no(x)))
    }
  }

  do_test_mode <- function(x) {
    ## Maybe we just learned the result of the current test file
    if (test_running) {
      if (grepl("^\\s+OK", x)) {
        ## Tests are over, success
        state <<- "OK"
        test_running <<- FALSE
        xx <- style(ok = symbol$tick, pale = no(prev_line))
        xx <- style(xx, timing = time_if_long())
      } else if (grepl("^\\s+ERROR", x)) {
        ## Tests are over, error
        state <<- "ERROR"
        test_running <<- FALSE
        if (isTRUE(as_cran)) {
          xp <- style(pale = symbol$line, pale = no(prev_line))
          xp <- style(xp, timing = time_if_long())
          cat(xp, "\n", sep = "")
          xx <- style(err = "E", pale = "  Some test files failed")
        } else {
          xx <- style(err = "E", pale = no(prev_line))
        }
        xx <- style(xx, timing = time_if_long())
      } else if (grepl("^\\s+Comparing", x)) {
        ## Comparison
        test_running <<- FALSE
        xx <- style(ok = symbol$tick, pale = no(prev_line))
        xx <- style(xx, timing = time_if_long())
      } else if (grepl("^\\s+Running", x)) {
        ## Next test is running now, state unchanged
        if (isTRUE(as_cran)) {
          xx <- style(pale = symbol$line, pale = no(prev_line))
        } else {
          xx <- style(ok = symbol$tick, pale = no(prev_line))
        }
        xx <- style(xx, timing = time_if_long())
        now <<- sys_time()
      } else {
        ## Should not happen?
        xx <- NA_character_
      }
      if (!is.na(xx)) {
        cat(xx, "\n", sep = "")
        flush(stdout())
      }
    }

    ## Now focus on the current line, if we are still testing
    if (state != "tests") return(NA_character_)
    if (grepl("^\\s+Comparing.*OK$", x)) {
      ## Comparison, success
      style(ok = symbol$tick, pale = no(x, "OK"))
    } else if (grepl("^\\s+Comparing", x)) {
      ## Comparison, failed
      tr <- sub("^.*\\.\\.\\.(.*)$", "\\1", x, perl = TRUE)
      xx <- style(pale = c("X", no(x, ".*")))
      cat(xx, "\n", sep = "")
      paste0("   ", tr)
    } else if (grepl("^\\s+Running", x)) {
      now <<- sys_time()
      test_running <<- TRUE
      NA_character_
    } else if (grepl("^\\s+OK", x)) {
      state <<- "OK"
      test_running <<- FALSE
      NA_character_
    } else if (grepl("^\\s(\\[[0-9/ms]+\\]+)?\\s*ERROR", x)) {
      state <<- "ERROR"
      test_running <<- FALSE
      NA_character_
    } else if (grepl("^\\*\\* running tests", x)) {
      test_running <<- FALSE
      style(pale = c(symbol$line, symbol$line, " ", no(x), "      "))
    } else {
      paste0("   ", x)
    }
  }

  do_test_partial_line <- function(x) {
    if (test_running) {
      if (grepl("^\\s+Running ", x) || grepl("^\\s+Comparing", x)) {
        test_running <<- FALSE
        if (grepl("^\\s+Running ", x)) {
          if (isTRUE(as_cran)) {
            xx <- style(pale = symbol$line, pale = no(prev_line))
          } else {
            xx <- style(ok = symbol$tick, pale = no(prev_line))
          }
          xx <- style(xx, timing = time_if_long())
        } else {
          xx <- style(ok = symbol$tick, pale = prev_line)
        }
        cat(xx, "\n", sep = "")
        flush(stdout())
      }
    }
  }

  do_continuation <- function(x) {
    paste0("   ", x)
  }

  function(x) {
    x <- paste0(partial_line, x)
    partial_line <<- ""
    lines <- strsplit(x, "\r?\n")[[1]]
    if (last_char(x) != "\n") {
      partial_line <<- tail(lines, 1)
      lines <- head(lines, -1)
    }
    cat("  \r")
    lapply(lines, do_line)
    if (state == "tests") do_test_partial_line(partial_line)
    cat0(sub("^[\\* ]\\*?", "  ", partial_line), "\r")
  }
}

is_new_check <- function(x) {
  grepl("^\\*\\*? ", x)
}

simple_callback <- function(top_line = TRUE, sys_time = NULL, ...) {
  function(x) cat(gsub("[\r\n]+", "\n", x, useBytes = TRUE))
}

#' @importFrom cli is_dynamic_tty

detect_callback <- function(...) {
  if (cli::is_dynamic_tty()) block_callback(...) else simple_callback(...)
}

should_add_spinner <- function() {
  is_dynamic_tty()
}
