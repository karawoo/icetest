context("Check averages and maxima")

dat_avemax <- data.frame(year = c(1980, 1980, 1981, 1981, 1982, 1982, 1983, 1983),
                         season = rep(c("iceon", "iceoff"), 4), 
                         lakename = rep("Lake G", 8),
                         stationname = rep("Hat Rack Bay", 8),
                         stationlat = rep(53.515694, 8),
                         stationlong = rep(-137.434421, 8),
                         lakemaxdepth = c(rep(500, 7), 250),
                         lakemeandepth = c(rep(250, 7), 500),
                         avetotphos = c(1, 0.5, 0.75, 10, NA, 3, 0.25, NA),
                         maxtotphos = c(2, 0.5, 3, 2.5, NA, 6, NA, NA), 
                         avezoopmass = c(1000, 700, NA, 500, 999, 1000, 1000, NA), 
                         maxzoopmass = c(999, 700, NA, 900, 900, 1000, 1000, 900),
                         avesuva = rep(1, 8),
                         maxsuva = rep(2, 8),
                         stringsAsFactors = FALSE)

test_that("check_avemax returns data frame of rows with mixed up ave/max", {
  expect_true(length(check_avemax(dat_avemax, flag = "values")) > 0)
  expect_null(check_avemax(dat_avemax[1:4, c("year", "season", "lakename",
                                             "stationname", "stationlat",
                                             "stationlong", "lakemaxdepth",
                                             "lakemeandepth", "avesuva",
                                             "maxsuva")],
                           flag = "values"))
})

test_that("check_avemax identifies missing max/average", {
  expect_true(length(check_avemax(dat_avemax, flag = "missing")) > 0 )
  expect_null(check_avemax(dat_avemax[1:4, ], flag = "missing"))
})
