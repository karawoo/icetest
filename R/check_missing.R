#' Check for missing data
#' 
#' Certain fields should not have missing data, or we want to make sure we're
#' aware if data is missing. These fields are defined as: year, season,
#' researcher, lakename, stationlat, stationlong, startdaty, startmonth,
#' startyear, endday, endmonth, endyear, photicdepth, sampledepth. This function
#' checks data in these columns for missing values (NAs). Future
#' 
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_missing <- function(dat) {
  cols <- c("year", "season", "researcher", "lakename", "stationlat",
            "stationlong", "startday", "startmonth", "startyear", "endday", 
            "endmonth", "endyear", "photicdepth", "sampledepth")
  if (!all(cols %in% colnames(dat))) {
    stop("Data is missing some required columns")
  }
  trueNAs <- lapply(dat[, cols], function(x) any(is.na(x)))
  strings <- lapply(dat[, cols], function(x) any(x == "NA"))
  result <- append(trueNAs, strings)
  missing <- names(result)[which(sapply(result, isTRUE))]
  if (length(missing) > 0) {
    result <- list(missing_data_in_fields = missing)
    result
  }
}
