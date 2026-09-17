# Print R CMD check results

Print R CMD check results

## Usage

``` r
# S3 method for class 'rcmdcheck'
print(
  x,
  header = TRUE,
  test_output = getOption("rcmdcheck.test_output", FALSE),
  ...
)
```

## Arguments

- x:

  Check result object to print.

- header:

  Whether to print a header.

- test_output:

  if `TRUE`, include the test output in the results, if there are no
  test failures. If some tests fail, then only the failures are printed.

- ...:

  Additional arguments, currently ignored.
