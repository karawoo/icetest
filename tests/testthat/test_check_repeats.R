context("Check repeated observations")

dat_repeats <- data.frame(year = rep(1975, 4), 
                          season = rep(c("iceon", "iceoff"), 2), 
                          lakename = c("Lake E", "Lake F", "Lake F", "Lake F"), 
                          stationlat = c(48.113155, rep(48.113630, 3)), 
                          stationlong = c(-138.724822, rep(-138.770224, 3)))

test_that("check_repeats returns duplicate rows if they exist", {
  expect_true(nrow(check_repeats(dat_repeats)) > 0)
  expect_null(check_repeats(dat_repeats[1:2, ]))
})