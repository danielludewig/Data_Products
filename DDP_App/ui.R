
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Healthy Life Expectancy in Scotland"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       h3("Range of Analysis"),
       sliderInput("years", "Select Years to be included", 
                   min = 1980, max = 2010, value = c(1980, 2010), sep = ""),
       h5(tags$b("Select genders to include")),      
       checkboxInput("male", "Male", FALSE),
       checkboxInput("female", "Female", FALSE),
       h5(tags$b("Select models to include")),
       checkboxInput("modelMale", "Male", FALSE),
       checkboxInput("modelFemale", "Female", FALSE),
       h3("Predictions on current model"),
       numericInput("predictYear",
                    "Select a year to predict the healthy life expectancy based on the displayed models",
                    value = 2010, min = 1950, max = 2050, step = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       tabsetPanel(type ="tabs",
                   tabPanel("Plot", br(),
                            h3("Average Life Expectancy over Time"),
                            plotOutput("LE_Plot", height = "600px")),
                   tabPanel("Predictions", br(),
                            h3("Predictions at Defined Year"),
                            h5(tags$b(textOutput("maleHead"))),
                            textOutput("malePrediction"),br(),
                            tableOutput("maleTable"))), textOutput("m_R"),
                            h3("Predictions at Defined Year"),
                            h5(tags$b(textOutput("femaleHead"))),
                            textOutput("femalePrediction"), br(),
                            tableOutput("femaleTable"), textOutput("f_R")
                            
                              
    )
  )
))
