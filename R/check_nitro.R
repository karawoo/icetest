##' Check nitrogen data
##'
##' Check order of magnitude of total nitrogen and total dissolved
##' nitrogen. This data should be in units of μg/l; if values are <=15 check
##' that they aren't in mg/l, and if so convert. Also checks if dissolved
##' nitrogen values are larger than total nitrogen and returns a data frame of
##' any such values.
##' 
##' @param dat Data frame to be tested
##'
##' @importFrom magrittr %>%
##' @importFrom dplyr filter select
##' 
##' @author Kara Woo
##'
##' @export

check_nitro <- function(dat) {
  if(any(apply(dat[, grep("^(ave|max)(.+)nitro", names(dat), value = TRUE)],
               2,
               FUN = function(x) {
                 any(x <= 15)
               }), na.rm = TRUE)) {
    warning("Nitrogen data values exist that are under 15. These data may have been reported in units of mg/l. Check with researchers before converting to ug/l.")
  }
  test <- dat %>%
    filter(avetotnitro < avetotdissnitro | maxtotnitro < maxtotdissnitro)
  if(nrow(test) > 0) {
    result <- select(test, year, season, lakename, stationname, stationlat,
                     stationlong, avetotnitro, maxtotnitro, avetotdissnitro,
                     maxtotdissnitro)
    result
  } 
}
