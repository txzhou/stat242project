# Downloaded from http://waterdata.usgs.gov/nwis/inventory
# fread saves 2.5s over read.table on just California sites.
# colClasses removes 44 problematic sites where lat/long are missing
sites = fread("../raw_data/inventory",
              skip = 26, header = TRUE)[-1, ] 
setnames(sites, c("siteNumber", "siteName", "siteType", 
                  "lat", "long", "agency", "datum"))

# Remove 44 problematic rows where lat/long are missing
sites = sites[!is.na(as.numeric(as.character(sites$lat))), ]
sites$lat = as.numeric(as.character(sites$lat))
sites$long = as.numeric(as.character(sites$long))

# To keep the data manageable, for now:
sites = sites[sample(nrow(sites), 1e3), ]
