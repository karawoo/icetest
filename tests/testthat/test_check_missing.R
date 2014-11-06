context("Check missing")

dat_missing <- data.frame(year = c(1990, 1990), 
                          season = c("iceon", "iceoff"), 
                          researcher = c(NA, NA), 
                          lakename = c("Lake Awesome", NA), 
                          watertemp = c(NA, 12.5), 
                          stationlat = rep(56.093814, 2), 
                          stationlong = rep(-56.407211, 2), 
                          startday = c(10, 22), 
                          startmonth = c('Jan', NA),
                          startyear = c(1990, 1990), 
                          endday = c(30, 15),
                          endmonth = c('Mar', 'Sep'), 
                          endyear = c(1990, 1990), 
                          stringsAsFactors = FALSE)

dat_missing_strings <- replace(dat_missing, is.na(dat_missing), "NA")

dat_missing_both <- data.frame(dat_missing[, 1:7], dat_missing_strings[, 8:13])

dat_missing_correct <- data.frame(year = c(1990, 1990), 
                                  season = c("iceon", "iceoff"), 
                                  researcher = c("Jane.Doe", "Jane.Doe"), 
                                  lakename = c("Lake Awesome", "Lake Awesome"), 
                                  watertemp = c(4.0, 12.5),
                                  stationlat = rep(56.093814, 2), 
                                  stationlong = rep(-56.407211, 2),
                                  startday = c(10, 22), 
                                  startmonth = c('Jan', 'Jul'),
                                  startyear = c(1990, 1990), 
                                  endday = c(30, 15),
                                  endmonth = c('Mar', 'Sep'), 
                                  endyear = c(1990, 1990), 
                                  stringsAsFactors = FALSE)

test_that("check_missing identifies missing data from proper columns", {
  expect_true(is.null(check_missing(dat_missing_correct)[[1]]))
  expect_true(length(check_missing(dat_missing)[[1]]) > 0)
  expect_equal(check_missing(dat_missing), check_missing(dat_missing_strings))
  expect_equal(check_missing(dat_missing), check_missing(dat_missing_both))
})

test_that("Function fails when data is missing columns", {
  expect_that(check_missing(dat_missing[, -c(6:7)]), throws_error())
})

