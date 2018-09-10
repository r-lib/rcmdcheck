
# devel

* `rcmdcheck_process` to run `R CMD check` in the background

* Timeout support (default is 10 minutes)

* Capture and print installation and test failures

* Record and print the duration of the check

* Record and print session information from the check session (#22)

* Keep files until the returned check object is deleted (#23)

* New `xopen()` to show the check file in a file browser window (#61)

* Save `install.out` and also `DESCRIPTION` in the result,
  save the standard error and the exit status as well

* Better printing of progress: now the message from the check that is
  actually being performed is shown on the screen.

* Spinner while running check

* `summary()` method for check comparisons

* `check_details()` to query the check results programmatically.
  (No need to use `$errors`, `$warnings`, etc. directly.)

* Find package root automatically (#18)

* `error_on` argument to throw an error on an `R CMD check` failure (#51)

* Fix colors when printing a check object (#54)

# 1.2.1

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

# 1.1.0

* New arguments `libpath` and `repos` to set the library path
  and the default CRAN repository

* Do not run tests on CRAN.

# 1.0.0

First public release.
