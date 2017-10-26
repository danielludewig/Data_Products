
library(ggplot2)
library(shiny)
library(dplyr)
all_data <- read.csv("https://danielludewig.github.io/Data_Products/test_data.csv", 
                 header = TRUE)
all_data <- filter(all_data, Confidence.Interval == "All")

# Define server logic required to plot Life Expectancy
shinyServer(function(input, output) {
      
      
      # Define major plot
      output$LE_Plot <- renderPlot({
            
            # Trim data to selected range
            minYear <- input$years[1]
            maxYear <- input$years[2]
            data <- filter(all_data, 
                           (DateCode >= minYear)&(DateCode <= maxYear))
            
            # Fit Models
            maleModel <- lm(data = data[which(data$Gender=="Male"),],
                            formula = Value~DateCode)
            femaleModel <- lm(data = data[which(data$Gender=="Female"),], 
                            formula = Value~DateCode)
            
            # Generate plot area 
            with(data, plot(x=DateCode, y= Value, type = "n"))
            
            # Plot points on graph area
            with(data[which(data$Gender=="Male"),], 
                 if(input$male){points(x=DateCode, y=Value, 
                                       pch=20, col="steelblue")})
            with(data[which(data$Gender=="Female"),], 
                 if(input$female){points(x=DateCode, y=Value, 
                                         pch=20, col="coral")}) 
            
            # Plot regression lines
            with(data[which(data$Gender=="Male"),],
                 if(input$modelMale){abline(maleModel, col="steelblue")})
            with(data[which(data$Gender=="Female"),],
                 if(input$modelFemale){abline(femaleModel, col="coral")})
            })
      
      # Build reactive predictions
      malePredict <- reactive({
            minYear <- input$years[1]
            maxYear <- input$years[2]
            data <- filter(all_data, 
                           (DateCode >= minYear)&(DateCode <= maxYear))
            maleModel <- lm(data = data[which(data$Gender=="Male"),],
                            formula = Value~DateCode)
            predict(maleModel, newdata=data.frame(DateCode=input$predictYear))
            })
      
      femalePredict <- reactive({
            minYear <- input$years[1]
            maxYear <- input$years[2]
            data <- filter(all_data, 
                           (DateCode >= minYear)&(DateCode <= maxYear))
            femaleModel <- lm(data = data[which(data$Gender=="Female"),], 
                              formula = Value~DateCode)
            predict(femaleModel,newdata=data.frame(DateCode=input$predictYear))
            })
      
      # Define prediction headings
      output$maleHead <- renderText({
            ifelse(input$modelMale,
                   "Predicted Male Healthy Life Expectancy:","")})
      output$femaleHead <- renderText({
            ifelse(input$modelFemale,
                   "Predicted Female Healthy Life Expectancy:","")})
      
      # Calculate Predictions 
      output$malePrediction <- renderText({malePredict()})
      output$femalePrediction <- renderText({femalePredict()})
      
      # Generate Stat tables
      tableM <- as.data.frame(summary(maleModel)$coeff)
            
      output$maleTable <-renderTable(tableM, rownames = TRUE, bordered = TRUE)
      
})
