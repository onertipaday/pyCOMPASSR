% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{get_data_sources}
\alias{get_data_sources}
\title{Get the experiments data sources both local and public}
\usage{
get_data_sources(compendium = get_compendium())
}
\arguments{
\item{compendium}{the compendium selected for the analysis}
}
\value{
a data.frame
}
\description{
Get the experiments data sources both local and public
}
\examples{
vv_compendium <- get_compendium()
get_data_sources(compendium = vv_compendium)
}
