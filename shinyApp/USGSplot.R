plot.surface = function(siteNumber = "11454000",
                               startDate = "2010-01-01",
                               endDate = "2010-12-31") {
  require(dataRetrieval)

  surfaceData = readNWISmeas(siteNumber)
  stopifnot("discharge_va" %in% names(surfaceData))
  stopifnot("gage_height_va" %in% names(surfaceData))

  surfaceData = surfaceData[surfaceData$measurement_dt >= as.POSIXct(startDate) &
                              surfaceData$measurement_dt <= as.POSIXct(endDate), ]

  siteInfo = attr(surfaceData, "siteInfo")

  par(mar=c(5,5,5,5)) #sets the size of the plot window
  plot(surfaceData$measurement_dt, surfaceData$gage_height_va,
       ylab="Gage Height, feet",xlab="" )
  par(new=TRUE)
  plot(surfaceData$measurement_dt, surfaceData$discharge_va,
       col="red",type="l",xaxt="n",yaxt="n",xlab="",ylab="",axes=FALSE
  )
  axis(4,col="red",col.axis="red")
  mtext("Discharge, cubic feet per second",side=4,line=3,col="red")
  title(paste(siteInfo$station_nm))
  legend("topleft", legend = c("ft", "ft3/s"),
         col=c("black","red"),lty=c(NA,1),pch=c(1,NA))
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
    ggtitle(siteInfo$station_nm)

  return(plot)
}

gwPlot = function(siteNum)
{
  ggplot(gwLevels[gwLevels$siteNumber == siteNum, ], 
         aes(x = date, 
             # y = log10(level), 
             y = level)) +
#           color = siteNumber)) +
    scale_y_reverse() + 
    scale_x_date(limits = c(as.Date("2011-10-01"), Sys.Date())) +
    geom_line() +
    geom_point() +
#    ylab("Depth, log10(feet)") +
    ylab("Depth (feet)") +
    xlab("Date") +
    theme_bw()
}