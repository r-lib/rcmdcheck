# Print R CMD check result comparisons

See
[`compare_checks()`](https://rcmdcheck.r-lib.org/dev/reference/compare_checks.md)
and
[`compare_to_cran()`](https://rcmdcheck.r-lib.org/dev/reference/compare_to_cran.md).

## Usage

``` r
# S3 method for class 'rcmdcheck_comparison'
print(x, header = TRUE, ...)
```

## Arguments

- x:

  R CMD check result comparison object.

- header:

  Whether to print the header. You can suppress the header if you want
  to use the printout as part of another object's printout.

- ...:

  Additional arguments, currently ignored.
