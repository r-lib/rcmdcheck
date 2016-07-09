
cran_check_flavours <- function(package = NULL) {

  if (is.null(package)) return(cran_check_flavours_generic())

  url <- paste0(
    "https://cran.r-project.org/web/checks/check_results_",
    package,
    ".html"
  )

  html <- download_file(url)

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
  url <- "https://cran.r-project.org/web/checks/check_flavors.html"
  html <- download_file(url)

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
#' @return A list of \code{rcmdcheck} objects.
#'
#' @export

cran_check_results <- function(package,
                               flavours = cran_check_flavours(package)) {

  stopifnot(is_string(package))

  urls <- paste0(
    "https://www.r-project.org/nosvn/R.check/",
    flavours, "/", package,
    "-00check.txt"
  )

  structure(
    lapply(urls, parse_check_url),
    names = flavours
  )
}
