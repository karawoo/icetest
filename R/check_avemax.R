#' Check averages and maxima
#' 
#' Checks that averages are not larger than maxima.
#'
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_avemax <- function(dat) {
  avemax <- grep("^(ave|max)", names(dat), value = TRUE)
  aves <- grep("^ave", avemax, value = TRUE)
  maxs <- grep("^max", avemax, value = TRUE)
  if (any(!mapply(`>=`, dat[, maxs], dat[, aves]), na.rm = TRUE)) {
    test <- mapply(`>=`, dat[, maxs], dat[, aves])
    result <- dat[which(apply(test, 1, function(x) any(!x, na.rm = TRUE))), ]
    result
  }
}

