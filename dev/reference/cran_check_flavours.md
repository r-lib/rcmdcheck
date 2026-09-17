# Download and show all CRAN check flavour platforms

If the `package` argument is `NULL`, then all current platforms are
downloaded. If the `package` argument is specified, then all flavours
used for the latest package checks for that package, are downloaded and
returned.

## Usage

``` r
cran_check_flavours(package = NULL)
```

## Arguments

- package:

  CRAN package name or `NULL`.

## Value

Character vector of platform ids.

## Examples

``` r
if (FALSE) { # \dontrun{
cran_check_flavours()
cran_check_flavours("simplegraph")
} # }
```
