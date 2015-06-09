library(shiny)
library(maps)
library(mapdata)
library(maptools)
library(Hmisc)
library(ggplot2)
library(reshape2)

#path.app <- "C:/Users/Athena/Desktop/project/shinyApp/"
#path.toapp <- "C:/Users/Athena/Desktop/project"

#setwd(path.app)

source(file = "plot.R")  # Modified this so it brings df.long into the workspace
source(file = "functions.R")

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
    
    color.map(color.variable = select.box, year.map = as.numeric(input$year))
  })

  output$countyText <- renderPrint({
    cat("That's ", simpleCap(theCounty()), " county.")

  })
  
  output$useagePlot = 
    renderPlot(
      gg.wrapper(county.name = theCounty(), year.gg = as.numeric(input$year))
  )
})

