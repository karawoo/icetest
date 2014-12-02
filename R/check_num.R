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


#' Convert fields to numeric with meaningful warnings
#'
#' Convert character fields to numeric, and if conversion fails give an
#' informative warning.
#'
#' @param x Column to be converted
#' @param y Data frame
#' @param coerce Should NAs be introduced if conversion to numeric fails?
#'
#' @author Kara Woo

convert_num <- function(x, y, coerce = FALSE) {
  if (coerce == FALSE) {
    tryCatch(as.numeric(as.character(y[, x])), 
             warning = function(w) {
               warning(paste0("Conversion failed in column: ", x))
               y[, x]
             })
  } else if (coerce == TRUE) {
    tryCatch(as.numeric(as.character(y[, x])), 
             warning = function(w) {
               warning(paste0("NAs introduced in column: ", x))
               suppressWarnings(as.numeric(as.character((y[, x]))))
             })
  }
}


#' Fix non-numeric fields
#'
#' Convert fields from character to numeric.
#'
#' @param dat Data frame to be tested.
#' @param coerce Should NAs be introduced if conversion to numeric fails?
#' Defaults to FALSE; character fields that cannot be converted will remain
#' as is. If coerce == TRUE, NAs will be introduced in columns that cannot
#' be automatically converted.
#'
#' @author Kara Woo
#'
#' @export

fix_num <- function(dat, coerce = FALSE) {
  numdat <- dat[, which(colnames(dat) %in% numfields)]
  nonnum <- dat[, which(!colnames(dat) %in% numfields)]
  numerics <- sapply(numdat, function(x) {
    ifelse(is.numeric(x) | is.logical(x), TRUE, FALSE)
  })
  if (!all(numerics)) {
    if (coerce == FALSE) {
      nums <- as.data.frame(lapply(names(dat[, numfields]), convert_num, dat, 
                                   coerce = FALSE), stringsAsFactors = FALSE)
      names(nums) <- numfields
      result <- data.frame(nums, nonnum, stringsAsFactors = FALSE)
      result <- result[, datafields]
    } else if (coerce == TRUE) {
      nums <- as.data.frame(lapply(names(dat[, numfields]), convert_num, dat,
                                   coerce = TRUE))
      names(nums) <- numfields
      result <- data.frame(nums, nonnum, stringsAsFactors = FALSE)
      result <- result[, datafields]
    }  
  } else {
    result <- dat
  }
}
