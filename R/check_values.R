#' Check defined values
#' 
#' Certain fields can only have certain values. This function checks that 
#' the following fields contain only allowed values:
#' - season ("iceon" or "iceoff")
#' - multiplestations ("yes" or "no")
#' - startmonth and endmonth (three letter abbreviation)
#' - sampletype ("in situ" or "remote sensed")
#' - fadata ("no", "proportional", or "concentrations")
#' - gutdata ("yes" or "no")
#' - bensubstrate (NA or "organic", "silt", "sand", "rock", "mixed")
#' 
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export 

check_values <- function(dat) {
  values <- list(season = c("iceon", "iceoff"),
                 multiplestations = c("yes", "no"),
                 startmonth = month.abb, 
                 endmonth = month.abb, 
                 sampletype = c("in situ", "remote sensed"), 
                 fadata = c("no", "proportional", "concentrations"), 
                 gutdata = c("yes", "no"), 
                 bensubstrate = c(NA, "NA", "organic", "silt", "sand", "rock", 
                                  "mixed"))
  
  if (!all(names(values) %in% colnames(dat))) {
    missing <- names(values)[which(!names(values) %in% colnames(dat))]
    stop(paste("Data is missing the following columns:", 
               paste(missing, collapse = ", ")))
  }
  
  if (!all(sapply(names(values), function(x) all(dat[, x] %in% values[[x]])))) {
    ll <- sapply(names(values),
                 function(x) dat[, x][!dat[, x] %in% values[[x]]])
    result <- ll[sapply(ll, function(x) length(x) > 0)]
    result
  }
}
