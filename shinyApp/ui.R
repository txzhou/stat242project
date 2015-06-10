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
shinyUI(
  navbarPage(
    "California Water Use",
    
    tabPanel(
      "Use by county",
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
               
               helpText("Click on a county for consumption by sector for that county in the selected year.")
               
        ),
        
        column(6, 
               # offset = 1,
               # Show a plot of the generated distribution
               conditionalPanel("output.badCounty == 0",
                                plotOutput("useagePlot"))
        )
      )
    ),
    
    tabPanel(
      "Surface water flow",
      fluidRow(
        column(5, leafletOutput("siteMap"))
      ),
      
      #        column(6, 
      #               offset = 1,
      conditionalPanel("!is.na(output.mapClick)",
                       plotOutput("sitePlot"))
      #        )
      #      )
    ),
    
    tabPanel(
      "Groundwater levels",
      fluidRow(
        column(5, leafletOutput("gwMap"))
      ),
      
      #        column(6, 
      #               offset = 1,
      plotOutput("GWPlot"),
      actionButton("clear", "Clear plot, except last-clicked well")
      #        )
      
      #      textOutput("wellsInfo"),
      
      #      )
    )
  )
)
