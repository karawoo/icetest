context("Check DOC values")

dat_doc <- data.frame(avetotdoc = c(2, NA,   0,  NA, 3000, NA),
                      maxtotdoc = c(5, 4000, NA, NA, 5000, 200))


test_that("Warning is thrown when values >= 200 are present", {
            expect_warning(check_doc(dat_doc))
            expect_warning(check_doc(dat_doc[6, ]))
          })

test_that("No warning when values <= 200 or NA", {
            expect_null(check_doc(dat_doc[1, ]))
            expect_null(check_doc(dat_doc[3:4, ]))
          })
