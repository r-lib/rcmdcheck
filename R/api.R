
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
#'   * `session_info`: the output of `utils::sessionInfo()`, from the R
#'     session performing the checks.
#'   * `checkdir`: the path to the check directory, if it hasn't been
#'     cleaned up yet, or `NA`. The check directory is automatically
#'     cleaned up, when the check object is deleted (garbage collected).
#'   * `cran`: whether it is a CRAN packaged package.
#'   * `bioc`: whether it is a BioConductor package.
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
    description = check$description,
    session_info = check$session_info,
    cran = check$cran,
    bioc = check$bioc
  )
}
