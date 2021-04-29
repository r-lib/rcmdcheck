# print message displays informative output [plain]

    Code
      print(summary(cf))
    Output
      x minimal 1.0.0                          -- E: 1-1   | W: 0  +1 | N: 0  +1

# print message displays informative output [ansi]

    Code
      print(summary(cf))
    Output
      [90m[31mx[90m minimal 1.0.0                          -- E: 1[32m-1[90m   | W: 0  [31m+1[90m | N: 0  [31m+1[90m[39m

# print message displays informative output [unicode]

    Code
      print(summary(cf))
    Output
      ✖ minimal 1.0.0                          ── E: 1-1   | W: 0  +1 | N: 0  +1

# print message displays informative output [fancy]

    Code
      print(summary(cf))
    Output
      [90m[31m✖[90m minimal 1.0.0                          ── E: 1[32m-1[90m   | W: 0  [31m+1[90m | N: 0  [31m+1[90m[39m

