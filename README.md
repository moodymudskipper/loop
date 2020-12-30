
<!-- README.md is generated from README.Rmd. Please edit that file -->

# loop

*{loop}* contains two functions, `loop` unifies `lapply` and `Map`,
`loop2` unifies `sapply` and `mapply`.

Both support a dollar notation so that we can leverage the autompletion
of function arguments. Arguments to be looped on are prefixed with `+`.

``` r
library(loop)
loop(rep)(+11:12, 2)   # rather than `lapply(11:12, rep, 2)`
#> [[1]]
#> [1] 11 11
#> 
#> [[2]]
#> [1] 12 12
loop$rep(+11:12, 2)    # same thing, but we benefit from autocomplete
#> [[1]]
#> [1] 11 11
#> 
#> [[2]]
#> [1] 12 12
loop$rep(+11:12, +1:2) # rather than `Map(rep, 11:12, 1:2)`
#> [[1]]
#> [1] 11
#> 
#> [[2]]
#> [1] 12 12

# rather than `Map(function(...) rep(..., each =2), 11:12, 1:2)` :
loop$rep(+11:12, +1:2, each = 2) 
#> [[1]]
#> [1] 11 11
#> 
#> [[2]]
#> [1] 12 12 12 12

l <- list(iris, cars)
loop2$nrow(+l) # rather than `sapply(l, nrow)`
#> [1] 150  50
```

## Installation

Install with :

``` r
remotes::install_github("moodymudskipper/loop")
```

## Why ?

We get used to the apply functions, but :

  - They’re hard to grasp at first
  - No way to leverage the applied function’s autocomplete
  - The IDE highlights the apply function, not the applied function
  - No need to shuffle the arguments when going from `lapply` to `Map`
    or `sapply` to `mapply`
  - Much more compact to use constant arguments with `Map` and `sapply`
  - I believe its more intuitive to have the applied function first
