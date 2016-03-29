
## This is the callback called for each line of the output
## We color it a bit, OK is green, NOTE is orange,
## WARNING and ERROR are red.

#' @importFrom crayon red green make_style bold
#' @importFrom clisymbols symbol

check_callback <- function() {

  ok   <- green
  note <- make_style("orange")
  warn <- make_style("orange") $ bold
  err  <- red
  pale <- make_style("darkgrey")

  first <- TRUE
  state <- "OK"

  no <- function(x, what = "") {
    pattern <- paste0(" \\.\\.\\. ", what, "$")
    sub("^\\* ", "", sub(pattern, "", x))
  }

  get_style <- function(state) {
    switch(
      state,
      "OK" = ok, "NOTE" = note, "WARNING" = warn, "ERROR" = err
    )
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

  function(x) {

    ## First line of output?
    if (first) {
      line <- rep(symbol$line, min(getOption("width", 80), 80))
      cat(pale(line), sep = "", "\n")
      first <<- FALSE
    }

    ## the result of 'checking tests'
    if (state == "tests") {
      state <<- "OK"
      x <- paste0("* checking tests ...", x)
    }

    ## an OK check line
    x <- if (grepl("\\* .* \\.\\.\\. OK$", x)) {
      state <<- "OK"
      paste0(ok(symbol$tick), "  ", pale(no(x, "OK")))

    ## a NOTE check line
    } else if (grepl("\\* .* \\.\\.\\. NOTE$", x)) {
      state <<- "NOTE"
      note("N ", no(x, "NOTE"))

    ## a WARNING check line
    } else if (grepl("\\* .* \\.\\.\\. WARNING$", x)) {
      state <<- "WARNING"
      warn("W ", no(x, "WARNING"))

    ## an ERROR check line
    } else if (grepl("\\* .* \\.\\.\\. ERROR$", x)) {
      state <<- "ERROR"
      err("E ", no(x, "ERROR"))

    ## the final DONE message
    } else if (grepl("\\* DONE$", x)) {
      state <<- "OK"
      ""

    ## a checking tests ... line, the result is in the next line...
    } else if (grepl("\\* checking tests \\.\\.\\.[ ]?$", x)) {
      state <<- "tests"
      NA_character_

    ## a generic status line
    } else if (grepl("\\* ", x)) {
      state <<- "OK"
      paste0(pale(symbol$line), "  ", no(x))

    } else if (grepl("^Status: ", x)) {
      state <<- "OK"
      summary(to_status(x))
      NA_character_

    ## Don't know what this is, just print, with some indentation,
    ## and the color of the current state
    } else {
      get_style(state)(paste0("   ", x))
    }

    ## NA is the way we forbid output
    if (!is.na(x)) {
      cat(x, "\n", sep = "")
      flush(stdout())
    }
  }
}
