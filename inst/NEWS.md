
# 1.2.1

* The result object has more metadata: package name, version,
  R version and platform.

* `rcmdcheck()` works on tarballs build via `R CMD build` now.

* Parse `R CMD check` results: `parse_check`, `parse_check_url`.

* Download and parse check results for CRAN packages.

* Report errors during the build, typically vignette errors.

* Use the `callr` package (https://github.com/MangoTheCat/callr)
  for running `R CMD` commands.

# 1.1.0

* New arguments `libpath` and `repos` to set the library path
  and the default CRAN repository

* Do not run tests on CRAN.

# 1.0.0

First public release.
