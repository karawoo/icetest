#' Check numeric fields
#' 
#' Certain fields should be numeric; check that they are. Returns a vector of
#' column names of fields that should be numeric but aren't.
#' 
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_num <- function(dat) {
  numerics <- sapply(dat[, which(colnames(dat) %in% numfields)], function(x) {
    ifelse(is.numeric(x) | is.logical(x), TRUE, FALSE)
  })
  if(!all(numerics)) {
    result <- names(which(!numerics))
    result
  }
}


#' Fix non-numeric fields
#'
#' Convert fields from character to numeric.
#'
#' @param dat Data frame to be tested.
#'
#' @author Kara Woo
#'
#' @export

fix_num <- function(dat) {
  numerics <- sapply(dat[, which(colnames(dat) %in% numfields)], function(x) {
    ifelse(is.numeric(x) | is.logical(x), TRUE, FALSE)
  })
  if(!all(numerics)) {
    nums <- as.data.frame(lapply(dat[, which(colnames(dat) %in% numfields)],
                                 function(x) as.numeric(as.character(x))))
    result <- data.frame(nums, dat[, which(!colnames(dat) %in% numfields)])
    result <- result[, datafields]
  } else {
    result <- dat
  }
  result
}
