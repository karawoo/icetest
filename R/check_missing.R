#' Check for missing data
#' 
#' Certain fields should not have missing data.
#' 
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_missing <- function(dat) {
  cols <- c("year", "season", "researcher", "lakename")
  result <- lapply(dat[, cols], function(x) any(is.na(x)))
  missing <- names(result)[which(sapply(result, isTRUE))]
  result <- list(missing_data_in_fields = missing)
  result
}
