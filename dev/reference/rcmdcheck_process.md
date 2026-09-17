# Run an `R CMD check` process in the background

rcmdcheck_process is an R6 class, that extends the
[callr::rcmd_process](https://callr.r-lib.org/reference/rcmd_process.html)
class (which in turn extends
[processx::process](http://processx.r-lib.org/reference/process.md).

## Usage

    cp <- rcmdcheck_process$new(path = ".", args = character(),
             build_args = character(), check_dir = NULL,
             libpath = .libPaths(), repos = getOption("repos"))

    cp$parse_results()

Other methods are inherited from
[callr::rcmd_process](https://callr.r-lib.org/reference/rcmd_process.html)
and [processx::process](http://processx.r-lib.org/reference/process.md).

Note that you calling the `get_output_connection` and
`get_error_connection` method on this is not a good idea, because then
the stdout and/or stderr of the process will not be collected for
`parse_results()`.

You can still use the `read_output_lines()` and `read_error_lines()`
methods to read the standard output and error, `parse_results()` is not
affected by that.

## Arguments

- `cp`: A new rcmdcheck_process object.

- `path`: Path to a package tree or a package archive file. This is the
  package to check.

- `args`: Command line arguments to `R CMD check`.

- `build_args`: Command line arguments to `R CMD build`.

- `check_dir`: Directory for the results.

- `libpath`: The library path to set for the check.

- `repos`: The `repos` option to set for the check. This is needed for
  cyclic dependency checks if you use the `--as-cran` argument. The
  default uses the current value.

- `env`: A named character vector, extra environment variables to set in
  the check process.

## Details

Most methods are inherited from
[callr::rcmd_process](https://callr.r-lib.org/reference/rcmd_process.html)
and [processx::process](http://processx.r-lib.org/reference/process.md).

`cp$parse_results()` parses the results, and returns an S3 object with
fields `errors`, `warnnigs` and `notes`, just like
[`rcmdcheck()`](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck.md).
It is an error to call it before the process has finished. Use the
`wait()` method to wait for the check to finish, or the `is_alive()`
method to check if it is still running.
