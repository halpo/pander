#' Add trailing and leading blank line
#'
#' Adds a line break before \emph{and} after the character string(s).
#' @param x character vector
#' @export
add.blank.lines <- function(x)
    sprintf('\n%s\n', x)


#' Remove more then two joined newlines
#' @param x character vector
#' @export
#' @examples
#' remove.extra.newlines(c('\n\n\n', '\n\n', '\n'))
remove.extra.newlines <- function(x)
    gsub('[\n][\n]+', '\n\n', x)


#' Trim leading and trailing spaces
#' @param x character vector
#' @return character vector
#' @export
#' @seealso \code{trim.space} in \code{rapport} package
trim.spaces <- function(x)
    gsub('^[[:space:]]+|[[:space:]]+$', '', x)

#' Repeating chars
#'
#' Repeating a string \code{n} times and returning a concatenated character vector.
#' @param x string to repeat
#' @param n integer
#' @param sep separator between repetitions
#' @return character vector
#' @export
repChar <- function(x, n, sep = '')
    paste(rep.int(x, n), collapse = sep)


#' Inline Printing
#'
#' \code{\link{p}} merges elements of a vector in one string for the sake of pretty inline printing. Default parameters are read from appropriate \code{option} values (see argument description for details). This function allows you to put the results of an expression that yields a variable \emph{inline}, by wrapping the vector elements with the string provided in \code{wrap}, and separating elements by main and ending separator (\code{sep} and \code{copula}). In case of a two-length vector, value specified in \code{copula} will be used as a separator. You can also control the length of provided vector by altering an integer value specified in \code{limit} argument (defaults to \code{Inf}).
#' @param x an atomic vector to get merged for inline printing
#' @param wrap a string to wrap vector elements (uses value set in \code{p.wrap} option: \code{"_"} by default, which is a markdown-friendly wrapper and it puts the string in \emph{italic})
#' @param sep a string with the main separator, i.e. the one that separates all vector elements but the last two (uses the value set in \code{p.sep} option - \code{","} by default)
#' @param copula a string with ending separator - the one that separates the last two vector elements (uses the value set in \code{p.copula} option, \code{"and"} by default)
#' @param limit maximum character length (defaults to \code{Inf}initive  elements)
#' @param keep.trailing.zeros to show or remove trailing zeros in numbers
#' @return a string with concatenated vector contents
#' @examples
#' p(c("fee", "fi", "foo", "fam"))
#' ## [1] "_fee_, _fi_, _foo_ and _fam_"
#' p(1:3, wrap = "")
#' ## [1] "1, 2 and 3"
#' p(LETTERS[1:5], copula = "and the letter")
#' ## [1] "_A_, _B_, _C_, _D_ and the letter _E_"
#' p(c("Thelma", "Louise"), wrap = "", copula = "&")
#' ## [1] "Thelma & Louise"
#' @export
#' @author Aleksandar Blagotic
#' @references This function was moved from \code{rapport} package: \url{http://rapport-package.info/}.
p <- function(x, wrap = panderOptions('p.wrap'), sep = panderOptions('p.sep'), copula = panderOptions('p.copula'), limit = Inf, keep.trailing.zeros = panderOptions('keep.trailing.zeros')){

    attributes(x) <- NULL
    stopifnot(is.vector(x))
    stopifnot(all(sapply(list(wrap, sep, copula), function(x) is.character(x) && length(x) == 1)))
    x.len <- length(x)
    stopifnot(x.len > 0)
    stopifnot(x.len <= limit)

    ## prettify numbers
    if (is.numeric(x)) {

        x <- round(x, panderOptions('round'))
        x <- format(x, trim = TRUE, digits = panderOptions('digits'), decimal.mark = panderOptions('decimal.mark'))

        ## optionally remove trailing zeros
        if (!keep.trailing.zeros)
            x <- sub('(?:(\\..*[^0])0+|\\.0+)$', '\\1', x)

    }

    if (x.len == 1)
        wrap(x, wrap)
    else if (x.len == 2)
        paste(wrap(x, wrap), collapse = copula)
    else
        paste0(paste(wrap(head(x, -1), wrap), collapse = sep), copula, wrap(tail(x, 1), wrap))
}


#' Wrap Vector Elements
#'
#' Wraps vector elements with string provided in \code{wrap} argument.
#' @param x a vector to wrap
#' @param wrap a string to wrap around vector elements
#' @return a string with wrapped elements
#' @examples \dontrun{
#' wrap("foobar")
#' wrap(c("fee", "fi", "foo", "fam"), "_")
#' }
#' @export
#' @author Aleksandar Blagotic
#' @references This function was moved from \code{rapport} package: \url{http://rapport-package.info/}.
wrap <- function(x, wrap = '"'){
    attributes(x) <- NULL
    stopifnot(is.vector(x))
    sprintf('%s%s%s', wrap, x, wrap)
}

#' Check if rownames are available
#'
#' Dummy helper to check if the R object has real rownames or not.
#' @param x a tabular-like R object
#' @return \code{TRUE} OR \code{FALSE}
#' @export
has.rownames <- function(x) {
    length(dim(x)) != 1 && (length(rownames(x)) > 0 && !all(rownames(x) == 1:nrow(x)))
}

#' Adds caption in current block
#'
#' This is a helper function to add a caption to the returning image/table.
#' @param x string
#' @export
set.caption <- function(x)
    assign('caption', x , envir = storage)


#' Get caption
#'
#' Get caption from temporary environment and truncates that
#' @return stored caption as string
#' @keywords internal
get.caption <- function()
    get.storage('caption')


#' Sets alignment for tables
#'
#' This is a helper function to update the alignment (\code{justify} parameter of \code{pandoc.table}) of the returning table. Possible values are: \code{centre} or \code{center}, \code{right}, \code{left}.
#' @param default character vector which length equals to one (would be repeated \code{n} times) ot \code{n} - where \code{n} equals to the number of columns in the following table
#' @param row.names string holding the alignment of the (optional) row names
#' @export
set.alignment <- function(default = 'centre', row.names = 'right')
    assign('alignment', list(default = default, row.names = row.names) , envir = storage)


#' Get alignment
#'
#' Get alignment from temporary environment, truncating that and applying rownames and other columns alignment to passed \code{df}.
#' @return vector of alignment parameters
#' @keywords internal
get.alignment <- function(df) {

    if (is.null(attr(df, 'alignment'))) {

        a <- get.storage('alignment')

        if (is.null(a)) {
            ad <- panderOptions('table.alignment.default')
            ar <- panderOptions('table.alignment.rownames')
            if (is.function(ar))
                ar <- ar()
            if (is.function(ad)) {
                if (!has.rownames(df))
                    ar <- NULL
                return(c(ar, ad(df)))
            }
            a <- list(default = ad, row.names = ar)
        }

        if (length(a) == 1)
            a <- list(default = as.character(a), row.names = as.character(a))

        if (length(dim(df)) < 2) {
            w <- length(df)
            n <- NULL
        } else {
            w <- ncol(df)
            n <- rownames(df)
            if (all(n == 1:nrow(df)))
                n <- NULL
        }

        if (is.null(n))
            return(rep(a$default, length.out = w))
        else
            return(c(a$row.names, rep(a$default, length.out = w)))

    }

    attr(df, 'alignment')
}


#' Emphasize rows/columns/cells
#'
#' Storing indexes of cells to be (strong) emphasized of a tabular data in an internal buffer that can be released and applied by \code{\link{pandoc.table}}, \code{\link{pander}} or \code{\link{evals}} later.
#' @param x vector of row/columns indexes or an array like returned by \code{which(..., arr.ind = TRUE)}
#' @aliases emphasize.rows emphasize.cols emphasize.cells emphasize.strong.rows emphasize.strong.cols emphasize.strong.cells
#' @usage
#' emphasize.rows(x)
#'
#' emphasize.cols(x)
#'
#' emphasize.cells(x)
#'
#' emphasize.strong.rows(x)
#'
#' emphasize.strong.cols(x)
#'
#' emphasize.strong.cells(x)
#' @export
#' @examples \dontrun{
#' n <- data.frame(x = c(1,1,1,1,1), y = c(0,1,0,1,0))
#' emphasize.cols(1)
#' emphasize.rows(1)
#' pandoc.table(n)
#'
#' emphasize.strong.cells(which(n == 1, arr.ind = TRUE))
#' pander(n)
#' }
emphasize.rows <- function(x)
    assign(deparse(match.call()[[1]]), x , envir = storage)
#' @export
emphasize.strong.rows <- emphasize.rows
#' @export
emphasize.cols <- emphasize.rows
#' @export
emphasize.strong.cols <- emphasize.rows
#' @export
emphasize.cells <- emphasize.rows
#' @export
emphasize.strong.cells <- emphasize.rows


#' Get emphasize params from internal buffer
#'
#' And truncate content.
#' @param df tabular data
#' @return R object passed as \code{df} with possibly added \code{attr}s captured from internal buffer
#' @keywords internal
get.emphasize <- function(df) {
    for (v in c('emphasize.rows', 'emphasize.cols', 'emphasize.cells', 'emphasize.strong.rows', 'emphasize.strong.cols', 'emphasize.strong.cells'))
        if (is.null(attr(df, v)))
            attr(df, v) <- get.storage(v)
    return(df)
}


#' Get a value from internal buffer
#'
#' And truncate content.
#' @param what string
#' @keywords internal
get.storage <- function(what) {
    res <- tryCatch(get(what, envir = storage, inherits = FALSE), error = function(e) NULL)
    assign(what, NULL , envir = storage)
    return(res)
}


#' Add significance stars
#'
#' This function adds significance stars to passed \code{p} value(s) as: one star for value below \code{0.05}, two for \code{0.01} and three for \code{0.001}.
#' @param p numeric vector or tabular data
#' @return character vector
#' @export
add.significance.stars <- function(p) {

    if (inherits(p, c("matrix", "data.frame")) && length(dim(p)) == 2) {
        apply(p, c(1,2), add.significance.stars)
    } else {
        if (length(p) > 1) {
            sapply(p, add.significance.stars)
        } else {
            s <- ifelse(p > 0.05, '', ifelse(p > 0.01, ' *', ifelse(p > 0.001, ' * *', ' * * *')))
            paste0(p(p), s)
        }
    }
}


#' Toggle cache
#'
#' This function is just a wrapper around \code{\link{evalsOptions}} to switch pander's cache on or off easily, which might be handy in some brew documents to prevent repetitive strain injury :)
#' @aliases cache.on
#' @usage
#' cache.on()
#'
#' cache.off()
#' @export
cache.off <- function()
    evalsOptions('cache', FALSE)

#' @export
cache.on <- function()
    evalsOptions('cache', TRUE)
