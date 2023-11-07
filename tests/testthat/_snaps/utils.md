# as_flag

    Code
      as_flag("boo", FALSE)
    Condition
      Warning in `as_flag()`:
      Invalid option value: `boo`, must be TRUE or FALSE
    Output
      [1] FALSE

---

    Code
      as_flag("boo", TRUE, "thisthat")
    Condition
      Warning in `as_flag()`:
      Invalid `thisthat` option value: `boo`, must be TRUE or FALSE
    Output
      [1] TRUE

