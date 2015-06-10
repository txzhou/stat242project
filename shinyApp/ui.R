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
library(RColorBrewer)

# Define UI for application
shinyUI(
  navbarPage(
    "California Water Use",
    
    tabPanel(
      "Use by county",
      
      fluidRow(
        column(5,
               #Selection box
               selectInput("metric",
                           label = "Choose a Water Consumption Metric",
                           choices = list("Percent of California Consumption",
                                          "Per Capita Consumption")),
               
               selectInput("year",
                           label = "Choose a Year",
                           choices = list(2000,2005,2010)),

               helpText("Click on a county for consumption by sector for that county in the selected year."),
               
               # Print the clickable map
               plotOutput("theMap", height = "400px", click = "plotclick"),
               
               textOutput("badCounty")  # This line has to be present for the
               # conditionalPanel()s to work. I have no idea why. Maybe badCounty has
               # to be evaluated before the JS test is called???
               
               
        ),
        
        column(6, 
               helpText("California is a geographically diverse state with widely varying 
                economies and population densities across its counties. Here you 
                can explore how much water each county uses and what they use it for."),
               
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
        column(5, leafletOutput("siteMap")),
        column(6, 
               helpText("Surface water provides some of California's water supply. It is 
               stored in massive manmade reservoirs on almost all the major rivers and
               in the natural reservoir of high alpine snowpack in the Sierra
               Nevada mountains. In the current drought, snowpack has been far 
               less than normal, which means less runoff to fill the reservoirs, 
               the levels of which have dropped dramatically."),
               br(),
               helpText("The map to left shows US Geological Survey surface water monitoring stations.
               Click on one to see how runoff changes seasonally and annually over
               the course of the drought. Try zooming in and looking at differences
               above and below major dams.")
        )
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
        column(5, leafletOutput("gwMap")),
        column(6, 
               helpText("If surface water is California's first stop for water needs, 
               groundwater is its backstop. Only a few municipalities still
               rely on groundwater (Davis being one of them); however, it is of critical 
               importance for irrigation. When surface supplies are down, 
               reliance on groundwater increases, and unlike surface water and 
               unlike every other state in the US, groundwater use is unregulated
               in California. This has led to a furious groundwater grab during
               the current drought."),
               br(),
               helpText("The map to the left shows the groundwater wells that the the US 
               Geological Survey uses to monitor groundwater elevation. Unfortunately,
               even public monitoring of groundwater levels is legally challenging
               in California, so data are sparser than hydrologists and water
               managers would like. However, here you can click on a series of wells 
               to see how groundwater levels have changed over the course of the 
               current drought.")
        )
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
