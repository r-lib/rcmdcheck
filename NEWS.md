
# rcmdcheck (development version)

* Fixed an issue where check output could be malformed when testing
  packages with multiple test files (#205, @kevinushey).

* Update pkgdown template and move url to https://rcmdcheck.r-lib.org.

* Fix usage of `libpath` argument (#195).

# rcmdcheck 1.4.0

* `cran_check_results()` now downloads results in parallel, so it is
  much faster.

* `rcmdcheck_process` now redirects the standard error to the standard
  output, to make sure that they are correctly interleaved (#148).

* rcmdcheck now puts Rtools on the PATH, via pkgbuild (#111).

* rcmdcheck now builds the manual when building the package, if it is
  needed for `\Sexpr{}` expressions (#137).

* This version fixes a rare race condition that made rcmdcheck fail (#139).

* rcmdcheck now safeguards against R deleting the user's home directory
  via an `R CMD build` bug (#120).

* rcmdcheck can now ignore files in `inst/doc` when building a package.
  See the `Config/build/clean-inst-doc` package option in
  `?"rcmdcheck-config"` (#130).

* It is now possible to turn on/off ANSI colors for rcmdcheck only,
  without affecting the checked package. See `?"rcmdcheck-config" and the
  `RCMDCHECK_NUM_COLORS` environment variable and the `rcmdcheck.num_colors`
  option (#119, @jimhester).

* `print.rcmdcheck()` now has a `test_output` argument and
  `rcmdcheck.test_output` global option, to control whether to print the full
  test output or not. (#121)

* RStudio's Pandoc is now on the path during `rcmdcheck()`
  and `rcmdcheck_process` (#109, #132, @dpprdan).

* `rcmdcheck()` now errors if the check process crashes (#110, #163).

* `rcmdcheck()` prints the check ouptut better interactively, especially
  when the package has multiple test files (#145, #161).

* rcmdcheck can now ignore `NOTE`s, if requested, see `?rcmdcheck` for
  details (#12, #160).

* rcmdcheck now always converts its output to UTF-8 from the native
  encoding. It also handles parsing check output in a non-native encoding
  better (#152).

* rcmdcheck now ignored time stamps when comparing two check results (#128).

* rcmdcheck now does not print extra empty lines in the interactive output
  on GitHub Actions.

* rcmdcheck now uses a more robust implementation to extract the session
  info from the check process (#164).

# rcmdcheck 1.3.3

* `cran_check_results()` has now a `quiet` argument, and the download
  progress bars are shown if it is set to `FALSE` (#17).

* Fix output when standard output does not support `\r`, typically when
  it is not a terminal (#94).

* Fix standard output and standard error mixup in the test cases,
  (#88, #96).

* Fix parsing test failures when multiple architectures are checked, (#97).

* `rcmdcheck()` has now better colors. WARNINGs are magenta, and NOTEs
  are blue (#103, @hadley).

# rcmdcheck 1.3.2

* `rcmdcheck()` now correctly overwrites existing tarballs if they already
  exist in the check directory. This time for real.

# rcmdcheck 1.3.1

* `rcmdcheck()` now correctly overwrites existing tarballs if they already
  exist in the check directory (#84 @jimhester).

* rcmdcheck now uses `sessioninfo::session_info()` to query session
  information for the check.

# rcmdcheck 1.3.0

* New `rcmdcheck_process` class to run `R CMD check` in the background.

* `rcmdcheck()` now supports timeouts (default is 10 minutes).

* Checks now capture and print installation and test failures.

* Checks now record and print the duration of the check.

* Checks now record and print session information from the check
  session (#22).

* `rcmdcheck()` new keep files until the returned check object is
  deleted, if check was run in a temporary directory (the default) (#23).

* New `xopen()` to show the check file in a file browser window (#61).

* Checks now save `install.out` and also `DESCRIPTION` in the result,
  and save the standard error and the exit status as well.

* `rcmdcheck()` printing is now better: the message from the check that is
  actually _being performed_ is shown on the screen.

* `rcmdcheck()` now shows a spinner while running check.

* `rcmdcheck()` results now have a `summary()` method for check comparisons.

* `rcmdcheck()` results now have a new  `check_details()` method, to query
  the check results programmatically. (No need to use `$errors`,
  `$warnings`, etc. directly.)

* Checks now find package root automatically (#18).

* `rcmdcheck()` now has an `error_on` argument to throw an error on an
  `R CMD check` failure (#51).

* `rcmdcheck()` result printing is now better, the colors are
  consistent (#54).

# rcmdcheck 1.2.1

* Compare two check results with `compare_checks` or compare check
  results to CRAN with `compare_to_cran`.

* The result object has more metadata: package name, version,
  R version and platform.

* Refined printing of the result.

* `rcmdcheck()` works on tarballs build via `R CMD build` now.

* Parse `R CMD check` results: `parse_check`, `parse_check_url`.

* Download and parse check results for CRAN packages.

* Report errors during the build, typically vignette errors.

* Use the `callr` package (https://github.com/r-lib/callr)
  for running `R CMD` commands.

# rcmdcheck 1.1.0

* New arguments `libpath` and `repos` to set the library path
  and the default CRAN repository

* Do not run tests on CRAN.

# rcmdcheck 1.0.0

First public release.
