library(shiny)
library(maps)
library(leaflet)
library(mapdata)
library(maptools)
library(Hmisc)
library(ggplot2)
library(reshape2)
library(dataRetrieval)
library(data.table)

#path.app <- "C:/Users/Athena/Desktop/project/shinyApp/"
#path.toapp <- "C:/Users/Athena/Desktop/project"

#setwd(path.app)

source(file = "plot.R")  # Modified this so it brings df.long into the workspace
source(file = "functions.R")
source("readUSGSData.R")

shinyServer(function(input, output) {
  
  theCounty = reactive({
    if(is.null(input$plotclick))
      return("none")
    latlong2county(
      data.frame(x = input$plotclick$x, y = input$plotclick$y))
  })
  
  
  # Test whether theCounty() is valid, for startup and bad clicks, to not
  # display charts on ui side. Idea from https://gist.github.com/ptoche/8312791
  output$badCounty <- renderText({
    if(
      theCounty() == "none" |
         is.na(theCounty())  # |
         #!any( grepl(theCounty(), tolower(df$County)) )
       ) {
      return(1) 
    } else { 
      return(0) 
    }
  })
  
  output$theMap <- renderPlot({
    # color.variable == 1L or 2L (can include more variables)
    # see functions.R for detail.
    select.box <- switch(input$metric,
           "Percent of California Consumption" = 1L,
           "Per Capita Consumption" = 2L)
    
    color.map(color.variable = select.box)
  })

  output$countyText <- renderPrint({
    cat("That's ", simpleCap(theCounty()), " county.")

  })
  
  output$useagePlot = 
    renderPlot(
      gg.wrapper(county.name = theCounty())
  )
  
  
  # Spatial pattern is weird; sites do exist in CV. Address this later.
  output$siteMap <- renderLeaflet({
    leaflet(data = sites) %>% 
      addProviderTiles("Stamen.TonerLite") %>%
      addProviderTiles("MapQuestOpen.Aerial", 
                       options = providerTileOptions(opacity = .5)) %>%
      addCircleMarkers(~long, ~lat, layerId = ~ siteNumber, radius = 1)
    # popup = ~siteNumber, 
  })
  
  output$mapClick = renderPrint(cat("That's site #",
                                    input$siteMap_marker_click$id))
})