#' Check sample depth and photic depth
#'
#' The sampledepth field should be the depth of the samples used in
#' aggregation, not the maximum depth sampled (i.e. if sampling was done
#' below the photic zone). Therefore, sampledepth should not be greater than
#' photicdepth, or not by much (a few meters is probably ok). This function
#' returns a data frame of observations where the sample depth provided is
#' greater than the photic depth.
#'
#' @param dat Data frame to be tested.
#'
#' @author Kara Woo
#'
#' @export

check_depths <- function(dat) {
  cols <- c("year", "season", "stationlat", "stationlong", "lakename",
            "photicdepth", "sampledepth")
  tmp <- dat[which(!is.na(dat$photicdepth) & !is.na(dat$sampledepth)), cols]
  result <- tmp[with(tmp, photicdepth < sampledepth), ]
  if (nrow(result) > 0) {
    result
  }
}
