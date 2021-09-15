# block_callback by line

    Code
      for (line in chk) cb(paste0(line, "\n"))
    Output
        -  using log directory ‘/tmp/RtmpoYWa4I/file31fc5a857856/mlr.Rcheck’
        -  using R version 3.5.0 (2017-01-27)
        -  using platform: x86_64-pc-linux-gnu (64-bit)
        -  using session charset: UTF-8
        v  checking for file ‘mlr/DESCRIPTION’
        -  this is package ‘mlr’ version ‘2.13’
        -  package encoding: UTF-8
        v  checking package namespace information
        N  checking package dependencies
           Package suggested but not available for checking: ‘elmNN’
        v  checking if this is a source package
        v  checking if there is a namespace
        v  checking for executable files
        v  checking for hidden files and directories
        v  checking for portable file names
        v  checking for sufficient/correct file permissions
        -  checking whether package ‘mlr’ can be installed ... [22s/22s] OK
        N  checking installed package size
             installed size is  6.5Mb
             sub-directories of 1Mb or more:
               data   3.3Mb
               R      2.0Mb
        v  checking package directory
        v  checking ‘build’ directory
        v  checking DESCRIPTION meta-information
        v  checking top-level files
        v  checking for left-over files
        v  checking index information
        v  checking package subdirectories
        v  checking R files for non-ASCII characters
        v  checking R files for syntax errors
        v  checking whether the package can be loaded
        v  checking whether the package can be loaded with stated dependencies
        v  checking whether the package can be unloaded cleanly
        v  checking whether the namespace can be loaded with stated dependencies
        v  checking whether the namespace can be unloaded cleanly
        v  checking loading without being on the library search path
        N  checking dependencies in R code
           Picked up _JAVA_OPTIONS: -Xmx2048m -Xms512m
        v  checking S3 generic/method consistency
        v  checking replacement functions
        v  checking foreign function calls
        -  checking R code for possible problems ... [34s/34s] OK
        v  checking Rd files
        v  checking Rd metadata
        v  checking Rd cross-references
        v  checking for missing documentation entries
        v  checking for code/documentation mismatches
        v  checking Rd \usage sections
        v  checking Rd contents
        v  checking for unstated dependencies in examples
        v  checking contents of ‘data’ directory
        v  checking data for non-ASCII characters
        v  checking data for ASCII and uncompressed saves
        v  checking line endings in C/C++/Fortran sources/headers
        v  checking compiled code
        v  checking installed files from ‘inst/doc’
        v  checking files in ‘vignettes’
        -  checking examples ... [18s/28s] OK
        v  checking for unstated dependencies in ‘tests’
        -  checking tests
             Running the tests in ‘tests/run-classif1.R’ failed.
           Last 999 lines of output:
             
             burning and aggregating chains from all threads... done
             building BART with mem-cache speedup...
             done building BART in 0.013 sec 
             
             burning and aggregating chains from all threads... done
             building BART with mem-cache speedup...
             Iteration 100/1250
             Iteration 200/1250
             Iteration 300/1250
             Iteration 400/1250
             Iteration 500/1250
             Iteration 600/1250
             Iteration 700/1250
             Iteration 800/1250
             Iteration 900/1250
             Iteration 1000/1250
             Iteration 1100/1250
             Iteration 1200/1250
             done building BART in 0.551 sec 
             
             burning and aggregating chains from all threads... done
             building BART with mem-cache speedup...
             done building BART in 0.028 sec 
             
             burning and aggregating chains from all threads... done
             building BART with mem-cache speedup...
             done building BART in 0.014 sec 
             
             burning and aggregating chains from all threads... done
             ── 1. Error: classif_blackboost (@test_classif_blackboost.R#32)  ───────────────
             no method for assigning subsets of this S4 class
             1: do.call(mboost::blackboost, pars) at testthat/test_classif_blackboost.R:32
             2: (function (formula, data = list(), weights = NULL, na.action = na.pass, offset = NULL, 
                    family = Gaussian(), control = boost_control(), oobweights = NULL, tree_controls = partykit::ctree_control(teststat = "quad", 
                        testtype = "Teststatistic", mincriterion = 0, minsplit = 10, minbucket = 4, 
                        maxdepth = 2, saveinfo = FALSE), ...) 
                {
                    cl <- match.call()
                    mf <- match.call(expand.dots = FALSE)
                    m <- match(c("formula", "data", "weights", "na.action"), names(mf), 0L)
                    mf <- mf[c(1L, m)]
                    mf$drop.unused.levels <- TRUE
                    mf[[1L]] <- quote(stats::model.frame)
                    mf <- eval(mf, parent.frame())
                    response <- model.response(mf)
                    weights <- model.weights(mf)
                    mf <- mf[, -1, drop = FALSE]
                    mf$"(weights)" <- NULL
                    bl <- list(btree(mf, tree_controls = tree_controls))
                    ret <- mboost_fit(bl, response = response, weights = weights, offset = offset, 
                        family = family, control = control, oobweights = oobweights, ...)
                    ret$call <- cl
             Error: testthat unit tests failed
             Execution halted
        v  checking for unstated dependencies in vignettes
        v  checking package vignettes in ‘inst/doc’
        -  checking running R code from vignettes
              ‘mlr.Rmd’ using ‘UTF-8’ ... [0s/0s] OK
            NONE
        -  checking re-building of vignette outputs ... [3s/4s] OK
        v  checking PDF version of manual
          

# block_callback by chunks

    Code
      for (ch in chunks) cb(ch)
    Output
        -  using log directory ‘/tmp/RtmpoYWa4I/file31fc5a857856/mlr.Rcheck’
      -  using R version 3.5.0 (2017-01-27)
      -  using platform: x86_64-pc-linux-gnu (64-bit)
      -  using session charset: UTF-8
      v  checking for file ‘mlr/DESCRIPTION’
      -  this is package ‘mlr’ version ‘2.13’
      -  package encoding: UTF-8
      v  checking package namespace information
      N  checking package dependencies
         Package suggested but not available for checking: ‘elmNN’
      v  checking if this is a source package
      v  checking if there is a namespace
      v  checking for executable files
      v  checking for hidden files and directories
      v  checking for portable file names
      v  checking for sufficient/correct file permissions
      -  checking whether package ‘mlr’ can be installed ... [22s/22s] OK
      N  checking installed package size
           installed size is  6.5Mb
           sub-directories of 1Mb or more:
             data   3.3Mb
             R      2.0Mb
      v  checking package directory
      v  checking ‘build’ directory
      v  checking DESCRIPTION meta-information
      v  checking top-level files
      v  checking for left-over files
      v  checking index information
      v  checking package subdirectories
      v  checking R files for non-ASCII characters
      v  checking R files for syntax errors
      v  checking whether the package can be loaded
      v  checking whether the package can be loaded with stated dependencies
      v  checking whether the package can be unloaded cleanly
      v  checking whether the namespace can be loaded with stated dependencies
      v  checking whether the namespace can be unloaded cleanly
      v  checking loading without being on the library search path
         chec  N  checking dependencies in R code
      Picked up _JAVA_OPTI     Picked up _JAVA_OPTIONS: -Xmx2048m -Xms512m
      v  checking S3 generic/method consistency
      v  checking replacement functions
         checking foreign func  v  checking foreign function calls
      -  checking R code for possible problems ... [34s/34s] OK
         checking Rd files ... O  v  checking Rd files
      v  checking Rd metadata
      v  checking Rd cross-references
      v  checking for missing documentation entries
      v  checking for code/documentation mismatches
      v  checking Rd \usage sections
      v  checking Rd contents
      v  checking for unstated dependencies in examples
      v  checking contents of ‘data’ directory
      v  checking data for non-ASCII characters
      v  checking data for ASCII and uncompressed saves
         checking line endings in C/C++/Fortran s  v  checking line endings in C/C++/Fortran sources/headers
         checking compiled code ... OK  v  checking compiled code
      v  checking installed files from ‘inst/doc’
      v  checking files in ‘vignettes’
      -  checking examples ... [18s/28s] OK
      v  checking for unstated dependencies in ‘tests’
      -  checking tests
      Running the tests in ‘t     Running the tests in ‘tests/run-classif1.R’ failed.
         Last 999 lines of output:
           
                burning and aggregating chains from all threads... done
           building BART with mem-cache speedup...
           done building BART in 0.013 sec 
           
           burning and aggregating chains from all threads... done
         building       building BART with mem-cache speedup...
           Iteration 100/1250
           Iteration 200/1250
           Iteration 300/1250
           Iteration 400/1250
         Iteration 5       Iteration 500/1250
           Iteration 600/1250
         Iterat       Iteration 700/1250
           Iteration 800/1250
           Iteration 900/1250
           Iteration 1000/1250
           Iteration 1100/1250
           Iteration 1200/1250
           done building BART in 0.551 sec 
           
         burning and aggregating ch       burning and aggregating chains from all threads... done
           building BART with mem-cache speedup...
           done building BART in 0.028 sec 
           
           burning and aggregating chains from all threads... done
           building BART with mem-cache speedup...
         done building B       done building BART in 0.014 sec 
           
           burning and aggregating chains from all threads... done
           ── 1. Error: classif_blackboost (@test_classif_blackboost.R#32)  ───────────────
           no method for assigning subsets of this S4 class
         1: do.call(mboost::blackboost, pars)       1: do.call(mboost::blackboost, pars) at testthat/test_classif_blackboost.R:32
           2: (function (formula, data = list(), weights = NULL, na.action = na.pass, offset = NULL, 
                  family = Gaussian(), control = boost_control(), oobweights = NULL, tree_controls = partykit::ctree_control(teststat = "quad", 
                      testtype = "Teststatistic", mincriterion = 0, minsplit = 10, minbucket = 4, 
                      maxdepth = 2, saveinfo = FALSE), ...) 
              {
                cl <- ma              cl <- match.call()
                  mf <- match.call(expand.dots = FALSE)
                  m <- match(c("formula", "data", "weights", "na.action"), names(mf), 0L)
                  mf <- mf[c(1L, m)]
                mf$drop.unu              mf$drop.unused.levels <- TRUE
                  mf[[1L]] <- quote(stats::model.frame)
                  mf <- eval(mf, parent.frame())
                  response <- model.response(mf)
                  weights <- model.weights(mf)
                  mf <- mf[, -1, drop = FALSE]
                  mf$"(weights)" <- NULL
                bl <- list(btree(mf, tree_controls               bl <- list(btree(mf, tree_controls = tree_controls))
                re              ret <- mboost_fit(bl, response = response, weights = weights, offset = offset, 
                      family = family, control = control, oobweights = oobweights, ...)
                ret$call               ret$call <- cl
           Error: testthat unit tests failed
           Execution halted
      v  checking for unstated dependencies in vignettes
      v  checking package vignettes in ‘inst/doc’
      -  checking running R code from vignettes
            ‘mlr.Rmd’ using ‘UTF-8’ ... [0s/0s] OK
          NONE
      -  checking re-building of vignette outputs ... [3s/4s] OK
         checking PDF vers  v  checking PDF version of manual
      

# notes, errors, warnings

    Code
      for (line in out) cb(line)
    Output
        N  Step one
            More note text.
        W  Step two
            More warning text.
        E  Step three
            More error text.
      

# tests

    Code
      for (line in txt) cb(paste0(line, "\n"))
    Output
        v  checking for unstated dependencies in 'tests'
        E  checking tests
             Running 'testthat.R'
           Running the tests in 'tests/testthat.R' failed.
           Complete output:
             > library(testthat)
             > library(lpirfs)
             > 
             > test_check("lpirfs")
             Error in parse(con, n = -1, srcfile = srcfile, encoding = "UTF-8") : 
               test-diagnost_ols.R:19:8: unexpected $end
             18: 
             19: lm_modeÄ
                        ^
             Calls: test_check ... doWithOneRestart -> force -> lapply -> FUN -> source_file -> parse
             Execution halted
        v  checking for unstated dependencies in vignettes
      

# multi-arch tests

    Code
      for (line in txt) cb(paste0(line, "\n"))
    Output
        v  checking for unstated dependencies in 'tests'
        -  checking tests
        -- running tests for arch 'i386' ... [2s] ERROR      
             Running the tests in 'tests/testthat.R' failed.
           Complete output:
             > library("testthat")
             > library("GMSE")
             > 
             > test_check("GMSE")
        -- running tests for arch 'x64' ... [3s] OK      
             * checking for unstated dependencies in vignettes ... OK
      

# multiple test file run times are measured properly

    Code
      out
    Output
      [1] "  \r   checking examples ... \r  \rv  checking examples (5s)"                      
      [2] "\r  \rv  checking for unstated dependencies in ‘tests’    "                        
      [3] "\r  \r-  checking tests    "                                                       
      [4] "\r  \r   Running ‘first_edition.R’\r  \r\r  \rv  Running ‘first_edition.R’ (13.2s)"
      [5] "   Running ‘second_edition.R’\r  \r\r  \rv  Running ‘second_edition.R’ (14.3s)"    
      [6] "\r  \rv  checking for unstated dependencies in vignettes    "                      
      [7] "\r  \rv  checking package vignettes in ‘inst/doc’    "                             
      [8] "\r"                                                                                

