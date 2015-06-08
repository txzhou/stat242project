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
