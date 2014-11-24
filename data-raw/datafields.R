template <- read.csv("./data-raw/IceEcologyDataTemplate_17Nov2014.csv", 
                     stringsAsFactors = FALSE)

# all field names
datafields <- template$fieldname

# fields that should be numeric
numfields <- c("year", "lakearea", "lakemeandepth", "lakemaxdepth", 
               "lakeelevation", "watershedarea", "h2oresidence", "lakefetch", 
               "stationdistance", "stationdepth", "stationlat", "stationlong", 
               "startday", "startyear", "endday", "endyear", "iceduration", 
               "periodn", "photicdepth", "sampledepth", "icedepth", "snowdepth",
               "watertemp", "airtemp", "averadiation", "avesecchidepth",
               "avetotphos", "maxtotphos", "avetotdissphos", "maxtotdissphos", 
               "avetotnitro", "maxtotnitro", "avetotdissnitro", 
               "maxtotdissnitro", "avetotdoc", "maxtotdoc", "avesuva",
               "maxsuva", "avecolor", "maxcolor", "avechla", "maxchla", 
               "avephytoppr", "maxphytoppr", "avephytomass", "maxphytomass", 
               "avephytocount", "maxphytocount", "propchloro", "propcrypto",
               "propcyano", "propdiatom", "propdino", "propotherphyto", 
               "aveciliamass", "maxciliamass", "aveciliacount", "maxciliacount",
               "avehnfmass", "maxhnfmass", "avehnfcount", "maxhnfcount", 
               "avezoopmass", "maxzoopmass", "avezoopcount", "maxzoopcount", 
               "propdaphnia", "propothercladoc", "propcyclopoid", 
               "propcalanoid", "proprotifer", "propotherzoop", "avebactcount", 
               "maxbactcount", "avebactprod", "maxbactprod", "avebenalgalmass", 
               "maxbenalgalmass", "avebenchla", "maxbenchla", "benamphdens", 
               "bengastrodens", "benbivalvedens", "beninsectdens",
               "benoligodens", grep("cv", datafields, value = TRUE))

# saves data to R/sysdata.rda
use_data(datafields, numfields, internal = TRUE, overwrite = TRUE)
