context("Check fields")

### sample

# data frame with matching names
dat_match <- setNames(data.frame(t(data.frame(rep(4, length(datafields))))), 
                      datafields)

# data frame with missing names
dat_missing <- data.frame("year" = c(1989, 1989), 
                          "season" = c("iceon", "iceoff"), 
                          "lakename" = c("Lake Awesome", "Lake Awesome"), 
                          stringsAsFactors = FALSE)

# data frame with names not in template
dat_extra <- data.frame(dat_match, "extracol" = 4)

# some missing and some extra
dat_both <- cbind(dat_match[, -c(1:5)], "extracol" = 4)


### tests

test_that("When fields match no list is returned", {
  expect_equal(length(check_fields(dat_match)), 0)
})

test_that("When fields don't match a list of mismatched elements is returned", {
  expect_true(length(check_fields(dat_missing)[["not_in_data"]]) > 0)
  expect_true(length(check_fields(dat_extra)[["not_in_template"]]) > 0 )
  expect_true(length(check_fields(dat_both)[["not_in_data"]]) > 0 
              & length(check_fields(dat_both)[["not_in_template"]]) > 0)
})

test_that("field_names returns TRUE when fields match, FALSE otherwise", {
  expect_true(field_match(dat_match))
  expect_false(field_match(dat_missing))
  expect_false(field_match(dat_extra))
  expect_false(field_match(dat_both))
})

