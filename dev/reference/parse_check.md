# Parse `R CMD check` results from a file or string

At most one of `file` or `text` can be given. If both are `NULL`, then
the current working directory is checked for a `00check.log` file.

## Usage

``` r
parse_check(file = NULL, text = NULL, ...)
```

## Arguments

- file:

  The `00check.log` file, or a directory that contains that file. It can
  also be a connection object.

- text:

  The contents of a `00check.log` file.

- ...:

  Other arguments passed onto the constructor. Used for testing.

## Value

An `rcmdcheck` object, the check results.

## See also

[`parse_check_url`](https://rcmdcheck.r-lib.org/dev/reference/parse_check_url.md)
