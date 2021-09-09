
#' rcmdcheck configuration
#'
#' Options take precedence over environment variables. E.g. if both
#' the `RCMDCHECK_NUM_COLORS` environment variables and the
#' `rcmdcheck.num_colors` option are set, then the latter is used.
#'
#' rcmdcheck uses the cli package for much of its output, so you can
#' configure the output via cli, see [cli::cli-config].
#' 
#' # Environment variables
#'
#' * `R_PROFILE_USER`: standard R environment variable to configure the
#'   path to the user level R profile. See [base::R_PROFILE_USER].
#'
#' * `RCMDCHECK_BASE_URL`: URL to the root of the CRAN check web page.
#'   You can use this to select an alternative CRAN mirror. Defaults to
#'   `https://cran.r-project.org/web/checks/`.
#'
#' * `RCMDCHECK_DETAILS_URL`: URL to the root of the CRAN check output
#'   page. Defaults to `https://www.r-project.org/nosvn/R.check/`.
#' 
#' * `RCMDCHECK_FLAVOURS_URL` URL to the CRAN check flavours page.
#'   You can use this to select an alternative CRAN mirror. Defaults to
#'   `https://cran.r-project.org/web/checks/check_flavors.html`.
#' 
#' * `RCMDCHECK_NUM_COLORS`: the number of ANSI colors to use in the output.
#'   It can be used to override the number of colors detected or configured
#'   by the cli package. See [cli::num_ansi_colors()]. This configuration
#'   is only used for the output of rcmdcheck and it does not affect the
#'   examples and test cases (and other code) of the checked package.
#'   It not set, then the default of cli is uesed. The corresponding
#'   option is `rcmdcheck.num_colors`.
#'
#' * `RCMDCHECK_TIMESTAMP_LIMIT`: lower limit is seconds, above which
#'   rcmdcheck adds time stamps to the individual check steps. It may be
#'   fractional. Defaults to 1/3 of a second. The corresponding option is
#'   `rcmdcheck.timestamp_limit`.
#' 
#' # Options
#'
#' * `rcmdcheck.num_colors`: the number of ANSI colors to use in the output.
#'   It can be used to override the number of colors detected or configured
#'   by the cli package. See [cli::num_ansi_colors()]. This configuration
#'   is only used for the output of rcmdcheck and it does not affect the
#'   examples and test cases (and other code) of the checked package.
#'   It not set, then the default of cli is uesed. The corresponding
#'   environment variable is `RCMDCHECK_NUM_COLORS`.
#'
#' * `rcmdcheck.timestamp_limit`: lower limit is seconds, above which
#'   rcmdcheck adds time stamps to the individual check steps. It may be
#'   fractional. Defaults to 1/3 of a second. The corresponding environment
#'   variable is `RCMDCHECK_TIMESTAMP_LIMIT`.
#'
#' @name rcmdcheck-config
NULL
