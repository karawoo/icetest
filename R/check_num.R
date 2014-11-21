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
#' @param coerce Should NAs be introduced if conversion to numeric fails?
#' Defaults to FALSE; function will throw an error and you will need to
#' examine the data for problems if there are any fields that can't be
#' converted.
#'
#' @author Kara Woo
#'
#' @export

fix_num <- function(dat, coerce = FALSE) {
  numdat <- dat[, which(colnames(dat) %in% numfields)]
  numerics <- sapply(numdat, function(x) {
    ifelse(is.numeric(x) | is.logical(x), TRUE, FALSE)
  })
  if (!all(numerics)) {
    if (coerce == FALSE) {
      tryCatch(
        for (i in seq_len(ncol(numdat))) {
          numdat[, i] <- as.numeric(as.character(numdat[, i]))
        },
        warning = function(w) cat("Problem values in: ", names(numdat)[i]))
    } else if (coerce == TRUE) {
      nums <- as.data.frame(lapply(numdat,
                                   function(x) as.numeric(as.character(x))))
      result <- data.frame(nums, dat[, which(!colnames(dat) %in% numfields)])
      result <- result[, datafields]
    }  
  } else {
    result <- dat
  }
}
