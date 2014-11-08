#' Check numeric fields
#' 
#' Certain fields should be numeric; check that they are.
#' 
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_num <- function(dat) {
  sapply(dat[, which(colnames(dat) %in% numfields)], function(x) {
    ifelse(is.numeric(x) | is.logical(x), TRUE, FALSE)
  })
}


