##' Check phytoplankton biomass
##'
##' We originally asked for phytoplankton biomass in units of ug dry weight /
##' liter, however after talking with researchers we determined that biovolume
##' is a better unit. This function throws a warning if biomass data is present
##' for phytoplankton, ciliates, or heterotrophic nanoflagellates so that we can
##' follow up with the researcher about converting the units.
##' 
##' @param dat Data frame to be tested.
##'
##' @author Kara Woo
##'
##' @export

check_phytomass <- function(dat) {
  relevant_cols <- c("avephytomass", "cvphytomass", "maxphytomass",
                     "aveciliamass", "cvciliamass", "maxciliamass",
                     "avehnfmass",   "cvhnfmass",   "maxhnfmass")
  if(any(apply(dat[, relevant_cols], 1, FUN = function(x) any(!is.na(x))))) {
    warning("Phyto/ciliate/HNF biomass present. Follow up with researcher about converting to biovolume")
  }
}
