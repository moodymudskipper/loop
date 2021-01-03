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
#' loop$mean(c(+11:12,+1:2)) # we can loop on nested "plussed" arguments too
#' loop2$nrow(+l)
loop <- function(fun) {
  f <- args(fun)
  body(f) <- substitute({
    args <- as.list(match.call())[-1]
    ind <- 0
    plus_args <- list()
    recurse <- function(x) {
      if(!is.call(x)) return(x)
      x_chr <- deparse1(x)
      if(startsWith(x_chr,"+")) {
        ind <<- ind + 1
        plus_args[[ind]] <<- str2lang(substr(x_chr,2, nchar(x_chr)))
        bquote(...elt(.(ind)))
      } else {
        x[] <- lapply(x, recurse)
        x
      }
    }
    args <- lapply(args, recurse)
    call <- bquote(Map(function(...) fun(..(args)), ..(plus_args)), splice = TRUE)
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
  f <- args(fun)
  body(f) <- substitute({
    args <- as.list(match.call())[-1]
    ind <- 0
    plus_args <- list()
    recurse <- function(x) {
      if(!is.call(x)) return(x)
      x_chr <- deparse1(x)
      if(startsWith(x_chr,"+")) {
        ind <<- ind + 1
        plus_args[[ind]] <<- str2lang(substr(x_chr,2, nchar(x_chr)))
        bquote(...elt(.(ind)))
      } else {
        x[] <- lapply(x, recurse)
        x
      }
    }
    args <- lapply(args, recurse)
    call <- bquote(mapply(function(...) fun(..(args)), ..(plus_args)), splice = TRUE)
    eval.parent(call)
  })
  f
}
class(loop2) <- "loop2"

#' @export
`$.loop2` <- function(loop2, fun) {
  eval.parent(bquote(loop2(.(as.symbol(fun)))))
}

