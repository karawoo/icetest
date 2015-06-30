#' Check repeats
#' 
#' There shouldn't be more than one observation from a single site in a single
#' year and season. This function checks for repeats in both stationname and
#' latitude/longitude. Note that if there are multiple stations with different
#' coordinates and no names (i.e. NA in the stationname field), these will be
#' shown as repeats.
#' 
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_repeats <- function(dat) {
  repeatcols <- c("year", "season", "lakename", "stationname", "stationlat",
                  "stationlong")
  dd <- dat[, repeatcols]
  if (any(duplicated(dd[, c("year", "season", "lakename", "stationname")]))
      | any(duplicated(dd[, c("year", "season", "lakename",
                              "stationlat", "stationlong")]))) {
    dd[duplicated(dd[, c("year", "season", "lakename", "stationname")])
       | duplicated(dd[, c("year", "season", "lakename", "stationname")],
                    fromLast = TRUE)
       | duplicated(dd[, c("year", "season", "lakename",
                           "stationlat", "stationlong")])
       | duplicated(dd[, c("year", "season", "lakename",
                           "stationlat", "stationlong")], fromLast = TRUE), ]
  }
}
