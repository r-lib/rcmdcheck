
make_fake_profile  <- function(session_output) {
  last <- substitute(
    function() {
      si <- utils::sessionInfo()
      l <- if (file.exists(`__output__`)) {
        readRDS(`__output__`)
      } else {
        list()
      }
      saveRDS(c(l, list(si)), `__output__`)
    },
    list(`__output__` = session_output)
  )

  profile <- tempfile()
  cat(".Last <-", deparse(last), file = profile, sep = "\n")
  profile
}

get_session_info <- function(package, session_output) {

  ## Extract session info for this package
  session_info <- tryCatch(
    suppressWarnings(readRDS(session_output)),
    error = function(e) NULL
  )

  session_info <- Filter(
    function(so) package %in% names(so$otherPkgs),
    session_info
  )
  if (length(session_info) > 1) {
    session_info <- session_info[[1]]
  }

  session_info
}
