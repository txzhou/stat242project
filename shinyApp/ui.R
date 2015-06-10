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

# Define UI for application
shinyUI(fluidPage(
  
  # Page title
  titlePanel("California Water Use"),
  
  fluidRow(
    
    column(5,
           
           textOutput("badCounty"),  # This line has to be present for the
           # conditionalPanel()s to work. I have no idea why. Maybe badCounty has
           # to be evaluated before the JS test is called???
           
           #conditionalPanel("output.badCounty == 0",
           #                  textOutput("countyText")),
           
           #Selection box
           selectInput("metric",
                       label = "Choose a Water Consumption Metric",
                       choices = list("Percent of California Consumption",
                                      "Per Capita Consumption")),
           
           selectInput("year",
                       label = "Choose a Year",
                       choices = list(2000,2005,2010)),
           
           # Print the clickable map
           plotOutput("theMap", height = "400px", click = "plotclick"),
           
           helpText("You can click on a county to get consumption information
                    by sector for that county in your selected year.")
           
    ),
    
    column(6, 
           # offset = 1,
           # Show a plot of the generated distribution
           conditionalPanel("output.badCounty == 0",
                            plotOutput("useagePlot")
)
    )
  ),
  
  hr(),
  
  fluidRow(
    
    column(5,
           leafletOutput("siteMap")
    ),
    
    column(6, 
           offset = 1,
           conditionalPanel("!is.na(output.mapClick)",
                            plotOutput("sitePlot"))
    )
  ),
  #      textOutput("mapClick"),
  hr(),
  
  fluidRow(
    
    column(5,
           leafletOutput("gwMap")
    ),
    
    column(6, 
           offset = 1,
           plotOutput("GWPlot"),
           actionButton("clear", "Clear plot, except last-clicked well")
    )
    
    #      textOutput("wellsInfo"),
    
  )
))
