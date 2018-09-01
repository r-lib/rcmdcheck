
make_fake_profile  <- function(session_output) {
  profile <- tempfile()

  ## Include the real profile as well, if any
  user <- Sys.getenv("R_PROFILE_USER", NA_character_)
  local <- ".Rprofile"
  home  <- path.expand("~/.Rprofile")
  if (is.na(user) && file.exists(local)) user <- local
  if (is.na(user) && file.exists(home)) user <- home
  if (!is.na(user) && file.exists(user)) file.append(profile, user)

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

  cat(".Last <-", deparse(last), sep = "\n", file = profile,
      append = TRUE)

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
