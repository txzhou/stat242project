# Downloaded via: http://waterservices.usgs.gov/rest/GW-Levels-Test-Tool.html
# query: http://waterservices.usgs.gov/nwis/gwlevels/?format=rdb&stateCd=ca&startDT=2011-10-01&endDT=2015-06-09&siteType=GW&siteStatus=active
gwTest = fread("../raw_data/gwData.txt", header = TRUE)[-1, ] 
gwTest = gwTest[, c("site_no", "lev_dt", "lev_va"), with = FALSE]
setnames(gwTest, c("siteNumber", "date", "level"))
set(gwTest, j = 'level', value = as.numeric(gwTest[['level']]))
set(gwTest, j = 'date', value = as.Date(gwTest[['date']]))
saveRDS(gwTest, "clean_data/gwLevels.RDS")
