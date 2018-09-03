library(testthat)
library(badpackage)

sink("/tmp/out2")
print(Sys.getenv())
sink(NULL)

test_check("badpackage")
