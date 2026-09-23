# background gives same results

    Code
      bad1$read_error()
    Condition
      Error in `process_get_error_connection()`:
      ! ! stderr is not a pipe.

---

    Code
      bad1$read_all_error_lines()
    Condition
      Error in `process_get_error_connection()`:
      ! ! stderr is not a pipe.

# build arguments

    Code
      check_bad1_verbose()
    Output
      -- R CMD build -----------------------------------------------------------------
      R add-on package builder: <rvesion> (r<commit>)
      Copyright (C) 1997-<year> The R Core Team.
      This is free software; see the GNU General Public License version 2
      or later for copying conditions.  There is NO warranty.
    Condition
      Error in `if (!is.null(cmd) && substring(cmd, 1, 1) != "!") ...`:
      ! missing value where TRUE/FALSE needed

# check_dir argument

    Code
      rcmdcheck(test_path("fixtures/badpackage_1.0.0.tar.gz"), check_dir = tmp)
    Condition
      Error in `do_check()`:
      ! enough

