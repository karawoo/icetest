#' Check field names
#' 
#' Match column names to data template fields. Returns a list with two elements:
#' column names in the data frame that are not present in the template, and 
#' fields in the template that are missing from the data frame. Result is NULL
#' if all fields match.
#' 
#' @param dat Data frame to be tested.
#'    
#' @author Kara Woo
#' 
#' @export


check_fields <- function(dat) {
  if (!isTRUE(all.equal(names(dat), datafields))) {
    a <- names(dat)[is.na(match(names(dat), datafields))]
    b <- datafields[is.na(match(datafields, names(dat)))]
    result <- list(not_in_template = a, 
                   not_in_data = b)
    result
  }
}


#' Field match
#' 
#' Checks field names and returns TRUE if all column names match template
#' names, FALSE if names do not match.
#' 
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

field_match <- function(dat) {
  if (is.null(check_fields(dat))) {
    TRUE
  } else {
    FALSE
  }
}

