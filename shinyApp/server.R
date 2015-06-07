library(shiny)
library(maps)
library(mapdata)
library(maptools)
library(Hmisc)
library(ggplot2)
library(reshape2)
# setwd("Dropbox/Coursework/9_Spring_15/STA242/project/shinyApp/")
source(file = "plot.R")
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
         is.na(theCounty()) |
         !any( grepl(theCounty(), tolower(df$County)) )
       ) {
      return(1) 
    } else { 
      return(0) 
    }
  })

  output$theMap <- renderPlot({
    map("county", "california")
  })

  output$countyText <- renderPrint({
    cat("That's ", capitalize(theCounty()), " county.")

  })
  
  output$useagePlot = 
    renderPlot(
      print(gg.wrapper(county.name = theCounty()))
  )
})