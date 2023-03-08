Run R CMD check from R and Capture Results
================

- [rcmdcheck](#rcmdcheck)
  - [Installation](#installation)
  - [Usage](#usage)

<!-- README.md is generated from README.Rmd. Please edit that file -->

# rcmdcheck

> Run R CMD check from R and Capture Results

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![](https://www.r-pkg.org/badges/version/rcmdcheck)](https://www.r-pkg.org/pkg/rcmdcheck)
[![CRAN RStudio mirror
downloads](https://cranlogs.r-pkg.org/badges/rcmdcheck)](https://www.r-pkg.org/pkg/rcmdcheck)
[![R-CMD-check](https://github.com/r-lib/rcmdcheck/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-lib/rcmdcheck/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/r-lib/rcmdcheck/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r-lib/rcmdcheck?branch=main)
<!-- badges: end -->

Run R CMD check from R programmatically and capture the results of the
individual checks.

## Installation

Install the released version from CRAN

``` r
install.packages("rcmdcheck")
```

Or install the development version from GitHub:

``` r
# install.packages("pak")
pak::pak("r-lib/rcmdcheck")
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

<img width="1000" src="https://cdn.jsdelivr.net/gh/r-lib/rcmdcheck@main/tools/rcmdcheck.svg">

### Programmatic usage

`rcmdcheck()` returns an `rcmdcheck` object, which you can query and
manipulate.

``` r
library(rcmdcheck)
chk <- rcmdcheck("tests/testthat/bad1", quiet = TRUE)
chk
#> ── R CMD check results ─────────────────────────────────── badpackage 1.0.0 ────
#> Duration: 9.7s
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
#>  [7] "r-release-linux-x86_64"            "r-release-macos-arm64"            
#>  [9] "r-release-macos-x86_64"            "r-release-windows-x86_64"         
#> [11] "r-oldrel-macos-arm64"              "r-oldrel-macos-x86_64"            
#> [13] "r-oldrel-windows-ix86+x86_64"
```

`cran_check_results()` loads and parses all check results for a package.

``` r
cran_check_results("igraph")
#> $`r-devel-linux-x86_64-debian-clang`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
#> 
#> $`r-devel-linux-x86_64-debian-gcc`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
#> 
#> $`r-devel-linux-x86_64-fedora-clang`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is  7.2Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.4Mb
#>       libs   3.3Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-devel-linux-x86_64-fedora-gcc`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
#> 
#> $`r-patched-linux-x86_64`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
#> 
#> $`r-release-linux-x86_64`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
#> 
#> $`r-release-macos-arm64`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 19.9Mb
#>     sub-directories of 1Mb or more:
#>       R      2.1Mb
#>       help   1.4Mb
#>       libs  15.4Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-release-macos-x86_64`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 18.5Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.4Mb
#>       libs  14.6Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-release-windows-x86_64`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 10.3Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.4Mb
#>       libs   6.4Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-oldrel-macos-arm64`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 19.9Mb
#>     sub-directories of 1Mb or more:
#>       R      2.0Mb
#>       help   1.4Mb
#>       libs  15.4Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-oldrel-macos-x86_64`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 18.5Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.4Mb
#>       libs  14.6Mb
#> 
#> 0 errors ✔ | 0 warnings ✔ | 1 note ✖
#> 
#> $`r-oldrel-windows-ix86+x86_64`
#> ── R CMD check results ─────────────────────────────────────── igraph 1.4.1 ────
#> Duration: 0ms
#> 
#> ❯ checking installed package size ... NOTE
#>     installed size is 17.2Mb
#>     sub-directories of 1Mb or more:
#>       R      1.4Mb
#>       help   1.4Mb
#>       libs  13.4Mb
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
#> ── R CMD check comparison ──────────────────── rcmdcheck 1.4.0 / 1.4.0.9000 ────
#> Status: OK
```

### Background processes

`rcmdcheck_process` is a `processx::process` class, that can run
`R CMD check` in the background. You can also use this to run multiple
checks concurrently. `processx::process` methods can be used to poll or
manipulate the check processes.

``` r
chkpx <- rcmdcheck_process$new()
chkpx
#> PROCESS 'R', running, pid 25919.
```

``` r
chkpx$wait()
chkpx$parse_results()
#> ── R CMD check results ─────────────────────────────── rcmdcheck 1.4.0.9000 ────
#> Duration: 16.8s
#> 
#> 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
