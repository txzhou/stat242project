library(shiny)
library(maps)
library(mapdata)
library(maptools)
source(file = "plot.R")
source(file = "functions.R")


shinyServer(function(input, output) {

  output$theMap <- renderPlot({
    color.map()
  })

  output$clickcoord <- renderPrint({
    cat("The coordinates are: x = ", input$plotclick$x,
        ", y = ", input$plotclick$y, ", \nwhich is in ",
        latlong2county(
          data.frame(x = input$plotclick$x, y = input$plotclick$y)), "county.")
    })

  output$histogram <- renderPlot({
    gg.wrapper(county.name = latlong2county(
      data.frame(x = input$plotclick$x, y = input$plotclick$y)))
  })

})
