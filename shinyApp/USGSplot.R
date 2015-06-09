plot.USGS = function(siteNumber) {
  plot1 = try(plot.discharge(siteNumber = siteNumber))
  cat(class(plot1))
  if ((class(plot1)[[1]] != "try-error")) {
    return(plot1)
  }

  plot2 = try(plot.surface(siteNumber = siteNumber))
  cat(class(plot2))
  return(plot2)
}

plot.surface = function(siteNumber = "11454000",
                               startDate = "2010-01-01",
                               endDate = "2010-12-31") {
  require(dataRetrieval)

  surfaceData = readNWISmeas(siteNumber)
  stopifnot("measurement_dt" %in% names(surfaceData))
  stopifnot("discharge_va" %in% names(surfaceData))
  stopifnot("gage_height_va" %in% names(surfaceData))

  siteInfo = attr(surfaceData, "siteInfo")

  surfaceData = surfaceData[surfaceData$measurement_dt >= as.POSIXct(startDate) &
                              surfaceData$measurement_dt <= as.POSIXct(endDate), ]

  require(ggplot2)
  plot = ggplot(data = surfaceData, aes(x = measurement_dt, y = discharge_va)) +
    geom_point() +
    geom_line() +
    xlab("Date") +
    ylab("Discharge, cubic feet per second") +
    ggtitle(siteInfo$station_nm)

  return(plot)
}


plot.discharge = function(siteNumber = "09423350",
                          parameterCd = "00060") {
  require(dataRetrieval)

  data = readNWISdv(siteNumber,
                    parameterCd)

  data = renameNWISColumns(data)

  stopifnot("Flow" %in% names(data))

  variableInfo = attr(data, "variableInfo")
  siteInfo = attr(data, "siteInfo")

  require(ggplot2)
  plot = ggplot(data = data, aes(x = Date, y = Flow)) +
    geom_line() +
    xlab("Date") +
    ylab(variableInfo$parameter_desc) +
    ggtitle(paste0("Daily warter discharge at: ", siteInfo$station_nm))

  return(plot)
}
