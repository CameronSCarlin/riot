library(shiny)
library(ggplot2)
library(plotly)
library(GGally)

shinyServer(function(input, output) {
  matchdf <- read.csv('matchdf.csv')
  matchdf <- matchdf[c(runif(10000,0,1)>.8),]
  matchdf$winner <- as.factor(matchdf$winner)
  ####### Overview #######
  
  ####### Teamwork #######

  ####### Champ Select #######
  
  ####### Game Time #######
  
  ####### Parallel Coordinates Plot #######
  output$parcoordplot <- renderPlotly({
    
    ggplotly(
      ggparcoord(matchdf, c(7,8,9,12,13,14), groupColumn = input$parcoordInput,
                 scale='globalminmax',
                 title = 'What Differentiates Winning Players and Losing Players?',
                 alpha= 0.04)+
        #scale_y_continuous(labels=comma)+
        #scale_x_discrete(labels=c('Comment','Like','Share','Total Interactions'))+
        ylab("Count")+
        #scale_color_manual(values=c("#BC403E", "#5285C4"))+
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_text(),
          panel.background = element_blank(),
          panel.grid.major = element_line(colour='grey'),
          panel.border = element_rect(color = 'grey', fill=NA)
        )
    )
    
  })
  
  vals <- reactive({
    data <- data.frame(rnorm(input$num))})
  output$hist <- renderPlot({
    ggplot(vals(), aes(vals()[1])) + geom_histogram()
  })
  output$summ <- renderText(summary(vals()[1]))
})

