#' Calculate proportion sums
#' 
#' Sum proportions and, if any do not sum to 1, return a data frame of some 
#' identifiable columns of the data (year, season, lakename, lat/long) and the
#' proportion sum.
#' 
#' @param x Data frame to be checked
#' @param cols Columns which should sum to one in each row.

prop_sums <- function(x, cols) {
  y <- subset(x[, cols], !apply(x[, cols], 1, function(x) all(is.na(x))))
  sums <- rowSums(y, na.rm = TRUE)
  not_one <- sums[sapply(sums, function(x) {
    !isTRUE(all.equal(x, 1, check.attributes = FALSE, check.names = FALSE, 
                      tolerance = 0.00001)) 
  })]
  if (length(not_one) > 0) {
    result <- cbind(x[names(not_one), 
            c("year", "season", "lakename", "stationlat", "stationlong")], 
          proportion = not_one)
  } else {
    result <- NULL
  }
  result
}


#' Check proportions
#' 
#' Proportions of different zooplankton and phytoplankton taxa should sum to 1.
#' Returns a list of data where proportions do not sum to 1 for phytoplankton
#' and zooplankton taxa. If all proportions sum to 1, no list is returned.
#' 
#' @param dat Data frame to be tested
#' 
#' @author Kara Woo
#' 
#' @export

check_props <- function(dat) {
 phyto <- c("propchloro", "propcrypto", "propcyano", "propdiatom", "propdino",
            "propotherphyto") 
 zoo <- c("propdaphnia", "propothercladoc", "propcyclopoid", "propcalanoid",
          "proprotifer", "propotherzoop")
 if (!all(phyto %in% colnames(dat)) | !all(zoo %in% colnames(dat))) {
   stop("Data is missing some phytoplankton or zooplankton columns")
 }
 ll <- list(phyto = prop_sums(dat, phyto), 
            zoo = prop_sums(dat, zoo))
 if (length(ll$phyto) > 0 | length(ll$zoo) > 0) {
   result <- ll
   result
 } 
}




