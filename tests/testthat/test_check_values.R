context("Check defined values")

dat_values <- data.frame(year             = rep(1990, 4),
                         season           = rep(c("iceon", "iceoff"), 2),
                         lakename         = rep("Lake A", 4),
                         stationlat       = rep(56.093233, 4), 
                         stationlong      = rep(-56.397561, 4),
                         multiplestations = rep("no", 4),
                         startmonth       = c("Jan", "Jul", "Jan", "Jul"),
                         endmonth         = c("Mar", "Sep", "Mar", "Sept"), 
                         sampletype       = c(rep("in situ", 3), "other"),
                         fadata           = c("proportional", "no", "kiwi", NA),
                         gutdata          = c("no", "no", "yes", "NA"),
                         bensubstrate     = c("NA", NA, "rock", "silt"), 
                         stringsAsFactors = FALSE)


test_that("Nothing is returned when all values are legal", {
  expect_null(check_values(dat_values[1:2, ]))
})

test_that("Function returns a list of invalid values", {
  expect_true(is.list(check_values(dat_values)))
  expect_false(is.list(check_values(dat_values[1:2, ])))
})

test_that("Function returns error when columns are missing", {
  expect_that(check_values(dat_values[, -c(8:9)]), throws_error())
})