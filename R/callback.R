
## This is the callback called for each line of the output
## We color it a bit, OK is green, NOTE is orange,
## WARNING and ERROR are red.

#' @importFrom clisymbols symbol
#' @importFrom utils head tail
#' @importFrom prettyunits pretty_dt

block_callback <- function(top_line = TRUE) {

  partial_line <- ""

  first <- top_line
  state <- "OK"
  should_time <- FALSE
  line_started <- Sys.time()
  now <- NULL
  prev_line <- ""

  no <- function(x, what = "") {
    pattern <- paste0(" \\.\\.\\. ", what, "$")
    sub("^\\* ", "", sub(pattern, "", x))
  }

  time_if_long <- function() {
    elapsed <- now - line_started
    if (elapsed> as.difftime(1/3, units = "secs")) {
      style(timing = paste0(" (", pretty_dt(elapsed), ")"))
    } else {
      ""
    }
  }

  do_line <- function(x) {

    should_time <<- FALSE
    now <<- Sys.time()

    ## First line of output?
    if (first) {
      line <- rep(symbol$line, min(getOption("width", 80), 80))
      cat(style(pale = line), sep = "", "\n")
      first <<- FALSE
    }

    ## Test mode is special. It will change the 'state' back to 'OK',
    ## once it is done.
    xx <- if (state == "tests") {
      do_test_mode(x)
    } else if (is_new_check(x)) {
      do_new_check(x)
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
      style(note = c("N ", no(x, "NOTE")))
    } else if (grepl(" \\.\\.\\. WARNING\\s*$", x)) {
      state <<- "WARNING"
      style(warn = c("W ", no(x, "WARNING")))
    } else if (grepl(" \\.\\.\\. ERROR\\s*$", x)) {
      state <<- "ERROR"
      style(err = c("E ", no(x, "ERROR")))
    } else if (grepl("^\\* checking tests \\.\\.\\.[ ]?$", x)) {
      state <<- "tests"
      style(pale = c(symbol$line, "  ", no(x)))
    } else if (grepl("^\\* DONE\\s*$", x)) {
      state <<- "OK"
      NA_character_
    } else {
      style(pale = c(symbol$line, "  ", no(x)))
    }
  }

  ## The output from the tests is a bit messed up, especially if we
  ## want to process it line by line.
  ## The tests start with '* checking test ...\n' and then when a test
  ## file starts running we see sg like '  Running 'testthat.R''
  ## This is without the newline character.
  ##
  ## The first test file that errors out will stop the tests entirely.
  ##
  ## When a test file is done, we get a '\n', and then either the next one
  ## is started with another '  Running ...' line (without \n), or they are
  ## done completely, and we get a '\n' and ' ERROR\n' / ' OK\n' depending
  ## on the result.
  ##
  ## So the tricky thing is, we can only update a 'Running ' line after
  ## we already know what is in the next line. If the next line is ' ERROR',
  ## then the test file failed, otherwise succeeded. So we also do the actual
  ## updating based on the '  Running' partial lines.
  ##
  ## As usually, prev_line contains the previous line.

  do_test_mode <- function(x) {
    if (!grepl("^\\* checking tests \\.\\.\\.", prev_line)) {
      if (grepl("^ OK", x)) {
        state <<- "OK"
        style(ok = symbol$tick, pale = no(prev_line))
      } else if (grepl("^ ERROR", x)) {
        state <<- "ERROR"
        style(err = "E", pale = no(prev_line))
      } else {
        NA_character_
      }
    } else {
      NA_character_
    }
  }

  do_test_partial_line <- function(x) {
    if (grepl("^  Running ", x) &&
        !grepl("^\\* checking tests \\.\\.\\.", prev_line)) {
      xx <- style(ok = symbol$tick, pale = no(prev_line))
      xx <- style(xx, timing = time_if_long())
      cat(xx, "\n", sep = "")
      flush(stdout())
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
    cat0(sub("^[\\* ]", "  ", partial_line), "\r")
  }
}

to_status <- function(x) {
  notes <- warnings <- errors <- 0
  if (grepl("ERROR", x)) {
    errors <- as.numeric(sub("^.* ([0-9]+) ERROR.*$", "\\1", x))
  }
  if (grepl("WARNING", x)) {
    warnings <- as.numeric(sub("^.* ([0-9]+) WARNING.*$", "\\1", x))
  }
  if (grepl("NOTE", x)) {
    notes <- as.numeric(sub("^.* ([0-9]+) NOTE.*$", "\\1", x))
  }
  structure(
    list(
      notes = rep("", notes),
      warnings = rep("", warnings),
      errors = rep("", errors)
    ),
    class = "rcmdcheck"
  )
}

is_new_check <- function(x) {
  grepl("^\\* ", x)
}
