#' Transform data from horizontal to vertical.
#' 
#' Converts data from horizontal (matching the data template) to vertical (with
#' field names as column headers) for use with the rest of the functions in
#' this package.
#' 
#' @param dat Data frame to be tested. Should be in the format of the data 
#' template (including the colums 'datacategory', 'dataclass', 'fieldname',
#' and 'fielddescription..follow.format.of.quoted.texts.'). Import with 
#' read.csv("filename.csv", stringsAsFactors = FALSE).
#' 
#' @author Kara Woo
#' 
#' @export

t_icedata <- function(dat) {
  dd <- dat[, grep("fieldname|X", names(dat), value = TRUE)]
  vert <- as.data.frame(t.data.frame(dd[, -1]), stringsAsFactors = FALSE)
  colnames(vert) <- dd[, 1]
  vert
}
