#' Check averages and maxima
#' 
#' Checks that averages are not larger than maxima.
#'
#' @param dat Data frame to be tested.
#' 
#' @author Kara Woo
#' 
#' @export

check_avemax <- function(dat) {
  avemax <- grep("^(ave|max)", names(dat), value = TRUE)
  maxs <- grep("^max", avemax, value = TRUE)
  aves <- grep("^ave", avemax, value = TRUE)
  ## keep only averages which have a corresponding max
  aves <- aves[which(substr(aves, 4, 1000) %in% substr(maxs, 4, 1000))]
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
    ## remove empty data frames
    result <- tmplist[lapply(tmplist, nrow) > 0]
    names(result) <- gsub("max", "", 
                          names(indices[lapply(indices, length) > 0]))
  }
  ## also check lake mean/max depth
  if (any(!mapply(`>=`, dat[, "lakemaxdepth"], 
                  dat[, "lakemeandepth"]), na.rm = TRUE)) {
    depth <- list(lakedepth = dat[which(dat$lakemeandepth > dat$lakemaxdepth), 
                      c("year", "season", "lakename", "stationlat", "stationlong", 
                        "lakemeandepth", "lakemaxdepth")])
  }
  
  if (exists("result") & exists("depth")) {
    final <- append(result, depth)
    final
  } else if (exists("result")) {
    final <- result
    final
  } else if (exists("depth")) {
    final <- depth
    final
  }
}

