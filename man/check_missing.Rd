% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/check_missing.R
\name{check_missing}
\alias{check_missing}
\title{Check for missing data}
\usage{
check_missing(dat)
}
\arguments{
\item{dat}{Data frame to be tested.}
}
\description{
Certain fields should not have missing data, or we want to make sure we're
aware if data is missing. These fields are defined as: year, season,
researcher, lakename, stationlat, stationlong, startdaty, startmonth,
startyear, endday, endmonth, endyear, photicdepth, sampledepth. This function
checks data in these columns for missing values (NAs). Future
}
\author{
Kara Woo
}

