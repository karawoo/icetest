# icetest

[![Build Status](https://api.travis-ci.org/karawoo/icetest.png)](https://travis-ci.org/karawoo/icetest)

This is an R package to do some QA/QC on data submitted to the
[under-ice ecology synthesis project](https://www.nceas.ucsb.edu/underice).
It will be used to check all data submitted to the project, but you can also
use it to check your own data before you submit. The package is still under
development, so beware that the behavior of functions may change.

Functions assume that data is structured vertically with `fieldname` as column
headers, and without the other columns present in the template (`dataclass`,
etc.). This means the data is organized differently from the layout of the data
template, but is the easiest way to work with the data for testing. A function
to transform data from the template format to the format used in these
functions is on the to-do list.

### To install:

```r
library('devtools')
devtools::install_github('icetest', 'karawoo')
library('icetest')
```

### Check that column names match the fields in the data template

```r
field_match(dat) # returns TRUE if fields match
# [1] TRUE

field_match(dat) # returns FALSE if fields do not match
# [1] FALSE
```

The `check_fields()` function allows you to determine which fields do not
match. It returns a list of missing fields and extra fields. If all fields
match, nothing is returned.

```r
check_fields(dat)
# $not_in_template
# [1] "extracol"
#
# $not_in_data
# [1] "year"       "season"     "researcher" "lakename"   "lakeregloc"
```

### Check for missing data

Certain fields such as `year`, `season`, `researcher`, and `lakename`,
`stationlat`, `stationlong`, and start/end dates should not have any missing
data. The `check_missing()` function will highlight any fields that have
missing data but shouldn't. Example:


```r
check_missing(dat)
# $missing_data_in_fields
# [1] "researcher" "lakename"
```

### Check proportions of zooplankton and phytoplankton

The data template asks for proportions of different phytoplankton and
zooplankton groups. Proportions should sum to 1. The `check_props()` function
checks that this is the case. If all proportions sum to 1, nothing is returned.
If some proportions do not sum to 1, they are are returned along with
information (`year`, `season`, `lakename`, `stationlat`, `stationlong`) that
will help determine where the incorrect calculations are. An example output of
this function looks like this:

```r
check_props(dat)
# $phyto
#   year season lakename stationlat stationlong proportion
# 4 2003 iceoff   Lake A   56.09323   -56.39756     100.00
# 5 2004 iceoff   Lake A   56.09323   -56.39756       1.01
#
# $zoo
#   year season lakename stationlat stationlong proportion
# 2 2001 iceoff   Lake A   56.09323   -56.39756       0.98
# 4 2003 iceoff   Lake A   56.09323   -56.39756     100.00
```

### On the to-do list:

* Function to convert horizontal data to vertical.
* Check values: certain fields have a set number of options (e.g. `season` can
be `iceon` or `iceoff` and nothing else). Add a function to test that only
allowed values are in these fields.
* Check dates: start date should be before end date; month fields should be
three-letter abbreviations; ice duration shouldn't be shorter than aggregation
period in winter.
* Check averages vs. maxima: when we ask for an average and a max value for a
given measurement, averages should never be greater than maxima.
* ...

Feel free to [submit an issue](https://github.com/karawoo/icetest/issues)
if you have any suggestions or notice any bugs.
