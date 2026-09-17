# Compare a check result to CRAN check results

Compare a check result to CRAN check results

## Usage

``` r
compare_to_cran(check, flavours = cran_check_flavours(check$package))
```

## Arguments

- check:

  A check result.

- flavours:

  CRAN check flavour(s) to use. By default all platforms are used.

## Value

An `rmdcheck_comparison` object.

## See also

Other check comparisons:
[`compare_checks()`](https://rcmdcheck.r-lib.org/dev/reference/compare_checks.md)
