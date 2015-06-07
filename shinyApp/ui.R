library(shiny)

# Define UI for application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("My App"),
  sidebarPanel(
    textOutput("clickcoord"),
    plotOutput("histogram")
  ),

  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("theMap", height = "600px", click = "plotclick")
  )
))
