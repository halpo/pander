\name{set.alignment}
\alias{set.alignment}
\title{Sets alignment for tables}
\usage{
  set.alignment(default = "centre", row.names = "right")
}
\arguments{
  \item{default}{character vector which length equals to
  one (would be repeated \code{n} times) ot \code{n} -
  where \code{n} equals to the number of columns in the
  following table}

  \item{row.names}{string holding the alignment of the
  (optional) row names}
}
\description{
  This is a helper function to update the alignment
  (\code{justify} parameter of \code{pandoc.table}) of the
  returning table. Possible values are: \code{centre} or
  \code{center}, \code{right}, \code{left}.
}

