# Downloaded from http://waterdata.usgs.gov/nwis/inventory
# fread saves 2.5s over read.table on just California sites.
sites = fread("../raw_data/inventory", header = TRUE)[-1, ] 
setnames(sites, c("agency", "siteNumber", "siteName", "siteType", 
                  "lat", "long", "coordAccuracy", "datum"))

# Remove 44 problematic rows where lat/long are missing
sites = sites[!is.na(as.numeric(as.character(sites$lat))), ]
sites$lat = as.numeric(as.character(sites$lat))
sites$long = as.numeric(as.character(sites$long))

saveRDS(sites, "clean_data/allSites.RDS")

# Filter to sites where discharge data is available
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
saveRDS(goodSurfaceData, "clean_data/goodSurfaceSites.RDS")