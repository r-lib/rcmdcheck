# install log is captured [plain]

    Code
      print(check)
    Output
      -- R CMD check results ----------------------------------- RSQLServer 0.3.0 ----
      Duration: 0ms
      
      > checking whether package `RSQLServer' can be installed ... ERROR
        See below...
      
      -- Install failure -------------------------------------------------------------
      
      * installing *source* package `RSQLServer' ...
      ** package `RSQLServer' successfully unpacked and MD5 sums checked
      ** R
      ** inst
      ** preparing package for lazy loading
      Error : .onLoad failed in loadNamespace() for 'rJava', details:
        call: dyn.load(file, DLLpath = DLLpath, ...)
        error: unable to load shared object '/Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so':
        dlopen(/Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so, 6): Library not loaded: @rpath/libjvm.dylib
        Referenced from: /Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so
        Reason: image not found
      ERROR: lazy loading failed for package `RSQLServer'
      * removing `/Users/hadley/Documents/dplyr/dbplyr/revdep/checks/RSQLServer/new/RSQLServer.Rcheck/RSQLServer'
      
      1 error x | 0 warnings v | 0 notes v

# install log is captured [ansi]

    Code
      print(check)
    Output
      [36m-- R CMD check results ----------------------------------- RSQLServer 0.3.0 ----[39m
      Duration: 0ms
      
      [31m> checking whether package `RSQLServer' can be installed ... ERROR[39m
        See below...
      
      [36m-- Install failure -------------------------------------------------------------[39m
      
      * installing *source* package `RSQLServer' ...
      ** package `RSQLServer' successfully unpacked and MD5 sums checked
      ** R
      ** inst
      ** preparing package for lazy loading
      Error : .onLoad failed in loadNamespace() for 'rJava', details:
        call: dyn.load(file, DLLpath = DLLpath, ...)
        error: unable to load shared object '/Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so':
        dlopen(/Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so, 6): Library not loaded: @rpath/libjvm.dylib
        Referenced from: /Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so
        Reason: image not found
      ERROR: lazy loading failed for package `RSQLServer'
      * removing `/Users/hadley/Documents/dplyr/dbplyr/revdep/checks/RSQLServer/new/RSQLServer.Rcheck/RSQLServer'
      
      [31m1 error x[39m | [32m0 warnings v[39m | [32m0 notes v[39m

# install log is captured [unicode]

    Code
      print(check)
    Output
      ── R CMD check results ─────────────────────────────────── RSQLServer 0.3.0 ────
      Duration: 0ms
      
      ❯ checking whether package `RSQLServer' can be installed ... ERROR
        See below...
      
      ── Install failure ─────────────────────────────────────────────────────────────
      
      * installing *source* package `RSQLServer' ...
      ** package `RSQLServer' successfully unpacked and MD5 sums checked
      ** R
      ** inst
      ** preparing package for lazy loading
      Error : .onLoad failed in loadNamespace() for 'rJava', details:
        call: dyn.load(file, DLLpath = DLLpath, ...)
        error: unable to load shared object '/Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so':
        dlopen(/Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so, 6): Library not loaded: @rpath/libjvm.dylib
        Referenced from: /Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so
        Reason: image not found
      ERROR: lazy loading failed for package `RSQLServer'
      * removing `/Users/hadley/Documents/dplyr/dbplyr/revdep/checks/RSQLServer/new/RSQLServer.Rcheck/RSQLServer'
      
      1 error ✖ | 0 warnings ✔ | 0 notes ✔

# install log is captured [fancy]

    Code
      print(check)
    Output
      [36m── R CMD check results ─────────────────────────────────── RSQLServer 0.3.0 ────[39m
      Duration: 0ms
      
      [31m❯ checking whether package `RSQLServer' can be installed ... ERROR[39m
        See below...
      
      [36m── Install failure ─────────────────────────────────────────────────────────────[39m
      
      * installing *source* package `RSQLServer' ...
      ** package `RSQLServer' successfully unpacked and MD5 sums checked
      ** R
      ** inst
      ** preparing package for lazy loading
      Error : .onLoad failed in loadNamespace() for 'rJava', details:
        call: dyn.load(file, DLLpath = DLLpath, ...)
        error: unable to load shared object '/Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so':
        dlopen(/Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so, 6): Library not loaded: @rpath/libjvm.dylib
        Referenced from: /Users/hadley/Documents/dplyr/dbplyr/revdep/library/RSQLServer/rJava/libs/rJava.so
        Reason: image not found
      ERROR: lazy loading failed for package `RSQLServer'
      * removing `/Users/hadley/Documents/dplyr/dbplyr/revdep/checks/RSQLServer/new/RSQLServer.Rcheck/RSQLServer'
      
      [31m1 error ✖[39m | [32m0 warnings ✔[39m | [32m0 notes ✔[39m

# test failures are captured [plain]

    Code
      print(check)
    Output
      -- R CMD check results ---------------------------- dataonderivatives 0.3.0 ----
      Duration: 0ms
      
      > checking tests ... ERROR
        See below...
      
      > checking dependencies in R code ... NOTE
        Namespace in Imports field not imported from: ‘stats’
          All declared Imports should be used.
      
      -- Test failures ------------------------------------------------- testthat ----
      
      > library(testthat)
      > library(dataonderivatives)
      > 
      > test_check("dataonderivatives")
      1. Failure: BSDR API accessible (@test-bsdr.R#6) --------------------------------
      `df1` inherits from `NULL` not `data.frame`.
      
      
      2. Failure: BSDR API accessible (@test-bsdr.R#8) --------------------------------
      `df2` inherits from `NULL` not `data.frame`.
      
      
      3. Failure: BSDR API accessible (@test-bsdr.R#9) --------------------------------
      nrow(df1) <= nrow(df2) isn't true.
      
      
      4. Failure: CME SDR file parses (@test-cme.R#22) -------------------------------
      nrow(cme(lubridate::ymd(20161213), "FX")) > 0 isn't true.
      
      
      testthat results ================================================================
      OK: 23 SKIPPED: 0 FAILED: 4
      1. Failure: BSDR API accessible (@test-bsdr.R#6) 
      2. Failure: BSDR API accessible (@test-bsdr.R#8) 
      3. Failure: BSDR API accessible (@test-bsdr.R#9) 
      4. Failure: CME SDR file parses (@test-cme.R#22) 
      
      Error: testthat unit tests failed
      Execution halted
      
      1 error x | 0 warnings v | 1 note x

# test failures are captured [ansi]

    Code
      print(check)
    Output
      [36m-- R CMD check results ---------------------------- dataonderivatives 0.3.0 ----[39m
      Duration: 0ms
      
      [31m> checking tests ... ERROR[39m
        See below...
      
      [34m> checking dependencies in R code ... NOTE[39m
        Namespace in Imports field not imported from: ‘stats’
          All declared Imports should be used.
      
      [36m-- Test failures ------------------------------------------------- testthat ----[39m
      
      > library(testthat)
      > library(dataonderivatives)
      > 
      > test_check("dataonderivatives")
      1. Failure: BSDR API accessible (@test-bsdr.R#6) --------------------------------
      `df1` inherits from `NULL` not `data.frame`.
      
      
      2. Failure: BSDR API accessible (@test-bsdr.R#8) --------------------------------
      `df2` inherits from `NULL` not `data.frame`.
      
      
      3. Failure: BSDR API accessible (@test-bsdr.R#9) --------------------------------
      nrow(df1) <= nrow(df2) isn't true.
      
      
      4. Failure: CME SDR file parses (@test-cme.R#22) -------------------------------
      nrow(cme(lubridate::ymd(20161213), "FX")) > 0 isn't true.
      
      
      testthat results ================================================================
      OK: 23 SKIPPED: 0 FAILED: 4
      1. Failure: BSDR API accessible (@test-bsdr.R#6) 
      2. Failure: BSDR API accessible (@test-bsdr.R#8) 
      3. Failure: BSDR API accessible (@test-bsdr.R#9) 
      4. Failure: CME SDR file parses (@test-cme.R#22) 
      
      Error: testthat unit tests failed
      Execution halted
      
      [31m1 error x[39m | [32m0 warnings v[39m | [31m1 note x[39m

# test failures are captured [unicode]

    Code
      print(check)
    Output
      ── R CMD check results ──────────────────────────── dataonderivatives 0.3.0 ────
      Duration: 0ms
      
      ❯ checking tests ... ERROR
        See below...
      
      ❯ checking dependencies in R code ... NOTE
        Namespace in Imports field not imported from: ‘stats’
          All declared Imports should be used.
      
      ── Test failures ───────────────────────────────────────────────── testthat ────
      
      > library(testthat)
      > library(dataonderivatives)
      > 
      > test_check("dataonderivatives")
      1. Failure: BSDR API accessible (@test-bsdr.R#6) --------------------------------
      `df1` inherits from `NULL` not `data.frame`.
      
      
      2. Failure: BSDR API accessible (@test-bsdr.R#8) --------------------------------
      `df2` inherits from `NULL` not `data.frame`.
      
      
      3. Failure: BSDR API accessible (@test-bsdr.R#9) --------------------------------
      nrow(df1) <= nrow(df2) isn't true.
      
      
      4. Failure: CME SDR file parses (@test-cme.R#22) -------------------------------
      nrow(cme(lubridate::ymd(20161213), "FX")) > 0 isn't true.
      
      
      testthat results ================================================================
      OK: 23 SKIPPED: 0 FAILED: 4
      1. Failure: BSDR API accessible (@test-bsdr.R#6) 
      2. Failure: BSDR API accessible (@test-bsdr.R#8) 
      3. Failure: BSDR API accessible (@test-bsdr.R#9) 
      4. Failure: CME SDR file parses (@test-cme.R#22) 
      
      Error: testthat unit tests failed
      Execution halted
      
      1 error ✖ | 0 warnings ✔ | 1 note ✖

# test failures are captured [fancy]

    Code
      print(check)
    Output
      [36m── R CMD check results ──────────────────────────── dataonderivatives 0.3.0 ────[39m
      Duration: 0ms
      
      [31m❯ checking tests ... ERROR[39m
        See below...
      
      [34m❯ checking dependencies in R code ... NOTE[39m
        Namespace in Imports field not imported from: ‘stats’
          All declared Imports should be used.
      
      [36m── Test failures ───────────────────────────────────────────────── testthat ────[39m
      
      > library(testthat)
      > library(dataonderivatives)
      > 
      > test_check("dataonderivatives")
      1. Failure: BSDR API accessible (@test-bsdr.R#6) --------------------------------
      `df1` inherits from `NULL` not `data.frame`.
      
      
      2. Failure: BSDR API accessible (@test-bsdr.R#8) --------------------------------
      `df2` inherits from `NULL` not `data.frame`.
      
      
      3. Failure: BSDR API accessible (@test-bsdr.R#9) --------------------------------
      nrow(df1) <= nrow(df2) isn't true.
      
      
      4. Failure: CME SDR file parses (@test-cme.R#22) -------------------------------
      nrow(cme(lubridate::ymd(20161213), "FX")) > 0 isn't true.
      
      
      testthat results ================================================================
      OK: 23 SKIPPED: 0 FAILED: 4
      1. Failure: BSDR API accessible (@test-bsdr.R#6) 
      2. Failure: BSDR API accessible (@test-bsdr.R#8) 
      3. Failure: BSDR API accessible (@test-bsdr.R#9) 
      4. Failure: CME SDR file parses (@test-cme.R#22) 
      
      Error: testthat unit tests failed
      Execution halted
      
      [31m1 error ✖[39m | [32m0 warnings ✔[39m | [31m1 note ✖[39m

