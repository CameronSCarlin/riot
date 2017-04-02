library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  vals <- reactive({
    data <- data.frame(rnorm(input$num))})
  output$hist <- renderPlot({
    ggplot(vals(), aes(vals()[1])) + geom_histogram()
  })
  output$summ <- renderText(summary(vals()[1]))
})

