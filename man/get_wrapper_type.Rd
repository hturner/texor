% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/texor-tools.R
\name{get_wrapper_type}
\alias{get_wrapper_type}
\title{Get the name of the wrapper file in the article dir}
\usage{
get_wrapper_type(article_dir)
}
\arguments{
\item{article_dir}{path to the directory which contains tex article}
}
\value{
String with name of wrapper file or empty
}
\description{
This function gets the wrapper file name from the
commonly named R-Journal wrapper files.
}
\details{
Usually the R journal wrapper files are named either
1. RJwrapper.tex
2. RJwrap.tex
3. wrapper.tex
}
