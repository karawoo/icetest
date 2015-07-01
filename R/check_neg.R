##' Check for negative values
##'
##' Checks that numeric columns are never negative. These columns (with the
##' exception of stationlat, stationlong, and airtemp which can be negative)
##' should not contain values less than zero.
##' 
##' @param dat Data frame to be tested.
##'
##' @author Kara Woo
##'
##' @export

check_neg <- function(dat) {
  ## Numeric columns minus stationlat, stationlong, and airtemp, which can be negative
  noneg <- numfields[!numfields %in% c("stationlat", "stationlong", "airtemp")]

  ## If there are any numeric columns that have negative values, return a data
  ## frame of those observations along with identifying information (year,
  ## season, station info, etc.) so we can find where the problem is.
  if (any(apply(dat[, noneg], 2, function(x) any(x < 0, na.rm = TRUE)))) {
    dat[apply(dat[, noneg], 1, function(x) {
      any(x < 0, na.rm = TRUE)
    }),
    c("year", "season", "lakename", "stationname", "stationlat", "stationlong",
      names(which(apply(dat[, noneg], 2, function(x) {
        any(x < 0, na.rm = TRUE)
      }
      ))))
    ]
  }
}
