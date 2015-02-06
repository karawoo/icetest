#' Check repeats
#' 
#' There shouldn't be more than one observation from a single site in a single
#' year and season.
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

