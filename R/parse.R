
parse_check_output <- function(output) {

  entries <- strsplit(paste0("\n", output$stdout), "\n* ", fixed = TRUE)[[1]][-1]

  structure(
    list(
      output   = output,
      errors   = grep(" ... ERROR\n",   entries, value = TRUE, fixed = TRUE),
      warnings = grep(" ... WARNING\n", entries, value = TRUE, fixed = TRUE),
      notes    = grep(" ... NOTE\n",    entries, value = TRUE, fixed = TRUE)
    ),
    class = "rcmdcheck"
  )
}
