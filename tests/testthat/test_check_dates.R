context("Check dates")

dat_dates <- data.frame(year        = c(2002, 2002, 2003, 2003, 2004, 2004),
                        season      = rep(c("iceon", "iceoff"), 3),
                        lakename    = rep("Lake D", 6),
                        stationlat  = rep(56.095533, 6), 
                        stationlong = rep(-56.391561, 6),
                        startday    = c(31, 16, 20, 19, 02, 28),
                        startmonth  = c("Dec", "Aug", "Feb", "Sep", "Jan", "Jul"),
                        startyear   = c(2001, 2002, 2003, 2003, 2004, 2004),
                        endday      = c(12, 16, 03, 08, 25, 01),
                        endmonth    = c("Mar", "Aug", "Jan", "Aug", "Mar", "Sep"),
                        endyear     = c(2002, 2002, 2003, 2003, 2004, 2004),
                        iceduration = c(80, 0, 100, NA, 80, 80),
                        periodn     = c(9, 3, 10000, 1, 350, 12),
                        stringsAsFactors = FALSE)

test_that("Start date is before end date", {
  expect_null(check_dates(dat_dates[1:2, ]))
  expect_true(nrow(check_dates(dat_dates)) > 0)
})

test_that("Ice duration is as long as or longer than aggregation period", {
  expect_null(check_iceduration_length(dat_dates[1:4, ]))
  expect_true(nrow(check_iceduration_length(dat_dates)) > 0)
})

test_that("Ice duration is NA or zero in iceoff period", {
  expect_null(check_iceduration_iceoff(dat_dates[1:4, ]))
  expect_true(nrow(check_iceduration_iceoff(dat_dates)) > 0)
})

test_that("periodn is not larger than aggregation period", {
  expect_null(check_periodn(dat_dates[c(1, 6), ]))
  expect_true(nrow(check_periodn(dat_dates)) > 0)
})
