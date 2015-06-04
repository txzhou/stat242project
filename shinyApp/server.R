library(shiny)
library(maps)
library(mapdata)
library(maptools)
source("functions.R")

shinyServer(function(input, output) {
  
  output$theMap <- renderPlot({
    map("county", "california")
  })

  output$clickcoord <- renderPrint({
    cat("The coordinates are: x = ", input$plotclick$x,
        ", y = ", input$plotclick$y, ", \nwhich is in ", 
        latlong2county(
          data.frame(x = input$plotclick$x, y = input$plotclick$y)), "county.")
  })
  
})
