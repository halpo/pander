\name{pandoc.header.return}
\alias{pandoc.header}
\alias{pandoc.header.return}
\title{Create header}
\usage{
  pandoc.header.return(x, level = 1,
    style = c("atx", "setext"))
}
\arguments{
  \item{x}{character vector}

  \item{level}{integer}

  \item{style}{atx or setext type of heading}
}
\value{
  By default this function outputs (see: \code{cat}) the
  result. If you would want to catch the result instead,
  then call the function ending in \code{.return}.
}
\description{
  Creates a (Pandoc's) markdown style header with given
  level.
}
\examples{
pandoc.header('Foo!', 4)
pandoc.header('Foo!', 2, 'setext')
pandoc.header('Foo **bar**!', 1, 'setext')
}
\references{
  John MacFarlane (2012): _Pandoc User's Guide_.
  \url{http://johnmacfarlane.net/pandoc/README.html}
}

