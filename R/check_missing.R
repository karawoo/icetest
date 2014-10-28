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
  if (length(missing) > 0) {
    print(paste0("Missing data in field(s): ", paste(missing, collapse = ', ')))
  } else {
    print("No missing data in required fields.")
  }
}
