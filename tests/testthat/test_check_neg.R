context("Check for negative values")

dat_neg <- data.frame(cvsuva = c(0, 0.1, -0.1, NA),
                      propcalanoid = c(-0.3, 0.2, NA, 0.4),
                      avetotdissnitro = c(NA, NA, -439.1, 560),
                      year = c(2010, 2011, 2012, 2013),
                      season = rep("iceon", 4),
                      lakename = rep("Lake I", 4),
                      stationname = NA,
                      stationlat = rep(48.40387, 4),
                      stationlong = rep(-125.6281, 4))

dat_neg[, numfields[!numfields %in% names(dat_neg)]] <- NA

test_that("Function returns NULL when there are no negative values", {
  expect_null(check_neg(dat_neg[c(2, 4), ]))
})

test_that("Function returns a data frame when there are negative values", {
  expect_true(nrow(check_neg(dat_neg)) > 0)
  expect_true(nrow(check_neg(dat_neg[1, ])) > 0)
})
