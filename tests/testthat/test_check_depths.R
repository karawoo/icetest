context("Check sample depth and photic depth")

dat_depths <- data.frame(year = c(2000, 2000, 2001, 2001),
                         season = rep(c("iceon", "iceoff"), 2),
                         stationlat = rep(48.403918, 4),
                         stationlong = rep(-125.628362, 4),
                         lakename = rep("Lake H", 4),
                         photicdepth = c(42, 38, 46, 39),
                         sampledepth = c(40, 38, 50, 40),
                         stringsAsFactors = FALSE)

test_that("Function returns NULL when sampledepth <= photicdepth", {
  expect_null(check_depths(dat_depths[1:2, ]))
})

test_that("Function returns data frame of cases where sampledepth > photicdepth", {
  expect_true(nrow(check_depths(dat_depths)) > 0)
  expect_true(nrow(check_depths(dat_depths[3:4, ])) > 0)
})
