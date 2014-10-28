template <- read.csv("./data-raw/IceDataTemplate-Beta2_draft2_24Oct2014.csv", 
                     stringsAsFactors = FALSE)

datafields <- template$fieldname

# saves data to R/sysdata.rda
use_data(datafields, internal = TRUE)
