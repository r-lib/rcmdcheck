
# Wrapper because from edition 3 'class' must be a scalar

expect_error_classes <- function(expr, class) {
  err <- tryCatch(expr, error = function(e) e)
  for (c in class) {
    expect_s3_class(err, c)
  }
}

cran_app <- function() {
  app <- webfakes::new_app()
  app$get(
    list(
      webfakes::new_regexp("/nosvn/R.check/(?<flavour>[-.a-zA-Z0-9_+]+)/(?<name>[-.a-zA-Z0-9_]+)$"),
      webfakes::new_regexp("/web/checks/(?<name>[-.a-zA-Z0-9_+]+)$")
    ),
    function(req, res) {
      flavour <- req$params$flavour
      if (is.null(flavour)) flavour <- ""
      path <- testthat::test_path("fixtures", "checks", flavour, req$params$name)
      if (file.exists(path)) {
        res$send_file(path)
      } else {
        res$send_status(404)
      }
    }
  )

  app
}
