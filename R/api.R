
#' Query R CMD check results and parameters
#'
#' @param check A check result.
#' @return A named list with elements:
#'   * `package`: package name.
#'   * `version`: package version.
#'   * `rversion`: R version.
#'   * `notes`: character vector of check NOTEs, each NOTE is an
#'       element.
#'   * `warnings`: character vector of check WARNINGs, each WARNING is an
#'       element.
#'   * `errors`: character vector of check ERRORs, each ERROR is an element.
#'       A check timeout adds an ERROR to this vector.
#'   * `platform`: check platform
#'   * `checkdir`: check directory.
#'   * `install_out`: the output of the installation, contents of the
#'     `00install.out` file. A single string.
#'   * `description`: the contents of the DESCIRPTION file of the package.
#'     A single string.
#'
#' @export

check_details <- function(check) {
  list(
    package = check$package,
    version = check$version,
    notes = check$notes,
    warnings = check$warnings,
    errors = check$errors,
    platform = check$platform,
    checkdir = check$checkdir,
    install_out = check$install_out,
    description = check$description
  )
}
