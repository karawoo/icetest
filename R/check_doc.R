##' Check DOC values
##'
##' We originally asked for DOC data in units of ug/l, however mg/l was provided
##' by most researchers and is a more standard unit. If DOC is in the hundreds
##' or thousands, it is likely in ug/l and we should follow up with researchers
##' and likely convert their data.
##' 
##' @param dat Data frame to be tested.
##'
##' @author Kara Wo
##'
##' @export

check_doc <- function(dat) {
  if(any(apply(dat[, c("avetotdoc", "maxtotdoc")], 2, FUN = function(x) {
                 any(x >= 200)
               }), na.rm = TRUE)) {
    warning("DOC data values exceed 200. These data are likely reported in units of ug/l. Check with researchers before converting to mg/l.")
  }
}

