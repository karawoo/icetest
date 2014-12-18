#' Check averages and maxima
#' 
#' Checks that averages are not larger than maxima.
#'
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_avemax <- function(dat, flag) {
  avemax <- grep("^(ave|max)", names(dat), value = TRUE)
  maxs <- grep("^max", avemax, value = TRUE)
  aves <- grep("^ave", avemax, value = TRUE)
  ## keep only averages which have a corresponding max
  aves <- aves[which(substr(aves, 4, 1000) %in% substr(maxs, 4, 1000))]

  ## initialize results
  result <- NULL
  
  ## check if ave is ever greater than max and/or if one of them is ever missing
  ## when the other is not
  if (flag == "values") {
    ## first check fields with names matching the pattern ave* and max*
    if (any(!mapply(`>=`, dat[, maxs], dat[, aves]), na.rm = TRUE)) {
      ## list of each "max" column with booleans for whether it's less than
      ## average or not
      ll <- mapply(`>=`, dat[, maxs], dat[, aves], SIMPLIFY = FALSE)
      ## list of indices of observations that where average > max
      indices <- lapply(ll, function(x) which(!x))
      ## list of data frames of these observations
      tmplist <- lapply(names(indices), function(x) {
        dat[indices[[x]], c("year", "season", "lakename", "stationlat", 
                            "stationlong", x, gsub("max", "ave", x))]
      })
      ## remove empty data frames and create list of results
      result <- tmplist[lapply(tmplist, nrow) > 0]
      names(result) <- gsub("max", "", 
                            names(indices[lapply(indices, length) > 0]))
    }
    ## also check lake mean/max depth
    if (any(!mapply(`>=`, dat[, "lakemaxdepth"], 
                    dat[, "lakemeandepth"]), na.rm = TRUE)) {
      result <- append(result, list(lakedepth = dat[which(dat$lakemeandepth >
                                                            dat$lakemaxdepth), 
                        c("year", "season", "lakename", "stationlat", "stationlong", 
                          "lakemeandepth", "lakemaxdepth")]))
    }
    result
    ## Check for missing values if either average or maximum is present:
  } else if (flag == "missing") {
    if(any(!mapply(function(a, b) mapply(compNA, a, b), dat[, maxs], dat[, aves]))) {
      ll <- mapply(function(a, b) mapply(compNA, a, b), dat[, maxs], dat[, aves],
                   SIMPLIFY = FALSE)
      indices <- lapply(ll, function(x) which(!x))
      tmplist <- lapply(names(indices), function(x) {
        dat[indices[[x]], c("year", "season", "lakename", "stationlat", 
                            "stationlong", x, gsub("max", "ave", x))]
      })
      result <- tmplist[lapply(tmplist, nrow) > 0]
      names(result) <- gsub("max", "",
                            names(indices[lapply(indices, length) > 0]))
    } else {
      result <- NULL
    }
    result
  }
}

#' Compare ave and max for NAs
#'
#' Returns TRUE if both or neither argument is NA; returns FALSE if one is NA but the other is not.
#'
#' @param a first argument
#' @param b second argument
#'
#' @author Kara Woo

compNA <- function(a, b) {
  if (is.na(a) && is.na(b) == TRUE) {
    TRUE    
  } else if (!is.na(a) && !is.na(b) == TRUE) {
    TRUE
  } else if (is.na(a) && !is.na(b) == TRUE) {
    FALSE
  } else if (!is.na(a) && is.na(b) == TRUE) {
    FALSE
  }
}
