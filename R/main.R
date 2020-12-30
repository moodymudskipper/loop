#' loop on input
#'
#' `loop` unifies `lapply` and `Map`, `loop2` unifies `sapply` and `mapply`.
#' Both support a dollar notation so that we can leverage the autompletion of
#' function arguments. Arguments to be looped on are prefixed with `+`.
#'
#' @param fun
#'
#' @return
#' @export
#'
#' @examples
#' l <- list(iris, cars)
#' loop$head(+l, 1)
#' loop$head(+l, +1:2) # no need to worry about operator precedence
#' loop2$nrow(+l)
loop <- function(fun) {
  f <- args(fun)
  body(f) <- substitute({
    args <- as.list(match.call())[-1]
    plus_args <- unlist(lapply(args, function(x) {
      x <- deparse1(x)
      if(startsWith(x,"+")) {
        str2lang(substr(x,2, nchar(x)))
      }
    }))
    other_args <- args[!names(args) %in% names(plus_args)]
    call <- bquote(Map(function(...) fun(..., ..(other_args)), ..(plus_args)), splice = TRUE)
    eval.parent(call)
  })
  f
}

class(loop) <- "loop"

#' @export
`$.loop` <- function(loop, fun) {
  eval.parent(bquote(loop(.(as.symbol(fun)))))
}

#' @export
#' @rdname loop
loop2 <- function(fun) {
  body(fun) <- substitute({
    args <- as.list(match.call())[-1]
    plus_args <- unlist(lapply(args, function(x) {
      x <- deparse1(x)
      if(startsWith(x,"+")) str2lang(substr(x,2, nchar(x)))
    }))
    other_args <- args[!names(args) %in% names(plus_args)]
    call <- bquote(mapply(function(...) fun(..., ..(other_args)), ..(plus_args)), splice = TRUE)
    eval.parent(call)
  })
  fun
}
class(loop2) <- "loop2"

#' @export
`$.loop2` <- function(loop2, fun) {
  eval.parent(bquote(loop2(.(as.symbol(fun)))))
}

