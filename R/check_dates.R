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
                "endyear", "iceduration", "year", "season", "stationlat" ,
                "stationlong", "lakename")
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


#' Check ice duration
#' 
#' Make sure ice duration is not shorter than aggregation period in winter.
#' 
#' @param dat Data frame to be tested.
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr filter mutate select
#' 
#' @author Kara Woo
#' 
#' @export  

check_iceduration_length <- function(dat) {
  test <- dat %>%
    filter(season == "iceon") %>%
    mutate(aggperiod = as.Date(paste(endyear, endmonth, endday, sep = "-"), 
                          format = "%Y-%b-%d") -
             as.Date(paste(startyear, startmonth, startday, sep = "-"), 
                     format = "%Y-%b-%d"), 
           test = aggperiod <= iceduration) %>%
    filter(test == FALSE)
  if (nrow(test) > 0) {
    result <- test %>% select(year, season, lakename, stationlat, stationlong,
                              startday, startmonth, startyear, 
                              endday, endmonth, endyear, iceduration, aggperiod)
    result
  }
}


#' Check ice duration column during iceoff period
#' 
#' Ice duration should be zero during iceoff.
#' 
#' @param dat Data frame to be tested.
#' 
#' @importFrom magrittr %>%
#' @importFrom dplyr filter select
#' 
#' @author Kara Woo
#' 
#' @export

check_iceduration_iceoff <- function(dat) {
  test <- dat %>%
    filter(season == "iceoff" & iceduration != 0) %>%
    select(c(year, season, lakename, iceduration))
  if (nrow(test) > 0) {
    result <- test %>% select(year, season, lakename, iceduration)
    result
  }
}


#' Check periodn
#'
#' Should not be smaller than the number of days in the aggregation period
#' (this is confusing in the instructions).
#'
#' @param dat Data frame to be tested.
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate filter
#'
#' @author Kara Woo
#'
#' @export

check_periodn <- function(dat) {
  result <- dat %>%
    mutate(start = as.Date(paste(startday, startmonth, startyear, sep = "-"), "%d-%b-%Y"),
           end = as.Date(paste(endday, endmonth, endyear, sep = "-"), "%d-%b-%Y"),
           agg_period = end - start + 1) %>%
    filter(periodn > agg_period) %>%
    select(year, season, lakename, stationlat, stationlong, start, end,
           agg_period, periodn)
  if (nrow(result) > 0) {
    result
  }
}




