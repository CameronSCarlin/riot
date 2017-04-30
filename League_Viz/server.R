library(shiny)
library(ggplot2)
library(plotly)
library(GGally)

shinyServer(function(input, output) {
  
  set.seed(1)
  matchdf <- read.csv('matchdf_tagfix.csv')
  matchdf <- matchdf[,2:ncol(matchdf)]
  matchdf$Winner <- as.factor(matchdf$Winner)
  levels(matchdf$Winner) <- list('No'="0",'Yes'="1")
  
  match_subset <- matchdf[matchdf$Rank %in% c('CHALLENGER','MASTER', 'DIAMOND'),]
  match_subset$Rank <- "DIAMOND+"
  match_removed <- matchdf[!(matchdf$Rank %in% c('CHALLENGER','MASTER','DIAMOND')),]
  match_subset <- rbind(match_subset, match_removed[c(runif(9565,0,1)>.9),])
  match_subset$Rank <- as.factor(match_subset$Rank)
  Minutes <- as.integer(match_subset$matchDuration/60)
  match_subset <- cbind(match_subset,Minutes)
  match_subset$Rank <- factor(match_subset$Rank, levels = c('UNRANKED',
                                                            'BRONZE',
                                                            'SILVER',
                                                            'GOLD',
                                                            'PLATINUM',
                                                            'DIAMOND+'))

  ####### Overview #######
  
  ####### Teamwork #######

  output$teamwork <- renderPlotly(
    
    if (length(input$fitline_teamwork) == 1){
    ggplotly(ggplot(match_subset, aes(x=Kills, y=Assists))+
                                  geom_count(aes(color=Winner), alpha=0.5)+
                                  geom_smooth(method='lm',aes(color=Winner))+
                                  xlab('Number of Kills')+
                                  ylab('Number of Assists')+
                                  scale_x_continuous(breaks=c(0,5,10,15,20,25))+
                                  scale_y_continuous(breaks=c(0,5,10,15,20,25))+
                                  theme(
                                    axis.title.x = element_text(),
                                    axis.title.y = element_text(),
                                    panel.background = element_blank(),
                                    panel.grid.major = element_line(colour='grey'),
                                    panel.border = element_rect(color = 'grey', fill=NA)
                                  )
                                )} else {
                                  ggplotly(ggplot(match_subset, aes(x=Kills, y=Assists))+
                                             geom_count(aes(color=Winner), alpha=0.5)+
                                             xlab('Number of Kills')+
                                             ylab('Number of Assists')+
                                             scale_x_continuous(breaks=c(0,5,10,15,20,25,30))+
                                             scale_y_continuous(breaks=c(0,5,10,15,20,25,30))+
                                             theme(
                                               axis.title.x = element_text(),
                                               axis.title.y = element_text(),
                                               panel.background = element_blank(),
                                               panel.grid.major = element_line(colour='grey'),
                                               panel.border = element_rect(color = 'grey', fill=NA)
                                             )
                                  )
                                })
  ####### Champ Select #######
  
  ####### Game Time #######
  
  ####### Parallel Coordinates Plot #######
  
  output$parcoordplot <- renderPlotly({
    
    if (input$parcoordInput == 'Winner'){
      scale_pcp <- c("#BC403E", "#5285C4")
    } 
    if (input$parcoordInput == 'Rank'){
      scale_pcp <- c('#543950','#cd7f32','#C0C0C0', '#FFD700','#cecfe2', '#c6dde2')
    } 
    if (input$parcoordInput == 'Role') {
      scale_pcp <- c('#db0000','#93004a','#0000db','#934a00','#00b75c','#002727')
    }
    
    match_subset2 <- match_subset[c(runif(length(match_subset),0,1)>.75),]
    ggplotly(
      ggparcoord(match_subset2, c(7,8,9,12,13,14), groupColumn = input$parcoordInput,
                 scale='globalminmax',
                 title = 'Player Differentiation by Style and Rank',
                 alpha= 0.25)+
        scale_x_discrete(labels=c('Baron Kills',
                                  'Dragon Kills',
                                  'Tower Kills',
                                  'Kills',
                                  'Deaths',
                                  'Assists'))+
        ylab("Count")+
        scale_color_manual(values=scale_pcp)+
        theme(
          axis.title.x = element_blank(),
          axis.title.y = element_text(),
          panel.background = element_blank(),
          panel.grid.major = element_line(colour='grey'),
          panel.border = element_rect(color = 'grey', fill=NA)
        ),tooltip = c("x",'y')) 
  
    
  })
  
  vals <- reactive({
    data <- data.frame(rnorm(input$num))})
  output$hist <- renderPlot({
    ggplot(vals(), aes(vals()[1])) + geom_histogram()
  })

})

