plot.USGS = function(siteNumber) {
  plot = try(plot.discharge(siteNumber = siteNumber))

  require(ggplot2)
  null.plot = qplot(x = 0, y = 0)

  if ((class(plot)[[1]] != "try-error")) {
    return(list(0, plot))
  } else {
    return(list(1, null.plot))
  }
}

plot.discharge.2 = function(siteNumber,
                            startDate = NULL,
                            endDate = NULL) {
  require(dataRetrieval)

  surfaceData = try(readNWISmeas(siteNumbers = siteNumber))

  stopifnot("measurement_dt" %in% names(surfaceData))
  stopifnot("discharge_va" %in% names(surfaceData))
  stopifnot("gage_height_va" %in% names(surfaceData))

  siteInfo = attr(surfaceData, "siteInfo")

  if (!is.null(startDate))
    surfaceData = surfaceData[surfaceData$measurement_dt >= as.POSIXct(startDate), ]

  if (!is.null(endDate))
    surfaceData = surfaceData[surfaceData$measurement_dt <= as.POSIXct(endDate), ]

  require(ggplot2)
  plot = ggplot(data = surfaceData, aes(x = measurement_dt, y = discharge_va)) +
    geom_point() +
    geom_line() +
    xlab("Date") +
    ylab("Discharge, cubic feet per second") +
    ggtitle(siteInfo$station_nm)

  return(plot)
}


plot.discharge = function(siteNumber,
                          parameterCd = "00060") {
  require(dataRetrieval)

  data = readNWISdv(siteNumber,
                    parameterCd)

  data = renameNWISColumns(data)

  stopifnot("Flow" %in% names(data))

  variableInfo = attr(data, "variableInfo")
  siteInfo = attr(data, "siteInfo")

  require(ggplot2)
 ggplot(data = data, aes(x = Date, y = Flow)) +
    geom_line() +
    xlab("Date") +
    ylab(variableInfo$parameter_desc) +
    theme_bw() +
    scale_y_log10() +
    ggtitle(paste0("Daily warter discharge at: ", siteInfo$station_nm))

#  return(plot)
}

gwPlot = function(siteNum)
{
  ggplot(gwLevels[gwLevels$siteNumber %in% siteNum, ], 
         aes(x = date, 
             # y = log10(level), 
             y = level,
             color = siteNumber)) +
    scale_y_reverse() + 
    scale_x_date(limits = c(as.Date("2011-10-01"), Sys.Date())) +
    geom_line() +
    geom_point() +
#    ylab("Depth, log10(feet)") +
    ylab("Depth (feet)") +
    xlab("Date") +
    theme_bw()
}
