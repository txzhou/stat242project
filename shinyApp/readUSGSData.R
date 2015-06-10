sites = readRDS("clean_data/allSites.RDS")

goodSurfaceData = readRDS("clean_data/goodSurfaceSites.RDS")

gwLevels = readRDS("clean_data/gwLevels.RDS")
gwSites = sites[sites$siteNumber %in% gwLevels$siteNumber, ]