Run R CMD check from R and Capture Results
================

  - [rcmdcheck](#rcmdcheck)
      - [Installation](#installation)
      - [Usage](#usage)
      - [License](#license)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# rcmdcheck

> Run R CMD check from R and Capture Results

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![R-CMD-check](https://github.com/r-lib/rcmdcheck/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-lib/rcmdcheck/actions/workflows/R-CMD-check.yaml)
[![](https://www.r-pkg.org/badges/version/rcmdcheck)](https://www.r-pkg.org/pkg/rcmdcheck)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/rcmdcheck)](https://www.r-pkg.org/pkg/rcmdcheck)
+[![Codecov test coverage](https://codecov.io/gh/r-lib/rcmdcheck/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r-lib/rcmdcheck?branch=main)
<!-- badges: end -->

Run R CMD check form R programatically, and capture the results of the
individual checks.

## Installation

``` r
install.packages("rcmdcheck")
```

## Usage

``` r
library(rcmdcheck)
rcmdcheck("path/to/R/package")
```

Call `rcmdcheck()` on a source R package `.tar.gz` file, or on a folder
containing your R package. Supply `quiet = FALSE` if you want to omit
the output. The result of the check is returned, in a list with elements
`errors`, `warnings`, and `notes`. Each element is a character vector,
and one element of the character vectors is a single failure.

<img width="1000" src="https://cdn.jsdelivr.net/gh/r-lib/rcmdcheck@master/tools/rcmdcheck.svg">

### Programmatic usage

`rcmdcheck()` returns an `rcmdcheck` object, which you can query and
manipulate.

``` r
library(rcmdcheck)
chk <- rcmdcheck("tests/testthat/bad1", quiet = TRUE)
chk
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────── badpackage 1.0.0 ────
#> Duration: 12.4s
#> 
#> ❯ checking DESCRIPTION meta-information ... WARNING
#>   Non-standard license specification:
#>     Public domain
#>   Standardizable: FALSE
#> 
#> 0 errors ✔ | 1 warning ✖ | 0 notes ✔
```

`check_details()` turns the check results into a simple lists with the
following information currently:

``` r
names(check_details(chk))
#>  [1] "package"      "version"      "notes"        "warnings"     "errors"      
#>  [6] "platform"     "checkdir"     "install_out"  "description"  "session_info"
#> [11] "cran"         "bioc"
```

  - `package`: Package name.
  - `version`: Package version number.
  - `notes`: Character vector of check `NOTE`s.
  - `warnings`: Character vector of check `WARNING`s.
  - `errors`: Character vector of check `ERROR`s.
  - `platform`: Platform, e.g. `x86_64-apple-darwin15.6.0`.
  - `checkdir`: Check directory.
  - `install_out`: Output of the package installation.
  - `description`: The text of the `DESCRIPTION` file.
  - `session_info`: A `sessioninfo::session_info` object, session
    information from within the check process.
  - `cran`: Flag, whether this is a CRAN package. (Based on the
    `Repository` field in `DESCRIPTION`, which is typically only set for
    published CRAN packages.)
  - `bioc`: Flag, whether this is a Bioconductor package, based on the
    presence of the `biocViews` field in `DESCRIPTION`.

Note that if the check results were parsed from a file, some of these
fields might be missing (`NULL`), as we don’t have access to the
original `DESCRIPTION`, the installation output, etc.

### Parsing check output

`parse_check()` parses check output from a file, `parse_check_url()`
parses check output from a URL.

### CRAN checks

rcmdcheck has a functions to access CRAN’s package check results.

`cran_check_flavours()` downloads the names of the CRAN platforms:

``` r
cran_check_flavours()
#>  [1] "r-devel-linux-x86_64-debian-clang" "r-devel-linux-x86_64-debian-gcc"  
#>  [3] "r-devel-linux-x86_64-fedora-clang" "r-devel-linux-x86_64-fedora-gcc"  
#>  [5] "r-devel-windows-x86_64"            "r-patched-linux-x86_64"           
#>  [7] "r-patched-solaris-x86"             "r-release-linux-x86_64"           
#>  [9] "r-release-macos-arm64"             "r-release-macos-x86_64"           
#> [11] "r-release-windows-ix86+x86_64"     "r-oldrel-macos-x86_64"            
#> [13] "r-oldrel-windows-ix86+x86_64"
```

`cran_check_results()` loads and parses all check results for a package.

``` r
cran_check_results("igraph")
#> $`r-devel-linux-x86_64-debian-clang`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking top-level files ... WARNING
#>     Output from running autoreconf:
#>     configure.ac:71: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:71: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:71: the top level
#>     configure.ac:110: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:110: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:110: the top level
#>     configure.ac:127: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:127: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:127: the top level
#> 
#> 0 errors ✔ | 1 warning ✖ | 0 notes ✔
#> 
#> $`r-devel-linux-x86_64-debian-gcc`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking top-level files ... WARNING
#>     Output from running autoreconf:
#>     configure.ac:71: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:71: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:71: the top level
#>     configure.ac:110: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:110: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:110: the top level
#>     configure.ac:127: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:127: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:127: the top level
#> 
#> 0 errors ✔ | 1 warning ✖ | 0 notes ✔
#> 
#> $`r-devel-linux-x86_64-fedora-clang`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 16.9Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.1Mb
#>       libs  14.0Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-devel-linux-x86_64-fedora-gcc`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
#> 
#> $`r-devel-windows-x86_64`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is  9.8Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.1Mb
#>       libs   6.9Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-devel-windows-x86_64-gcc10-UCRT`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking whether package 'igraph' can be installed ... ERROR
#>   See below...
#> 
#> ❯ checking package dependencies ... NOTE
#>   Package suggested but not available for checking: 'rgl'
#> 
#> ── Install failure ───────────────────────────────────────────────────────────────────────────────────────────────────────
#> 
#> <00install.out file does not exist>
#> 1 error ✖ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-patched-linux-x86_64`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking top-level files ... WARNING
#>     Output from running autoreconf:
#>     configure.ac:71: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:71: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:71: the top level
#>     configure.ac:110: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:110: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:110: the top level
#>     configure.ac:127: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:127: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:127: the top level
#> 
#> 0 errors ✔ | 1 warning ✖ | 0 notes ✔
#> 
#> $`r-patched-solaris-x86`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is  9.6Mb
#>     sub-directories of 1Mb or more:
#>       R      1.5Mb
#>       help   1.2Mb
#>       libs   6.5Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-release-linux-x86_64`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking top-level files ... WARNING
#>     Output from running autoreconf:
#>     configure.ac:71: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:71: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:71: the top level
#>     configure.ac:110: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:110: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:110: the top level
#>     configure.ac:127: warning: The macro `AC_HELP_STRING' is obsolete.
#>     configure.ac:127: You should run autoupdate.
#>     ./lib/autoconf/general.m4:204: AC_HELP_STRING is expanded from...
#>     configure.ac:127: the top level
#> 
#> 0 errors ✔ | 1 warning ✖ | 0 notes ✔
#> 
#> $`r-release-macos-arm64`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 23.7Mb
#>     sub-directories of 1Mb or more:
#>       R      2.0Mb
#>       help   1.1Mb
#>       libs  20.0Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-release-macos-x86_64`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 21.2Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.1Mb
#>       libs  18.3Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-release-windows-ix86+x86_64`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 17.1Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.1Mb
#>       libs  14.2Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-oldrel-macos-x86_64`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 21.2Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.1Mb
#>       libs  18.3Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-oldrel-windows-ix86+x86_64`
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────────────── igraph 1.2.6 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 17.1Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.1Mb
#>       libs  14.2Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> attr(,"package")
#> [1] "igraph"
#> attr(,"class")
#> [1] "rmcdcheck_cran_results"
```

### Comparing checks

`compare_checks()` can compare two or more `rcmdcheck` objects.
`compare_to_cran()` compares an `rcmdcheck` object to the CRAN checks of
the same package:

``` r
chk <- rcmdcheck(quiet = TRUE)
compare_to_cran(chk)
#> ── R CMD check comparison ────────────────────────────────────────────────────────────── rcmdcheck 1.3.3 / 1.3.3.9000 ────
#> Status: OK
#> 
#> ── Fixed
#> 
#> ✔ checking LazyData ... NOTE
#> ✔ checking LazyData ... NOTE
#> ✔ checking LazyData ... NOTE
#> ✔ checking LazyData ... NOTE
#> ✔ checking LazyData ... NOTE
#> ✔ checking LazyData ... NOTE
```

### Background processes

`rcmdcheck_process` is a `processx::process` class, that can run `R CMD
check` in the background. You can also use this to run multiple checks
concurrently. `processx::process` methods can be used to poll or
manipulate the check processes.

``` r
chkpx <- rcmdcheck_process$new()
chkpx
#> PROCESS 'R', running, pid 82576.
```

``` r
chkpx$wait()
chkpx$parse_results()
#> ── R CMD check results ───────────────────────────────────────────────────────────────────────── rcmdcheck 1.3.3.9000 ────
#> Duration: 23.6s
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

## License

MIT © Mango Solutions, Gábor Csárdi, RStudio
