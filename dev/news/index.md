# Changelog

## rcmdcheck (development version)

- Fixed an issue where check output could be malformed when testing
  packages with multiple test files
  ([\#205](https://github.com/r-Lib/rcmdcheck/issues/205),
  [@kevinushey](https://github.com/kevinushey)).

- Update pkgdown template and move url to <https://rcmdcheck.r-lib.org>.

- Fix usage of `libpath` argument
  ([\#195](https://github.com/r-Lib/rcmdcheck/issues/195)).

- [`cran_check_results()`](https://rcmdcheck.r-lib.org/dev/reference/cran_check_results.md)
  works again.

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  now will print relevant environment variables
  ([\#172](https://github.com/r-Lib/rcmdcheck/issues/172),
  [@tanho63](https://github.com/tanho63))

## rcmdcheck 1.4.0

CRAN release: 2021-09-27

- [`cran_check_results()`](https://rcmdcheck.r-lib.org/dev/reference/cran_check_results.md)
  now downloads results in parallel, so it is much faster.

- `rcmdcheck_process` now redirects the standard error to the standard
  output, to make sure that they are correctly interleaved
  ([\#148](https://github.com/r-Lib/rcmdcheck/issues/148)).

- rcmdcheck now puts Rtools on the PATH, via pkgbuild
  ([\#111](https://github.com/r-Lib/rcmdcheck/issues/111)).

- rcmdcheck now builds the manual when building the package, if it is
  needed for `\Sexpr{}` expressions
  ([\#137](https://github.com/r-Lib/rcmdcheck/issues/137)).

- This version fixes a rare race condition that made rcmdcheck fail
  ([\#139](https://github.com/r-Lib/rcmdcheck/issues/139)).

- rcmdcheck now safeguards against R deleting the user’s home directory
  via an `R CMD build` bug
  ([\#120](https://github.com/r-Lib/rcmdcheck/issues/120)).

- rcmdcheck can now ignore files in `inst/doc` when building a package.
  See the `Config/build/clean-inst-doc` package option in
  [`?"rcmdcheck-config"`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck-config.md)
  ([\#130](https://github.com/r-Lib/rcmdcheck/issues/130)).

- It is now possible to turn on/off ANSI colors for rcmdcheck only,
  without affecting the checked package. See
  `?"rcmdcheck-config" and the`RCMDCHECK_NUM_COLORS`environment variable and the`rcmdcheck.num_colors\`
  option ([\#119](https://github.com/r-Lib/rcmdcheck/issues/119),
  [@jimhester](https://github.com/jimhester)).

- [`print.rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/print.rcmdcheck.md)
  now has a `test_output` argument and `rcmdcheck.test_output` global
  option, to control whether to print the full test output or not.
  ([\#121](https://github.com/r-Lib/rcmdcheck/issues/121))

- RStudio’s Pandoc is now on the path during
  [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  and `rcmdcheck_process`
  ([\#109](https://github.com/r-Lib/rcmdcheck/issues/109),
  [\#132](https://github.com/r-Lib/rcmdcheck/issues/132),
  [@dpprdan](https://github.com/dpprdan)).

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  now errors if the check process crashes
  ([\#110](https://github.com/r-Lib/rcmdcheck/issues/110),
  [\#163](https://github.com/r-Lib/rcmdcheck/issues/163)).

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  prints the check ouptut better interactively, especially when the
  package has multiple test files
  ([\#145](https://github.com/r-Lib/rcmdcheck/issues/145),
  [\#161](https://github.com/r-Lib/rcmdcheck/issues/161)).

- rcmdcheck can now ignore `NOTE`s, if requested, see
  [`?rcmdcheck`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  for details ([\#12](https://github.com/r-Lib/rcmdcheck/issues/12),
  [\#160](https://github.com/r-Lib/rcmdcheck/issues/160)).

- rcmdcheck now always converts its output to UTF-8 from the native
  encoding. It also handles parsing check output in a non-native
  encoding better
  ([\#152](https://github.com/r-Lib/rcmdcheck/issues/152)).

- rcmdcheck now ignored time stamps when comparing two check results
  ([\#128](https://github.com/r-Lib/rcmdcheck/issues/128)).

- rcmdcheck now does not print extra empty lines in the interactive
  output on GitHub Actions.

- rcmdcheck now uses a more robust implementation to extract the session
  info from the check process
  ([\#164](https://github.com/r-Lib/rcmdcheck/issues/164)).

## rcmdcheck 1.3.3

CRAN release: 2019-05-07

- [`cran_check_results()`](https://rcmdcheck.r-lib.org/dev/reference/cran_check_results.md)
  has now a `quiet` argument, and the download progress bars are shown
  if it is set to `FALSE`
  ([\#17](https://github.com/r-Lib/rcmdcheck/issues/17)).

- Fix output when standard output does not support `\r`, typically when
  it is not a terminal
  ([\#94](https://github.com/r-Lib/rcmdcheck/issues/94)).

- Fix standard output and standard error mixup in the test cases,
  ([\#88](https://github.com/r-Lib/rcmdcheck/issues/88),
  [\#96](https://github.com/r-Lib/rcmdcheck/issues/96)).

- Fix parsing test failures when multiple architectures are checked,
  ([\#97](https://github.com/r-Lib/rcmdcheck/issues/97)).

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  has now better colors. WARNINGs are magenta, and NOTEs are blue
  ([\#103](https://github.com/r-Lib/rcmdcheck/issues/103),
  [@hadley](https://github.com/hadley)).

## rcmdcheck 1.3.2

CRAN release: 2018-11-10

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  now correctly overwrites existing tarballs if they already exist in
  the check directory. This time for real.

## rcmdcheck 1.3.1

CRAN release: 2018-11-05

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  now correctly overwrites existing tarballs if they already exist in
  the check directory
  ([\#84](https://github.com/r-Lib/rcmdcheck/issues/84)
  [@jimhester](https://github.com/jimhester)).

- rcmdcheck now uses
  [`sessioninfo::session_info()`](https://sessioninfo.r-lib.org/reference/session_info.html)
  to query session information for the check.

## rcmdcheck 1.3.0

CRAN release: 2018-09-19

- New `rcmdcheck_process` class to run `R CMD check` in the background.

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  now supports timeouts (default is 10 minutes).

- Checks now capture and print installation and test failures.

- Checks now record and print the duration of the check.

- Checks now record and print session information from the check session
  ([\#22](https://github.com/r-Lib/rcmdcheck/issues/22)).

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  new keep files until the returned check object is deleted, if check
  was run in a temporary directory (the default)
  ([\#23](https://github.com/r-Lib/rcmdcheck/issues/23)).

- New `xopen()` to show the check file in a file browser window
  ([\#61](https://github.com/r-Lib/rcmdcheck/issues/61)).

- Checks now save `install.out` and also `DESCRIPTION` in the result,
  and save the standard error and the exit status as well.

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  printing is now better: the message from the check that is actually
  *being performed* is shown on the screen.

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  now shows a spinner while running check.

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  results now have a [`summary()`](https://rdrr.io/r/base/summary.html)
  method for check comparisons.

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  results now have a new
  [`check_details()`](https://rcmdcheck.r-lib.org/dev/reference/check_details.md)
  method, to query the check results programmatically. (No need to use
  `$errors`, `$warnings`, etc. directly.)

- Checks now find package root automatically
  ([\#18](https://github.com/r-Lib/rcmdcheck/issues/18)).

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  now has an `error_on` argument to throw an error on an `R CMD check`
  failure ([\#51](https://github.com/r-Lib/rcmdcheck/issues/51)).

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  result printing is now better, the colors are consistent
  ([\#54](https://github.com/r-Lib/rcmdcheck/issues/54)).

## rcmdcheck 1.2.1

CRAN release: 2016-09-28

- Compare two check results with `compare_checks` or compare check
  results to CRAN with `compare_to_cran`.

- The result object has more metadata: package name, version, R version
  and platform.

- Refined printing of the result.

- [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  works on tarballs build via `R CMD build` now.

- Parse `R CMD check` results: `parse_check`, `parse_check_url`.

- Download and parse check results for CRAN packages.

- Report errors during the build, typically vignette errors.

- Use the `callr` package (<https://github.com/r-lib/callr>) for running
  `R CMD` commands.

## rcmdcheck 1.1.0

CRAN release: 2016-04-16

- New arguments `libpath` and `repos` to set the library path and the
  default CRAN repository

- Do not run tests on CRAN.

## rcmdcheck 1.0.0

CRAN release: 2016-03-28

First public release.
