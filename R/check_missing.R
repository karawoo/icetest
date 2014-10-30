#' Check for missing data
#' 
#' Certain fields should not have missing data. These fields are currently 
#' defined as: year, season, researcher, lakename, stationlat, stationlong, 
#' startdaty, startmonth, startyear, endday, endmonth, and endyear. This
#' function checks data in these columns for missing values (NAs). Future
#' 
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_missing <- function(dat) {
  cols <- c("year", "season", "researcher", "lakename", "stationlat",
            "stationlong", "startday", "startmonth", "startyear", "endday", 
            "endmonth", "endyear")
  if (!all(cols %in% colnames(dat))) {
    stop("Data is missing some required columns")
  }
  result <- lapply(dat[, cols], function(x) any(is.na(x)))
  missing <- names(result)[which(sapply(result, isTRUE))]
  if (length(missing) > 0) {
    result <- list(missing_data_in_fields = missing)
    result
  }
}
