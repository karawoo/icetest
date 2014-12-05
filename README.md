# icetest

[![Build Status](https://api.travis-ci.org/karawoo/icetest.png)](https://travis-ci.org/karawoo/icetest)
[![Build status](https://ci.appveyor.com/api/projects/status/vce9mxrisirn94rt?svg=true)](https://ci.appveyor.com/project/karawoo/icetest)

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

### Convert data from horizontal to vertical

The data template is organized horizontally with extra columns describing each
field. This is useful for researchers who are first viewing the template, but
ultimately we will want data to be organized vertically (and all the other
functions in this package require that). The `t_icedata()` function takes data
that has been pasted into the template (horizontal) and converts it to
vertical. However, all columns will be character columns so many will need to be
converted after transposing.

```r
dat_horiz <- read.csv("data_horizontal.csv", stringsAsFactors = FALSE)
dat <- t_icedata(dat_horiz)
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

### Check numeric fields

`check_num()` checks columns that should be numeric and returns the names of any
that aren't, e.g.:

```r
check_num(dat)
# [1] "lakeelevation" "watershedarea" "lakefetch"     "stationlat"
# [5] "stationlong"   "iceduration"   "photicdepth"   "avephytocount"
# [9] "maxphytocount"
```

`fix_num()` attempts to convert columns to numeric but will issue warnings if
there are any that it can't convert. If `coerce == FALSE` (the default), the
function will not leave columns as character if they can't be converted to
numeric automatically. If `coerce == TRUE`, `NA`s will be introduced in any
columns that can't be automatically converted. In both cases warnings will alert
the user to any problem columns.

```r
dat_converted <- fix_num(dat, coerce = FALSE)
# Warning messages:
# 1: In value[[3L]](cond) : Conversion failed in column: watershedarea
# 2: In value[[3L]](cond) : Conversion failed in column: lakefetch
# 3: In value[[3L]](cond) : Conversion failed in column: stationlat
# 4: In value[[3L]](cond) : Conversion failed in column: stationlong
# 5: In value[[3L]](cond) : Conversion failed in column: iceduration
# 6: In value[[3L]](cond) : Conversion failed in column: photicdepth

dat_converted <- fix_num(dat, coerce = TRUE)
# Warning messages:
# 1: In value[[3L]](cond) : NAs introduced in column: watershedarea
# 2: In value[[3L]](cond) : NAs introduced in column: lakefetch
# 3: In value[[3L]](cond) : NAs introduced in column: stationlat
# 4: In value[[3L]](cond) : NAs introduced in column: stationlong
# 5: In value[[3L]](cond) : NAs introduced in column: iceduration
# 6: In value[[3L]](cond) : NAs introduced in column: photicdepth
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

### Check predefined values

Certain fields have a set number of options (e.g. `season` can be `iceon` or
`iceoff` and nothing else). The `check_values()` function will make sure that
values in the following fields are legal: `season` ("iceon" or "iceoff"),
`multiplestations` ("yes" or "no"), `startmonth` and `endmonth` (three letter
abbreviation), `sampletype` ("in situ" or "remote sensed"), `fadata` ("no",
"proportional", or "concentrations"), `gutdata` ("yes" or "no"), `bensubstrate`,
(NA or "organic", "silt", "sand", "rock", "mixed"). If any of these fields
have illegal values, `check_values()` returns a list of them. Example:

```r
check_values(dat)
# $endmonth
# [1] "Sept"
#
# $sampletype
# [1] "other"
#
# $fadata
# [1] "kiwi" NA
#
# $gutdata
# [1] "NA"
```

### Check dates

#### Start date should be before end date.

`check_dates()` will return a data frame of any rows where end date is before
start date.

```r
check_dates(dat)
#   year season lakename stationlat stationlong startday startmonth startyear endday endmonth endyear
# 1 2003  iceon   Lake D   56.09553   -56.39156       20        Feb      2003      3      Jan    2003
# 2 2003 iceoff   Lake D   56.09553   -56.39156       19        Sep      2003      8      Aug    2003
```

#### Ice duration shouldn't be shorter than aggregation period in iceon season.

`check_iceduration_length()` returns a data frame of any rows where ice
duration is shorter than aggregation period.

```r
check_iceduration_length(dat)
#   year season lakename stationlat stationlong startday startmonth startyear endday endmonth endyear iceduration aggperiod
# 1 2004  iceon   Lake D   56.09553   -56.39156        2        Jan      2004     25      Mar    2004          80   83 days
```

#### Ice duration should be zero in iceoff season

`check_iceduration_iceoff()` returns a data frame of any rows where ice
duration is not zero during the iceoff season.

```r
check_iceduration_iceoff(dat)
#   year season lakename iceduration
# 1 2004 iceoff   Lake D          80
```

#### Check `periodn`

`periodn` should be the number of sampling *days*, not the total number of
samples (e.g. if a lake was sampled in one season on two different days at three
depths on each day, `periodn` should be 2, *not* 6). Unfortunately this is not
very clear in the data template (it's a little clearer in the instructions
document). `check_periodn()` returns a data frame of observations where
`periodn` is greater than the number of days in the aggregation period, which is
an imperfect method of identifying cases where researchers used the individual
number of samples at different depths.

```r
check_periodn(dat)
#   year season lakename stationlat stationlong      start        end agg_period periodn
# 1 2002 iceoff   Lake D   56.09553   -56.39156 2002-08-16 2002-08-16     1 days       3
# 2 2004  iceon   Lake D   56.09553   -56.39156 2004-01-02 2004-03-25    84 days     350

```

### Check for repeated observations

There should be only one observation at a given station in a given season.
`check_repeats()` returns a data frame of any duplicated observations.

```r
check_repeats(dat)
#   year season lakename stationlat stationlong
# 4 1975 iceoff   Lake F   48.11363   -138.7702
```

### Check averages and maxima

Many fields have an "average" and "maximum" column. Averages should never be
larger than maxima. `check_avemax()` returns a list of any fields where the
average is greater than the maximum. Example:

```r
check_avemax(dat)
# $totphos
#   year season lakename stationlat stationlong maxtotphos avetotphos
# 4 1981 iceoff   Lake G   53.51569   -137.4344        2.5         10

# $zoopmass
#   year season lakename stationlat stationlong maxzoopmass avezoopmass
# 1 1980  iceon   Lake G   53.51569   -137.4344         999        1000
# 5 1982  iceon   Lake G   53.51569   -137.4344         900         999

# $lakedepth
#   year season lakename stationlat stationlong lakemeandepth lakemaxdepth
# 6 1982 iceoff   Lake G   53.51569   -137.4344           500          250
```

### Check sample depth and photic depth

Sample depth should be equal to or shallower than photic depth. `check_depths()`
returns a data frame of observations where sample depth is deeper than photic
depth. In some cases this may be acceptable if the difference is small; this
will have to be decided on a case-by-case basis.

```r
check_depths(dat)
#   year season stationlat stationlong lakename photicdepth sampledepth
# 3 2001  iceon   48.40392   -125.6284   Lake H          46          50
# 4 2001 iceoff   48.40392   -125.6284   Lake H          39          40
```


Feel free to [submit an issue](https://github.com/karawoo/icetest/issues)
if you have suggestions or notice any bugs.
