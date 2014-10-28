context("Check missing")

check_missing_dat_1 <- data.frame(year = c(1990, 1990), 
                                  season = c("iceon", "iceoff"), 
                                  researcher = c("Jane.Doe", "Jane.Doe"), 
                                  lakename = c("Lake Awesome", "Lake Awesome"), 
                                  watertemp = c(4.0, 12.5))

check_missing_dat_2 <- data.frame(year = c(1990, 1990), 
                                  season = c("iceon", "iceoff"), 
                                  researcher = c(NA, NA), 
                                  lakename = c("Lake Awesome", NA), 
                                  watertemp = c(NA, 12.5))

test_that("check_missing identifies missing data from proper columns", {
  expect_true(is.null(check_missing(check_missing_dat_1)[[1]]))
  expect_true(length(check_missing(check_missing_dat_2)[[1]]) > 0)
})