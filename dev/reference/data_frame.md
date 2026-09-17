# Alternative to data.frame

- Sets stringsAsFactors to FALSE by default

- If any columns have zero length, the result will have zero rows.

- If a column is a scalar, then it will be recycled.

- Non-matching number of rows gives an error, except for lengths zero
  and one.

## Usage

``` r
data_frame(..., stringsAsFactors = FALSE)
```

## Arguments

- ...:

  Named data frame columns, or data frames.

- stringsAsFactors:

  Just leave it on `FALSE`. `:)`

## Value

Data frame.
