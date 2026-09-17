# Open the check directory in a file browser window

Open the check directory in a file browser window

## Usage

``` r
# S3 method for class 'rcmdcheck'
xopen(target, app = NULL, quiet = FALSE, ...)
```

## Arguments

- target:

  [`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md)
  result.

- app:

  Specify the app to open `target` with, and its arguments, in a
  character vector. Note that app names are platform dependent.

- quiet:

  Whether to echo the command to the screen, before running it.

- ...:

  Additional arguments, not used currently.
