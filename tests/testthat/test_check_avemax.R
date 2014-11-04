context("Check averages and maxima")

dat_avemax <- data.frame(year = c(1980, 1980, 1981, 1981),
                         season = rep(c("iceon", "iceoff"), 2), 
                         lakename = rep("Lake G", 4), 
                         avetotphos = c(1, 0.5, 0.75, 10),
                         maxtotphos = c(2, 0.5, 3, 2.5), 
                         avezoopmass = c(1000, 700, NA, 500), 
                         maxzoopmass = c(999, 700, NA, 900), 
                         stringsAsFactors = FALSE)

test_that("check_avemax returns data frame of rows with mixed up ave/max", {
  expect_true(nrow(check_avemax(dat_avemax)) > 0)
})