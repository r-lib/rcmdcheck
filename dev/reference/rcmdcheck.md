# Run R CMD check from R and Capture Results

Run R CMD check from R programmatically, and capture the results of the
individual checks.

Runs `R CMD check` as an external command, and parses its output and
returns the check failures.

## Usage

``` r
rcmdcheck(
  path = ".",
  quiet = FALSE,
  args = character(),
  build_args = character(),
  check_dir = NULL,
  libpath = .libPaths(),
  repos = getOption("repos"),
  timeout = Inf,
  error_on = Sys.getenv("RCMDCHECK_ERROR_ON", c("never", "error", "warning", "note")[1]),
  env = character()
)
```

## Arguments

- path:

  Path to a package tarball or a directory.

- quiet:

  Whether to print check output during checking.

- args:

  Character vector of arguments to pass to `R CMD check`. Pass each
  argument as a single element of this character vector (do not use
  spaces to delimit arguments like you would in the shell). For example,
  to skip running of examples and tests, use
  `args = c("--no-examples", "--no-tests")` and not
  `args = "--no-examples --no-tests"`. (Note that instead of the
  `--output` option you should use the `check_dir` argument, because
  `--output` cannot deal with spaces and other special characters on
  Windows.)

- build_args:

  Character vector of arguments to pass to `R CMD build`. Pass each
  argument as a single element of this character vector (do not use
  spaces to delimit arguments like you would in the shell). For example,
  `build_args = c("--force", "--keep-empty-dirs")` is a correct usage
  and `build_args = "--force --keep-empty-dirs"` is incorrect.

- check_dir:

  Path to a directory where the check will be performed. The path will
  be created if needed and is reported in the `checkdir` field of the
  object returned by `rcmdcheck()`.

  If `check_dir = NULL` (the default), the check is performed in a
  temporary directory that is automatically cleaned up when the object
  returned by `rcmdcheck()` is deleted.

- libpath:

  The library path to set for the check. The default uses the current
  library path.

- repos:

  The `repos` option to set for the check. This is needed for cyclic
  dependency checks if you use the `--as-cran` argument. The default
  uses the current value.

- timeout:

  Timeout for the check, in seconds, or as a
  [base::difftime](https://rdrr.io/r/base/difftime.html) object. If it
  is not finished before this, it will be killed. `Inf` means no
  timeout. If the check is timed out, that is added as an extra error to
  the result object.

- error_on:

  Whether to throw an error on `R CMD check` failures. Note that the
  check is always completed (unless a timeout happens), and the error is
  only thrown after completion. If `"never"`, then no errors are thrown.
  If `"error"`, then only `ERROR` failures generate errors. If
  `"warning"`, then `WARNING` failures generate errors as well. If
  `"note"`, then any check failure generated an error. Its default can
  be modified with the `RCMDCHECK_ERROR_ON` environment variable. If
  that is not set, then `"never"` is used.

- env:

  A named character vector, extra environment variables to set in the
  check process.

## Value

An S3 object (list) with fields `errors`, `warnings` and `notes`. These
are all character vectors containing the output for the failed check.

## Details

See
[rcmdcheck_process](https://rcmdcheck.r-lib.org/dev/reference/rcmdcheck_process.md)
if you need to run `R CMD check` in a background process.

## Turning off package checks

Sometimes it is useful to programmatically turn off some checks that may
report check NOTEs. rcmdcheck provides two ways to do this.

First, you may declare in `DESCRIPTION` that you don't want to see NOTEs
that are accepted on CRAN, with this entry:

    Config/rcmdcheck/ignore-inconsequential-notes: true

Currently, this will make rcmdcheck ignore the following notes:

- report large package sizes (`_R_CHECK_PKG_SIZES_ = FALSE`),

- check cross-references in Rd files (`_R_CHECK_RD_XREFS_ = FALSE`),

- NOTE if package requires GNU make
  (`_R_CHECK_CRAN_INCOMING_NOTE_GNU_MAKE_ = FALSE`),

- report marked non-ASCII strings in datasets
  (`_R_CHECK_PACKAGE_DATASETS_SUPPRESS_NOTES_ = TRUE`).

The second way is more flexible, and lets you turn off individual checks
via setting environment variables. You may provide a `tools/check.env`
*environment file* in your package with the list of environment variable
settings that rcmdcheck will automatically use when checking the
package. See [Startup](https://rdrr.io/r/base/Startup.html) for the
format of this file.

Here is an example `tools/check.env` file:

    # Report if package size is larger than 10 megabytes
    _R_CHECK_PKG_SIZES_THRESHOLD_=10

    # Do not check Rd cross references
    _R_CHECK_RD_XREFS_=false

    # Do not report if package requires GNU make
    _R_CHECK_CRAN_INCOMING_NOTE_GNU_MAKE_=false

    # Do not check non-ASCII strings in datasets
    _R_CHECK_PACKAGE_DATASETS_SUPPRESS_NOTES_=true

See the ["R internals"
manual](https://cran.r-project.org/doc/manuals/r-devel/R-ints.html) and
the [R source code](https://github.com/wch/r-source) for the environment
variables that control the checks.

Note that `Config/rcmdcheck/ignore-inconsequential-notes` and the
`check.env` file are only supported by rcmdcheck, and running
`R CMD check` from a shell (or GUI) will not use them.
