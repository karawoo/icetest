###########################################################
####  Sample script for checking under-ice ecology data  ##
###########################################################

if (!"icetest" %in% installed.packages()) {
  if (!"devtools" %in% installed.packages()) {
    install.packages("devtools")
  }
  library("devtools")
  install_github("karawoo/icetest")
}

library("icetest")

### Load data in template format
#data_horiz <- read.csv("/path/to/file.csv", stringsAsFactors = FALSE)

### Convert to vertical format
#vdata <- t_icedata(data_horiz)

### Do field names match those in the template? 
field_match(vdata)
check_fields(vdata) # returns a list of any missing or extra fields

### Convert character columns to numeric
vdata_nums <- fix_num(vdata, coerce = FALSE)

### Are all the fields that should be numeric actually numeric? 
check_num(vdata_nums)

### Check for fields that have missing data but shouldn't
check_missing(vdata_nums)

### Do proportions sum to 1?
check_props(vdata_nums)

### Check fields that have predefined values
check_values(vdata_nums)

### Check dates:
### - start date should be before end date
### - ice duration shouldn't be longer than aggregation period in iceon season
### - ice duration should be NA or 0 in iceoff season (template says NA but 0 also
### makes sense)
### - periodn should not be smaller than number of days in the aggregation
### period
check_dates(vdata_nums)
check_iceduration_length(vdata_nums)
check_iceduration_iceoff(vdata_nums)
check_periodn(vdata_nums)

### Check for any repeat values (station/year combos)
check_repeats(vdata_nums)

### Average should never be greater than max, and both (or neither) average and
### maximum should be reported. NULL indicates all is ok.
check_avemax(vdata_nums, flag = "values")
check_avemax(vdata_nums, flag = "missing")

### Is sample depth ever greater than photic depth?
check_depths(vdata_nums)

### Is there phytoplankton biomass data? If so, follow up with researcher to
### convert units to biovolume
check_phytomass(vdata_nums)

### Check values in nitrogen and DOC data
check_nitro(vdata_nums)
icetest::check_doc(vdata_nums) ## (devtools has a check_doc fxn too)
