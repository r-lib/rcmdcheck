# Download and parse R CMD check results from CRAN

Download and parse R CMD check results from CRAN

## Usage

``` r
cran_check_results(
  package,
  flavours = cran_check_flavours(package),
  quiet = FALSE
)
```

## Arguments

- package:

  Name of a single package to download the checks for.

- flavours:

  CRAN check flavours to use. Defaults to all flavours that were used to
  check the package.

- quiet:

  Whether to omit the download progress bars.

## Value

A list of `rcmdcheck` objects.
