#path.app <- "C:/Users/Athena/Desktop/project/shinyApp/"
#path.toapp <- "C:/Users/Athena/Desktop/project"

#setwd(path.app)

# source files ####
source(file = "functions.R")
source(file = "plot.R")  # Modified this so it brings df.long into the workspace
source(file = "readUSGSData.R")
source(file = "USGSplot.R")

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
        is.na(theCounty())   |
        !any( grepl(theCounty(), counties) )
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
    
    color.map(color.variable = select.box, year.map = as.numeric(input$year))
  })
  
  output$countyText <- renderPrint({
    cat("That's ", simpleCap(theCounty()), " county.")
    
  })
  
  observe({
    output$useagePlot =
      renderPlot(
        gg.wrapper(county.name = theCounty(), year.gg = as.numeric(input$year))
      )
  })
  
  output$siteMap <- renderLeaflet({
    leaflet(data = goodSurfaceData) %>%
      addProviderTiles("Esri.WorldTopoMap") %>%
      addCircleMarkers(~long, ~lat, layerId = ~ siteNumber, radius = 2)
  })
  
  observe({
    if(!is.null(input$siteMap_marker_click$id))
      output$sitePlot = renderPlot({
        plot.discharge(siteNumber = input$siteMap_marker_click$id)
      })
  })
  
  output$gwMap <- renderLeaflet({
    leaflet(data = gwSites) %>%
      addProviderTiles("Esri.WorldTopoMap") %>%
      addCircleMarkers(~long, ~lat, layerId = ~ siteNumber, 
                       color = "red", radius = 2)
  })
  
  observe({
    if(!is.null(input$gwMap_marker_click$id))
      output$GWPlot = renderPlot({
        gwPlot(input$gwMap_marker_click$id)
      })
  })
  
  if(FALSE){
    theGWSites = reactiveValues()
    theGWSites$sites = 374004122092106 # character(0)
    
    # On gw-map click, if well isn't in the vector to be plotted, add it.
    observe({
      if(!is.null(input$gwMap_marker_click$id) &
           !input$gwMap_marker_click$id %in% theGWSites$sites) {
        nextWell <- isolate(input$gwMap_marker_click$id)
        if(!nextWell %in% theGWSites$sites)
          isolate(theGWSites$sites <- c(theGWSites$sites, nextWell))
      }
    })
    
    observe({
      if(input$clear > 0) {
        theGWSites$sites = 374004122092106  # ""
      }
    })
    
    output$wellsInfo =
      renderPrint(cat("Plotting wells:", theGWSites$sites, sep = "\n"))
    
    output$GWPlot = renderPlot({
      gwPlot(theGWSites$sites)
    })
    
  }
  
})


