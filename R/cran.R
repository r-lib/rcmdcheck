
#' Download and show all CRAN check flavour platforms
#'
#' If the `package` argument is `NULL`, then all current
#' platforms are downloaded. If the `package` argument is specified,
#' then all flavours used for the latest package checks for that
#' package, are downloaded and returned.
#'
#' @param package CRAN package name or `NULL`.
#' @return Character vector of platform ids.
#'
#' @export
#' @examples
#' \dontrun{
#' cran_check_flavours()
#' cran_check_flavours("simplegraph")
#' }

cran_check_flavours <- function(package = NULL) {

  if (is.null(package)) return(cran_check_flavours_generic())

  base <- Sys.getenv(
    "RCMDCHECK_BASE_URL",
    "https://cran.r-project.org/web/checks/"
  )
  url <- paste0(base, "check_results_", package, ".html")

  html <- download_file_lines(url)

  fl_rows <- grep(
    "<tr> <td>  <a href=\"check_flavors.html#",
    html,
    fixed = TRUE, value = TRUE
  )

  sub(
    "^<tr> <td>  <a href=\"check_flavors.html#[^\"]*\">\\s*([^\\s<]+)\\s*</a>.*$",
    "\\1",
    fl_rows,
    perl = TRUE
  )
}

cran_check_flavours_generic <- function() {
  url <- Sys.getenv(
    "RCMDCHECK_FLAVOURS_URL",
    "https://cran.r-project.org/web/checks/check_flavors.html"
  )
  html <- download_file_lines(url)

  fl_rows <- grep(
    "^<tr id=\"[-a-z0-9_]+\"> <td> ",
    html,
    value = TRUE
  )

  sub(
    "^<tr id=\"[-a-z0-9_]+\"> <td>\\s*([^\\s<]+)\\s*</td>.*$",
    "\\1",
    fl_rows,
    perl = TRUE
  )
}

#' Download and parse R CMD check results from CRAN
#'
#' @param package Name of a single package to download the checks for.
#' @param flavours CRAN check flavours to use. Defaults to all
#'   flavours that were used to check the package.
#' @param quiet Whether to omit the download progress bars.
#' @return A list of `rcmdcheck` objects.
#'
#' @export

cran_check_results <- function(package,
                               flavours = cran_check_flavours(package),
                               quiet = FALSE) {

  stopifnot(is_string(package))

  base <- Sys.getenv(
    "RCMDCHECK_DETAILS_URL",
    "https://www.r-project.org/nosvn/R.check/"
  )
  urls <- paste0(base, flavours, "/", package, "-00check.txt")

  tmp <- paste0(tempfile(), "-", seq_along(urls))
  download_files(urls, tmp, quiet = quiet)

  structure(
    lapply(tmp, parse_check),
    names = flavours,
    package = package,
    class = "rmcdcheck_cran_results"
  )
}
