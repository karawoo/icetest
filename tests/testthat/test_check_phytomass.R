context("Check phytoplankton biomass")

dat_phyto <- data.frame(year        = c(2002, 2002, 2003, 2003, 2004, 2004),
                        season      = rep(c("iceon", "iceoff"), 3),
                        lakename    = rep("Lake Diggity Dog", 6),
                        avephytomass = c(1, rep(NA, 5)),
                        cvphytomass = c(NA, 0, rep(NA, 4)),
                        maxphytomass = rep(NA, 6),
                        aveciliamass = rep(NA, 6),
                        cvciliamass = rep(NA, 6),
                        maxciliamass = rep(NA, 6),
                        avehnfmass = c(rep(NA, 5), 1),
                        cvhnfmass = rep(NA, 6),
                        maxhnfmass = rep(NA, 6),
                        stringsAsFactors = FALSE)

test_that("Warning is thrown when phyto/cilia/hnf mass is present", {
  expect_warning(check_phytomass(dat_phyto))
  expect_warning(check_phytomass(dat_phyto[1, ]))
  expect_warning(check_phytomass(dat_phyto[6, ]))
  expect_null(check_phytomass(dat_phyto[3:5, ]))
})
