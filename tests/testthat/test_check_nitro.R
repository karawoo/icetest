context("Check nitrogen values")

dat_nitro <- data.frame(year            = rep(2000, 6),
                        season          = rep(c("iceon", "iceoff"), 3),
                        lakename        = rep("Lake Nitrogen", 6),
                        stationname     = c("4B", "4B", "9S", "9S", "3N", "3N"),
                        stationlat      = c(57.34, 57.34, 57.33, 57.33, 57.35,
                                            57.35),
                        stationlong     = c(-137.70, -137.70, -137.71, -137.71,
                                            -137.69, -137.69),
                        avetotnitro     = c(450, 10, 200, 2000, NA, 600),
                        maxtotnitro     = c(500, 15, 200, NA, NA, 650),
                        avetotdissnitro = c(1000, 8, 200, 0.5, NA, 300),
                        maxtotdissnitro = c(1001, 9, 200, 4.5, NA, 350))

test_that("Warning when values are <= 15", {
            expect_warning(check_nitro(dat_nitro))
            expect_warning(check_nitro(dat_nitro[2, ]))
          })

test_that("Fxn returns data frame when totnitro is smaller than totdissnitro", {
            expect_true(nrow(check_nitro(dat_nitro[1, ])) > 0)
          })

test_that("Function returns NULL when values are in range", {
            expect_null(check_nitro(dat_nitro[6, ]))
            expect_null(check_nitro(dat_nitro[5, ]))
          })
