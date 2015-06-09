latlong2county <- function(pointsDF, wantState = FALSE) {
  # Taken verbetim from http://stackoverflow.com/questions/13316185
  # Prepare SpatialPolygons object with one SpatialPolygon
  # per county
  counties <- map('county', fill=TRUE, col="transparent", plot=FALSE)
  IDs <- sapply(strsplit(counties$names, ":"), function(x) x[1])
  counties_sp <- map2SpatialPolygons(counties, IDs=IDs,
                                     proj4string=CRS("+proj=longlat +datum=wgs84"))

  # Convert pointsDF to a SpatialPoints object
  pointsSP <- SpatialPoints(pointsDF,
                            proj4string=CRS("+proj=longlat +datum=wgs84"))

  # Use 'over' to get _indices_ of the Polygons object containing each point
  indices <- over(pointsSP, counties_sp)

  # Return the county names of the Polygons object containing each point
  countyNames <- sapply(counties_sp@polygons, function(x) x@ID)

  county = strsplit(countyNames[indices], ",")[[1]]

  if(wantState) { county
  } else {
    county[2]
  }
}

color.map = function(color.variable = 1L, year.map) {
  # adapted from the example in the help doc of "map()" function.

  # manipulate the water dataset so that we can match it to the map data.
  df.water.cal = water.consum.data(long = FALSE, year= year.map)
  if(year.map == 2010){
  df.water.cal$cal.County = sapply(X = strsplit(x = levels(df.water.cal$County), split = ' County'),
                                   FUN = function(x) x[[1]])
  } else {
    df.water.cal$cal.County=df.water.cal$County
  }
  df.water.cal$polyname = paste0("california,", tolower(df.water.cal$cal.County))

  # define color buckets
  colors = c("#fee5d9",
             "#fcbba1",
             "#fc9272",
             "#fb6a4a",
             "#de2d26",
             "#a50f15")

  if (color.variable == 1L) {
    df.water.cal$colorBuckets <- as.numeric(cut(df.water.cal$Percent, breaks = c(0, 0.01, 1:5*0.02)))
    leg.txt <- c("<1%", "1-2%", "2-4%", "4-6%", "6-8%", "8-10%")
    title.txt <- "County consumption:\n% of California total"
  } else if (color.variable == 2L) {
    df.water.cal$colorBuckets <- as.numeric(cut(df.water.cal$Per.Cap, breaks = c(0, 1, 5, 10, 20, 40)))
    leg.txt <- c("<1", "1-5", "5-10", "10-20", ">20")
    title.txt <- "Per Capita Consumption \n (Mgal/day/1000 people)"
  }


  # align data with map definitions by (partial) matching state,county
  # names, which include multiple polygons for some counties
  colorsmatched <- df.water.cal$colorBuckets[match(map(database = "county", regions = "california", plot=FALSE)$names,
                                                   df.water.cal$polyname)]

  # draw map
  map(database = "county", regions = "california", col = colors[colorsmatched], fill = TRUE, resolution = 0,
      lty = 1)
  # the following lines might be useful if we draw the map for the whole U.S.
  #   map("state", col = "white", fill = FALSE, add = TRUE, lty = 1, lwd = 0.2,
  #       projection="polyconic")
  
  #INCLUDING CITIES
  #data(us.cities)
  #cities <- c("^San Francisco", "^West Sacramento", "^Los Angeles", "^San Diego", "^Fresno")
  #city.index <- sapply(cities , function(x){grep(x, us.cities[ ,1])})
  #map.cities(us.cities[city.index, ], country = "CA", label = TRUE, pch = 16, col = "black", cex = 1.5, font = 2)
  title(title.txt)
  legend("topright", leg.txt, fill = colors)
}

simpleCap <- function(x) {
  # From toupper() help file.
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}