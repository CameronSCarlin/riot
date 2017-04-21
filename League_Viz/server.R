library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  ####### Overview #######
  
  
  ####### Teamwork #######

  ####### Champ Select #######
  
  ####### Game Time #######
  
  ####### ADC/Support Synergy #######
  
  vals <- reactive({
    data <- data.frame(rnorm(input$num))})
  output$hist <- renderPlot({
    ggplot(vals(), aes(vals()[1])) + geom_histogram()
  })
  output$summ <- renderText(summary(vals()[1]))
})

