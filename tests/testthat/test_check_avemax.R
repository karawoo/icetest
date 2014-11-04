context("Check averages and maxima")

dat_avemax <- data.frame(year = c(1980, 1980, 1981, 1981, 1982, 1982),
                         season = rep(c("iceon", "iceoff"), 3), 
                         lakename = rep("Lake G", 6), 
                         stationlat = rep(53.515694, 6),
                         stationlong = rep(-137.434421, 6),
                         avetotphos = c(1, 0.5, 0.75, 10, NA, 3),
                         maxtotphos = c(2, 0.5, 3, 2.5, NA, 6), 
                         avezoopmass = c(1000, 700, NA, 500, 999, 1000), 
                         maxzoopmass = c(999, 700, NA, 900, 900, 1000),
                         avesuva = rep(1, 6),
                         maxsuva = rep(2, 6),
                         stringsAsFactors = FALSE)

test_that("check_avemax returns data frame of rows with mixed up ave/max", {
  expect_true(length(check_avemax(dat_avemax)) > 0)
  expect_null(check_avemax(dat_avemax[, c("year", "season", "lakename", 
                                          "stationlat", "stationlong",
                                          "avesuva", "maxsuva")]))
})