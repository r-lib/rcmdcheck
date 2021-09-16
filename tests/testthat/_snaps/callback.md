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
      [2] "\r  \rv  checking for unstated dependencies in ‘tests’"                            
      [3] "\r  \r-  checking tests"                                                           
      [4] "\r  \r   Running ‘first_edition.R’\r  \r\r  \rv  Running ‘first_edition.R’ (13.2s)"
      [5] "   Running ‘second_edition.R’\r  \r\r  \rv  Running ‘second_edition.R’ (14.3s)"    
      [6] "\r  \rv  checking for unstated dependencies in vignettes"                          
      [7] "\r  \rv  checking package vignettes in ‘inst/doc’"                                 
      [8] "\r"                                                                                

# multi-arch test cases

    Code
      out
    Output
       [1] "  \r-  using log directory 'C:/Users/csard/works/ps.Rcheck'"
       [2] "\r  \r-  using R version 4.1.1 (2021-08-10)"                
       [3] "\r  \r-  using platform: x86_64-w64-mingw32 (64-bit)"       
       [4] "\r  \r-  using session charset: ISO8859-1"                  
       [5] "\r  \rv  checking for file 'ps/DESCRIPTION'"                
       [6] "\r  \r-  this is package 'ps' version '1.3.2.9000'"         
       [7] "\r  \rv  checking for unstated dependencies in 'tests'"     
       [8] "\r  \r-  checking tests"                                    
       [9] "\r  \r-- running tests for arch 'i386'      "               
      [10] "\r  \r\r  \rv  Running 'testthat.R'"                        
      [11] "\r  \r-- running tests for arch 'x64'      "                
      [12] "\r  \r\r  \rv  Running 'testthat.R'"                        
      [13] "\r  \rv  checking PDF version of manual"                    
      [14] "\r  \r\r"                                                   

# failed test case

    Code
      out
    Output
       [1] "  \rv  checking for unstated dependencies in ‘tests’"                                       
       [2] "\r  \r-  checking tests"                                                                    
       [3] "\r  \r\r  \rE  Running ‘testthat.R’"                                                        
       [4] "\r  \r   Running the tests in ‘tests/testthat.R’ failed."                                   
       [5] "\r  \r   Last 13 lines of output:"                                                          
       [6] "\r  \r     ⠏ |   0       | windows                                                         "
       [7] "\r  \r     ⠏ |   0       | winver                                                          "
       [8] "\r  \r     ⠏ |   0       | winver                                                          "
       [9] "\r  \r     ✔ |   6       | winver"                                                          
      [10] "\r  \r     "                                                                                
      [11] "\r  \r     ══ Results ═════════════════════════════════════════════════════════════════════"
      [12] "\r  \r     Duration: 13.5 s"                                                                
      [13] "\r  \r     "                                                                                
      [14] "\r  \r     ── Skipped tests  ──────────────────────────────────────────────────────────────"
      [15] "\r  \r     • Needs working IPv6 connection (2)"                                             
      [16] "\r  \r     • On CRAN (13)"                                                                  
      [17] "\r  \r     "                                                                                
      [18] "\r  \r     [ FAIL 1 | WARN 0 | SKIP 15 | PASS 367 ]"                                        
      [19] "\r  \r     Error: Test failures"                                                            
      [20] "\r  \r     Execution halted"                                                                
      [21] "\r  \rv  checking PDF version of manual"                                                    
      [22] "\r  \r\r"                                                                                   

# comparing test output

    Code
      out
    Output
       [1] "  \rv  checking for unstated dependencies in ‘tests’"          
       [2] "\r  \r-  checking tests"                                       
       [3] "\r  \r\r  \rv  Running ‘first_edition.R’"                      
       [4] "\r  \rv  Running ‘second_edition.R’"                           
       [5] "\r  \rv  Running ‘spelling.R’"                                 
       [6] "X  Comparing ‘spelling.Rout’ to ‘spelling.Rout.save’"          
       [7] "   6,8d5"                                                      
       [8] "\r  \r   < Potential spelling errors:"                         
       [9] "\r  \r   <   WORD              FOUND IN"                       
      [10] "\r  \r   < programatically   NEWS.md:14"                       
      [11] "\r  \r\r  \rv  checking for unstated dependencies in vignettes"
      [12] "\r  \rv  checking package vignettes in ‘inst/doc’"             
      [13] "\r"                                                            

# partial comparing line

    Code
      out
    Output
      [1] "  \r-  checking tests"                                                               
      [2] "\r  \r\r  \rv  Running ‘test-1.R’"                                                   
      [3] "   Comparing ‘test-1.Rout’ to \r  \rv  Comparing ‘test-1.Rout’ to ‘test-1.Rout.save’"
      [4] "\r  \r\r  \rv  Running ‘test-2.R’"                                                   
      [5] "v  Comparing ‘test-2.Rout’ to ‘test-2.Rout.save’"                                    
      [6] "\r  \r\r  \rv  checking PDF version of manual"                                       
      [7] "\r  \r\r"                                                                            

# multiple comparing blocks

    Code
      out
    Output
       [1] "  \rv  checking examples"                                                                                                                                                    
       [2] "\r  \rv  checking for unstated dependencies in ‘tests’"                                                                                                                      
       [3] "\r  \r-  checking tests"                                                                                                                                                     
       [4] "\r  \r\r  \rv  Running ‘test-1.R’"                                                                                                                                           
       [5] "v  Comparing ‘test-1.Rout’ to ‘test-1.Rout.save’"                                                                                                                            
       [6] "\r  \r\r  \rv  Running ‘test-2.R’"                                                                                                                                           
       [7] "v  Comparing ‘test-2.Rout’ to ‘test-2.Rout.save’"                                                                                                                            
       [8] "\r  \r\r  \rv  Running ‘test.R’"                                                                                                                                             
       [9] "X  Comparing ‘test.Rout’ to ‘test.Rout.save’"                                                                                                                                
      [10] "   1,4d0"                                                                                                                                                                    
      [11] "\r  \r   <"                                                                                                                                                                  
      [12] "\r  \r   <"                                                                                                                                                                  
      [13] "\r  \r   < >"                                                                                                                                                                
      [14] "\r  \r   < > cat(\"This is the output.\\n\")"                                                                                                                                
      [15] "\r  \r   6d1"                                                                                                                                                                
      [16] "\r  \r   < >"                                                                                                                                                                
      [17] "\r  \r\r  \r   "                                                                                                                                                             
      [18] "\r  \rE"                                                                                                                                                                     
      [19] "\r  \r   Running the tests in ‘tests/testthat.R’ failed."                                                                                                                    
      [20] "\r  \r   Last 13 lines of output:"                                                                                                                                           
      [21] "\r  \r     +   ## ps does not support this platform"                                                                                                                         
      [22] "\r  \r     +   reporter <- \"progress\""                                                                                                                                     
      [23] "\r  \r     + }"                                                                                                                                                              
      [24] "\r  \r     >"                                                                                                                                                                
      [25] "\r  \r     > if (ps_is_supported()) test_check(\"ps\", reporter = reporter)"                                                                                                 
      [26] "\r  \r     cleanup-reporter:"                                                                                                                                                
      [27] "\r  \r     cleanup testthat reporter: ......................................................................................................................................"
      [28] "\r  \r     common:"                                                                                                                                                          
      [29] "\r  \r     common: ...................................................................................................................................................."     
      [30] "\r  \r     connections:"                                                                                                                                                     
      [31] "\r  \r     connections: ................................................................S............S............"                                                          
      [32] "\r  \r     finished:"                                                                                                                                                        
      [33] "\r  \r     process finished: ..................................................................................."                                                            
      [34] "\r  \r     kill-tree:"                                                                                                                                                       
      [35] "\r  \r     kill-tree: ..............................................."                                                                                                       
      [36] "\r  \rv  checking PDF version of manual"                                                                                                                                     
      [37] "\r"                                                                                                                                                                          

# simple_callback

    Code
      out
    Output
       [1] "* using log directory ‘/private/tmp/readr.Rcheck’"                             
       [2] "* using R version 4.1.0 (2021-05-18)"                                          
       [3] "* using platform: x86_64-apple-darwin17.0 (64-bit)"                            
       [4] "* using session charset: UTF-8"                                                
       [5] "* checking for file ‘readr/DESCRIPTION’ ... OK"                                
       [6] "* this is package ‘readr’ version ‘2.0.1.9000’"                                
       [7] "* package encoding: UTF-8"                                                     
       [8] "* checking package namespace information ... OK"                               
       [9] "* checking package dependencies ... OK"                                        
      [10] "* checking if this is a source package ... OK"                                 
      [11] "* checking if there is a namespace ... OK"                                     
      [12] "* checking for executable files ... OK"                                        
      [13] "* checking for hidden files and directories ... OK"                            
      [14] "* checking for portable file names ... OK"                                     
      [15] "* checking for sufficient/correct file permissions ... OK"                     
      [16] "* checking whether package ‘readr’ can be installed ... OK"                    
      [17] "* checking installed package size ... OK"                                      
      [18] "* checking package directory ... OK"                                           
      [19] "* checking ‘build’ directory ... OK"                                           
      [20] "* checking DESCRIPTION meta-information ... OK"                                
      [21] "* checking top-level files ... OK"                                             
      [22] "* checking for left-over files ... OK"                                         
      [23] "* checking index information ... OK"                                           
      [24] "* checking package subdirectories ... OK"                                      
      [25] "* checking R files for non-ASCII characters ... OK"                            
      [26] "* checking R files for syntax errors ... OK"                                   
      [27] "* checking whether the package can be loaded ... OK"                           
      [28] "* checking whether the package can be loaded with stated dependencies ... OK"  
      [29] "* checking whether the package can be unloaded cleanly ... OK"                 
      [30] "* checking whether the namespace can be loaded with stated dependencies ... OK"
      [31] "* checking whether the namespace can be unloaded cleanly ... OK"               
      [32] "* checking loading without being on the library search path ... OK"            
      [33] "* checking dependencies in R code ... OK"                                      
      [34] "* checking S3 generic/method consistency ... OK"                               
      [35] "* checking replacement functions ... OK"                                       
      [36] "* checking foreign function calls ... OK"                                      
      [37] "* checking R code for possible problems ... OK"                                
      [38] "* checking Rd files ... OK"                                                    
      [39] "* checking Rd metadata ... OK"                                                 
      [40] "* checking Rd cross-references ... OK"                                         
      [41] "* checking for missing documentation entries ... OK"                           
      [42] "* checking for code/documentation mismatches ... OK"                           
      [43] "* checking Rd \\usage sections ... OK"                                         
      [44] "* checking Rd contents ... OK"                                                 
      [45] "* checking for unstated dependencies in examples ... OK"                       
      [46] "* checking R/sysdata.rda ... OK"                                               
      [47] "* checking line endings in C/C++/Fortran sources/headers ... OK"               
      [48] "* checking compiled code ... OK"                                               
      [49] "* checking installed files from ‘inst/doc’ ... OK"                             
      [50] "* checking files in ‘vignettes’ ... OK"                                        
      [51] "* checking examples ... OK"                                                    
      [52] "* checking for unstated dependencies in ‘tests’ ... OK"                        
      [53] "* checking tests ..."                                                          
      [54] "  Running ‘first_edition.R’"                                                   
      [55] "  Running ‘second_edition.R’"                                                  
      [56] "  Running ‘spelling.R’"                                                        
      [57] "  Comparing ‘spelling.Rout’ to ‘spelling.Rout.save’ ...6,8d5"                  
      [58] "< Potential spelling errors:"                                                  
      [59] "<   WORD              FOUND IN"                                                
      [60] "< programatically   NEWS.md:14"                                                
      [61] " OK"                                                                           
      [62] "* checking for unstated dependencies in vignettes ... OK"                      
      [63] "* checking package vignettes in ‘inst/doc’ ... OK"                             
      [64] "* checking running R code from vignettes ..."                                  
      [65] "  ‘locales.Rmd’ using ‘UTF-8’... OK"                                           
      [66] "  ‘readr.Rmd’ using ‘UTF-8’... OK"                                             
      [67] " NONE"                                                                         
      [68] "* checking re-building of vignette outputs ... OK"                             
      [69] "* checking PDF version of manual ... OK"                                       
      [70] "* DONE"                                                                        
      [71] ""                                                                              
      [72] "Status: OK"                                                                    

