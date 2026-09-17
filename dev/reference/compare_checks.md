# Compare a set of check results to another check result

Compare a set of check results to another check result

## Usage

``` r
compare_checks(old, new)
```

## Arguments

- old:

  A check result, or a list of check results.

- new:

  A check result.

## Value

An `rcmdcheck_comparison` object with fields:

- `package`: the name of the package, string,

- `versions`: package versions, length two character,

- `status`: comparison status, see below,

- `old`: list of `rcmdcheck` objects the old check(s),

- `new`: `rcmdcheck` object, the new check,

- `cmp`:

## See also

Other check comparisons:
[`compare_to_cran()`](https://rcmdcheck.r-lib.org/dev/reference/compare_to_cran.md)
