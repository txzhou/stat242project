library(shiny)

# Define UI for application
shinyUI(fluidPage(
  
  # Page title
  titlePanel("California Water Use"),
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("Click on a county to get water use info."),
      
      textOutput("badCounty"),  # This line has to be present for the 
      # conditionalPanel()s to work. I have no idea why. Maybe badCounty has
      # to be evaluated before the JS test is called???
      
      conditionalPanel("output.badCounty == 0",
                       textOutput("countyText")),
      
      # Print the clickable map
      plotOutput("theMap", height = "400px", clickId = "plotclick"),
      
      #Selection box
      selectInput("metric",
                  label = "Choose a Water Consumption Metric",
                  choices = list("Percent of California Consumption",
                                 "Per Capita Consumption")),
      
      width = 4
    ),
    
    mainPanel(
      # Show a plot of the generated distribution
      conditionalPanel("output.badCounty == 0",
                       plotOutput("useagePlot")
                       )
    )
  )
))
