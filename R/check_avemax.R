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
    ll <- as.list(as.data.frame(mapply(`>=`, dat[, maxs], dat[, aves])))
    indices <- lapply(ll, function(x) which(!x))
    tmplist <- lapply(names(indices), function(x) {
      dat[indices[[x]], c("year", "season", "lakename", "stationlat", 
                          "stationlong", x, gsub("max", "ave", x))]
    })
    result <- tmplist[lapply(tmplist, nrow) > 0]
    names(result) <- gsub("max", "", 
                          names(indices[lapply(indices, length) > 0]))
    result
  }
}


