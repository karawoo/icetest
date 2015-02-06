context("Check repeated observations")

dat_repeats <- data.frame(year = rep(1975, 6), 
                          season = rep(c("iceon", "iceoff"), 3), 
                          lakename = c("Lake E", rep("Lake F", 5)),
                          stationname = c("1658", rep("9011", 3), rep(NA, 2)),
                          stationlat = c(48.113155, rep(48.113630, 5)), 
                          stationlong = c(-138.724822, rep(-138.770224, 5)))

test_that("check_repeats returns duplicate rows if they exist", {
  expect_true(nrow(check_repeats(dat_repeats)) > 0)
  expect_null(check_repeats(dat_repeats[1:2, ]))
})
