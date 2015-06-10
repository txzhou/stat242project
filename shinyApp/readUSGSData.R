# Downloaded from http://waterdata.usgs.gov/nwis/inventory
# fread saves 2.5s over read.table on just California sites.
sites = fread("../raw_data/inventory", header = TRUE)[-1, ] 
setnames(sites, c("agency", "siteNumber", "siteName", "siteType", 
                  "lat", "long", "coordAccuracy", "datum"))

# Remove 44 problematic rows where lat/long are missing
sites = sites[!is.na(as.numeric(as.character(sites$lat))), ]
sites$lat = as.numeric(as.character(sites$lat))
sites$long = as.numeric(as.character(sites$long))

# To keep the data manageable, for now:
# sites = sites[sample(nrow(sites), 1e3), ]

if(FALSE) {
  surfaceSites = sites[nchar(sites$siteNumber) == 8, ]
  iter = c(seq(1, nrow(surfaceSites), by = 5e2), nrow(surfaceSites))
  dischargeData = whatNWISdata(siteNumbers = surfaceSites$siteNumber[1:5e2], 
                               parameterCd = "00060")
  for(i in 3:length(iter)) {
    tmp = 
      whatNWISdata(siteNumbers = surfaceSites$siteNumber[iter[i - 1] : iter[i]], 
                   parameterCd = "00060")
    dischargeData = rbind(dischargeData, tmp)
  }
  sum(grepl("ST", dischargeData$site_tp_cd)) / nrow(dischargeData)  # .996
  dischargeData$site_tp_cd[!grepl("ST", dischargeData$site_tp_cd)]
  # Others are lakes, and diversion ditches
  
  goodSurfaceData = surfaceSites[surfaceSites$siteNumber %in% dischargeData$site_no, ]
  head(goodSurfaceData)
  saveRDS(goodSurfaceData, "clean_data/goodSurfaceSites.RDS")
}
goodSurfaceData = readRDS("clean_data/goodSurfaceSites.RDS")


gwLevels = readRDS("clean_data/gwLevels.RDS")
gwSites = sites[sites$siteNumber %in% gwLevels$siteNumber, ]

if(FALSE) {
tmp = readNWISgwl(gwSites$siteNumber[1:100])

# gwSelection = unique(tmp$site_no)[1:2]

gwData2 = try(readNWISgwl(gwSelection))
# Since the above line isn't working...
gwData = tmp[tmp$site_no %in% unique(tmp$site_no)[1:10], ]
gwData$siteName = gwSites$siteName[match(gwData$site_no, gwSites$siteNumber)]
}