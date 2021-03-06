% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions.R
\name{create_module_bf}
\alias{create_module_bf}
\title{Create a new module providing biological featurers (genes)}
\usage{
create_module_bf(compendium, biofeatures, normalization = "legacy")
}
\arguments{
\item{compendium}{the compendium selected for the analysis}

\item{biofeatures}{list of BiologicalFeature objects from get_bf}

\item{normalization}{the normalization to be used for the inference ('legacy' as default)}
}
\value{
a Module object
}
\description{
Create a new module providing biological featurers (genes)
}
