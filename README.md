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
template, but is the easiest way to work with the data for testing. Use the
`t_icedata()` function to transform data from the template format to vertical.

### To install:

```r
library('devtools')
devtools::install_github('karawoo/icetest')
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
#   year season lakename stationname stationlat stationlong proportion
# 4 2003 iceoff   Lake A      Az78.1   56.09323   -56.39756     100.00
# 5 2004 iceoff   Lake A      Az78.1   56.09323   -56.39756       1.01

# $zoo
#   year season lakename stationname stationlat stationlong proportion
# 2 2001 iceoff   Lake A      Az78.1   56.09323   -56.39756       0.98
# 4 2003 iceoff   Lake A      Az78.1   56.09323   -56.39756     100.00
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
#   year season lakename stationname stationlat stationlong startday startmonth
# 1 2003  iceon   Lake D   Station A   56.09553   -56.39156       20        Feb
# 2 2003 iceoff   Lake D   Station A   56.09553   -56.39156       19        Sep
#   startyear endday endmonth endyear
# 1      2003      3      Jan    2003
# 2      2003      8      Aug    2003
```

#### Ice duration shouldn't be shorter than aggregation period in iceon season.

`check_iceduration_length()` returns a data frame of any rows where ice
duration is shorter than aggregation period.

```r
check_iceduration_length(dat)
#   year season lakename stationname stationlat stationlong startday startmonth
# 1 2004  iceon   Lake D   Station A   56.09553   -56.39156        2        Jan
#   startyear endday endmonth endyear iceduration aggperiod
# 1      2004     25      Mar    2004          80   83 days
```

#### Ice duration should be zero in iceoff season

`check_iceduration_iceoff()` returns a data frame of any rows where ice
duration is not zero during the iceoff season.

```r
check_iceduration_iceoff(dat)
#   year season lakename stationname iceduration
# 1 2004 iceoff   Lake D   Station A          80
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
#   year season lakename stationname stationlat stationlong      start        end
# 1 2002 iceoff   Lake D   Station A   56.09553   -56.39156 2002-08-16 2002-08-16
# 2 2004  iceon   Lake D   Station A   56.09553   -56.39156 2004-01-02 2004-03-25
#   agg_period periodn
# 1     1 days       3
# 2    84 days     350
```

### Check for repeated observations

There should be only one observation at a given station in a given season.
`check_repeats()` returns a data frame of any duplicated observations.

```r
check_repeats(dat)
#   year season lakename stationname stationlat stationlong
# 2 1975 iceoff   Lake F        9011   48.11363   -138.7702
# 4 1975 iceoff   Lake F        9011   48.11363   -138.7702
```

### Check averages and maxima

Many fields have an "average" and "maximum" column. Averages should never be
larger than maxima. `check_avemax()` with `flag = "values"` returns a list of
any fields where the average is greater than the maximum. Example:

```r
check_avemax(dat, flag = "values")
# $totphos
#   year season lakename  stationname stationlat stationlong maxtotphos
# 4 1981 iceoff   Lake G Hat Rack Bay   53.51569   -137.4344        2.5
#   avetotphos
# 4         10

# $zoopmass
#   year season lakename  stationname stationlat stationlong maxzoopmass
# 1 1980  iceon   Lake G Hat Rack Bay   53.51569   -137.4344         999
# 5 1982  iceon   Lake G Hat Rack Bay   53.51569   -137.4344         900
#   avezoopmass
# 1        1000
# 5         999

# $lakedepth
#   year season lakename  stationname stationlat stationlong lakemeandepth
# 8 1983 iceoff   Lake G Hat Rack Bay   53.51569   -137.4344           500
#   lakemaxdepth
# 8          250
```

If an average is repoted, a maximum should also be reported (and vice versa). In
some cases (if values are calculated based on a single sample) these numbers
will be the same; this is okay. `check_avemax()` with `flag = "missing"`
identifies any cases where either average or maximum, but not both, are
reported.

```r
check_avemax(dat, flag = "missing")
#$totphos
#   year season lakename  stationname stationlat stationlong maxtotphos
# 7 1983  iceon   Lake G Hat Rack Bay   53.51569   -137.4344         NA
#   avetotphos
# 7       0.25

# $zoopmass
#   year season lakename  stationname stationlat stationlong maxzoopmass
# 8 1983 iceoff   Lake G Hat Rack Bay   53.51569   -137.4344         900
#   avezoopmass
# 8          NA
```

### Check sample depth and photic depth

Sample depth should be equal to or shallower than photic depth. `check_depths()`
returns a data frame of observations where sample depth is deeper than photic
depth. In some cases this may be acceptable if the difference is small; this
will have to be decided on a case-by-case basis.

```r
check_depths(dat)
#   year season stationname stationlat stationlong lakename photicdepth
# 3 2001  iceon        5830   48.40392   -125.6284   Lake H          46
# 4 2001 iceoff        5830   48.40392   -125.6284   Lake H          39
#   sampledepth
# 3          50
# 4          40
```

### Check for phytoplankton biomass data

We originally asked for phytoplankton biomass in units of ug dry weight / liter,
however after talking with researchers we determined that biovolume is a better
measurement. The `check_phytomass()` function throws a warning if biomass data is
present for phytoplankton, ciliates, or heterotrophic nanoflagellates so that we
can follow up with the researcher about converting the units.

```r
check_phytomass(dat)
Warning message:
In check_phytomass(dat) :
  Phyto/ciliate/HNF biomass present. Follow up with researcher about converting to biovolume
```

### Check nutrient values

#### DOC

We originally asked for DOC data in units of μg/l, however mg/l was provided by
most researchers and is a more standard unit. If DOC is in the hundreds or
thousands, it is likely in μg/l and we should follow up with researchers and
likely convert their data. `check_doc()` Throws a warning if DOC values are >=
200.

```r
check_doc(dat)
Warning message:
In check_doc(dat) :
  DOC data values exceed 200. These data are likely reported in units of ug/l. Check with researchers before converting to mg/l.
```

#### Nitrogen

Some researchers have reported data in mg/l instead of μg/l. This function
throws a warning if values are <= 15 and we should follow up in those
cases. This also returns a data frame of any observations where dissolved
nitrogen is greater than total nitrogen.

```r
check_nitro(dat)
##   year season      lakename stationname stationlat stationlong avetotnitro
## 1 2000  iceon Lake Nitrogen          4B      57.34      -137.7         450
##   maxtotnitro avetotdissnitro maxtotdissnitro
## 1         500            1000            1001
Warning message:
In check_nitro(dat_nitro) :
  Nitrogen data values exist that are under 15. These data may have been reported in units of mg/l. Check with researchers before converting to ug/l.
```

### Check for negative values

None of the numeric columns in this data (with the exception of station latitude
and longitude) should be allowed to contain negative values. `check_neg()`
returns a data frame of any observations that contain negative values.

```r
check_neg(dat)
##   year season lakename stationname stationlat stationlong avetotdissnitro
## 1 2010  iceon   Lake I          NA   48.40387   -125.6281              NA
## 3 2012  iceon   Lake I          NA   48.40387   -125.6281          -439.1
##   propcalanoid cvsuva
## 1         -0.3    0.0
## 3           NA   -0.1
```

Feel free to [submit an issue](https://github.com/karawoo/icetest/issues)
if you have suggestions or notice any bugs.

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
