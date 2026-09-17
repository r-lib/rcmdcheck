# Shorthand to parse R CMD check results from a URL

Shorthand to parse R CMD check results from a URL

## Usage

``` r
parse_check_url(url, quiet = FALSE)
```

## Arguments

- url:

  URL to parse the results from. Note that it should not contain HTML
  markup, just the text output.

- quiet:

  Passed to `download.file`.

## Value

An `rcmdcheck` object, the check results.

## See also

[`parse_check`](https://rcmdcheck.r-lib.org/dev/reference/parse_check.md)
