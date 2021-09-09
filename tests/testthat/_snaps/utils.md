# as_flag

    Code
      as_flag("boo", FALSE)
    Warning <simpleWarning>
      Invalid option value: `boo`, must be TRUE or FALSE
    Output
      [1] FALSE

---

    Code
      as_flag("boo", TRUE, "thisthat")
    Warning <simpleWarning>
      Invalid `thisthat` option value: `boo`, must be TRUE or FALSE
    Output
      [1] TRUE

