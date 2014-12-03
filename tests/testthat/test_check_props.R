context("Check that proportions sum to 1")

dat_props <- data.frame("year"            = c(2000:2005), 
                        "season"          = rep("iceoff", 6),
                        "lakename"        = rep("Lake A", 6),
                        "stationlat"      = rep(56.093233, 6), 
                        "stationlong"     = rep(-56.397561, 6),
                        "propdaphnia"     = c(0.2, 0.5, NA, 15, 0.18, NA), 
                        "propothercladoc" = c(0.01, 0.1, NA, 10, 0.13, NA), 
                        "propcyclopoid"   = c(0.1, 0.0, NA, 25, 0.2, NA),
                        "propcalanoid"    = c(0.55, 0.01, NA, 20, 0.32, NA),
                        "proprotifer"     = c(0.08, 0.3, NA, 20, NA, NA), 
                        "propotherzoop"   = c(0.06, 0.07, NA, 10, 0.17, NA), 
                        "propchloro"      = c(NA, 0.2, 0.5, 15, 0.28, NA),
                        "propcrypto"      = c(NA, 0.01, 0.1, 10, 0.13, NA), 
                        "propcyano"       = c(NA, 0.1, 0.0, 25, 0.2, NA),
                        "propdiatom"      = c(NA, 0.55, 0.01, 20, 0.32, NA),
                        "propdino"        = c(NA, 0.08, 0.3, 20, NA, NA), 
                        "propotherphyto"  = c(NA, 0.06, 0.09, 10, 0.08, NA), 
                        stringsAsFactors = FALSE)

dat_props_correct <- data.frame("year"            = rep(2000, 2), 
                                "season"          = rep("iceoff", 2), 
                                "lakename"        = rep("Lake B", 2), 
                                "stationlat"      = rep(56.093814, 2), 
                                "stationlong"     = rep(-56.407211, 2), 
                                "propdaphnia"     = c(NA, 0.1666667), 
                                "propothercladoc" = c(NA, 0.1666667), 
                                "propcyclopoid"   = c(NA, 0.1666667), 
                                "propcalanoid"    = c(NA, 0.1666667), 
                                "proprotifer"     = c(NA, 0.1666667), 
                                "propotherzoop"   = c(NA, 0.1666667), 
                                "propchloro"      = c(NA, 0.1666667), 
                                "propcrypto"      = c(NA, 0.1666667), 
                                "propcyano"       = c(NA, 0.1666667), 
                                "propdiatom"      = c(NA, 0.1666667),
                                "propdino"        = c(NA, 0.1666667), 
                                "propotherphyto"  = c(NA, 0.1666667), 
                                stringsAsFactors  = FALSE)


test_that("Rows with proportions that don't sum to 1 are returned", {
  expect_true(length(check_props(dat_props)) == 2)
})

test_that("When all rows sum to 1, nothing is returned", {
  expect_null(check_props(dat_props_correct))
})

test_that("When there's no data, nothing is returned", {
  expect_null(check_props(dat_props[6, ]))
})
