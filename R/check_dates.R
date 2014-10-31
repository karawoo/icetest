#' Check dates
#' 
#' Make sure that start date is before end date.
#' 
#' @param dat Data frame to be tested.
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr mutate filter select
#' 
#' @author Kara Woo
#' 
#' @export

check_dates <- function(dat) {
  datecols <- c("startday", "startmonth", "startyear", "endday", "endmonth", 
                "endyear", "iceduration")
  if (!all(datecols %in% names(dat))) {
    missing <- datecols[which(!datecols %in% colnames(dat))]
    stop(paste("Data is missing the following columns:", 
               paste(missing, collapse = ", ")))
  }
  test <- dat %>%
    mutate(start = as.Date(paste(startyear, startmonth, startday, sep = "-"),
                           format = "%Y-%b-%d"),
           end = as.Date(paste(endyear, endmonth, endday, sep = "-"), 
                         format = "%Y-%b-%d"),
           test = end >= start) %>%
    filter(test == FALSE)
  if (nrow(test) > 0) {
    result <- test %>% select(year, season, lakename, stationlat, stationlong,
                              startday, startmonth, startyear, 
                              endday, endmonth, endyear)
    result
  }
  
}



