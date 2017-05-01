library(shiny)
library(ggplot2)
library(plotly)
library(GGally)
library(dplyr)
library(tidyr)

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
  
  matchdf2 <- read.csv('matchdf.csv', stringsAsFactors = FALSE)
  matchdf2$winner <- as.factor(matchdf2$winner)
  levels(matchdf2$winner) <- list('No'="0",'Yes'="1")
  
  output$pickbanplot <- renderPlotly(
    
    if(input$pickban == "pick"){
      tab <- table(matchdf2$championName)
      tab_s <- sort(tab)
      top10 <- tail(names(tab_s), 20)
      d_s <- subset(matchdf2, championName %in% top10)
      d_s$championName <- factor(d_s$championName, levels = rev(top10))
      ggplotly(
        ggplot(d_s, aes(x = championName, fill = factor(winner))) +
        geom_bar() + xlab("Picked Champions") + ylab("Count") +
          theme(
            axis.title.x = element_text(),
            axis.title.y = element_text(),
            panel.background = element_blank(),
            panel.grid.major = element_line(colour='grey'),
            panel.border = element_rect(color = 'grey', fill=NA)
          )
      ) %>% layout(margin = list(l=-50, r=0, b=50, t=50, pad=0),
                   xaxis = list(tickangle = 30),
                   legend = list(title = "Winner", orientation = "h", xanchor = "center",
                                 yanchor = "top", y = -0.12, x = 0.54)) %>%
        add_annotations( text="Winner", xref="paper", yref="paper",
                         x=0.43, xanchor="center",
                         y=-0.128, yanchor="top", legendtitle=TRUE, showarrow=FALSE)
    } else {
      bandf <- matchdf2 %>% 
        group_by(matchteamId, winner, ban1, ban2, ban3) %>%
        summarise(teamGold = sum(endGold, na.rm = TRUE))
      ban1 <- bandf[c("winner", "ban1")]
      names(ban1) <- c("winner", "ban")
      ban2 <- bandf[c("winner", "ban2")]
      names(ban2) <- c("winner", "ban")
      ban3 <- bandf[c("winner", "ban3")]
      names(ban3) <- c("winner", "ban")
      bandf <- rbind(ban1, rbind(ban2, ban3))
      tab <- table(bandf$ban)
      tab_s <- sort(tab)
      top10 <- tail(names(tab_s), 20)
      d_s <- subset(bandf, ban %in% top10)
      d_s$ban <- factor(d_s$ban, levels = rev(top10))
      ggplotly(
        ggplot(d_s, aes(x = ban, fill = factor(winner))) +
        geom_bar() + xlab("Banned Champions") + ylab("Count") +
          theme(
            axis.title.x = element_text(),
            axis.title.y = element_text(),
            panel.background = element_blank(),
            panel.grid.major = element_line(colour='grey'),
            panel.border = element_rect(color = 'grey', fill=NA)
      )) %>% layout(margin = list(l=-50, r=0, b=50, t=50, pad=0),
                    xaxis = list(tickangle = 30),
                    legend = list(title = "Winner", orientation = "h", xanchor = "center",
                                  yanchor = "top", y = -0.12, x = 0.54)) %>%
        add_annotations( text="Winner", xref="paper", yref="paper",
                         x=0.43, xanchor="center",
                         y=-0.128, yanchor="top", legendtitle=TRUE, showarrow=FALSE) 
    }
  )
  
  
  
  
  ####### Game Time #######
  
  # teamstats <- function(x){
  #   a <- c()
  #   for(i in 1:nrow(matchdf[paste0(x,'ZeroToTen')])){
  #     if(matchdf$matchDuration[i]/60-10 > 0){
  #       a[i] <- matchdf[paste0(x,'ZeroToTen')][i,] * 10
  #       if(matchdf$matchDuration[i]/60-20 > 0){
  #         a[i] <- a[i] + matchdf[paste0(x,'TenToTwenty')][i,] * 10
  #         if(matchdf$matchDuration[i]/60-30 > 0){
  #           a[i] <- a[i] + matchdf[paste0(x,'TwentyToThirty')][i,] * 10
  #           if(matchdf$matchDuration[i]/60-40 > 0){
  #             a[i] <- a[i] + matchdf[paste0(x,'ThirtyToEnd')][i,] * 10
  #           } else {
  #             a[i] <- a[i] + matchdf[paste0(x,'TwentyToThirty')][i,] * (matchdf$matchDuration[i]/60 - 30)
  #           }
  #         } else {
  #           a[i] <- a[i] + matchdf[paste0(x,'TenToTwenty')][i,] * (matchdf$matchDuration[i]/60 - 20)
  #         }
  #       } else {
  #         a[i] <- a[i] + matchdf[paste0(x,'ZeroToTen')][i,] * (matchdf$matchDuration[i]/60 - 10)
  #       }
  #     } else {
  #       a[i] <- a[i] + matchdf[paste0(x,'ZeroToTen')][i,] * (matchdf$matchDuration[i]/60)
  #     }
  #   }
  #   return(a)
  # }
  # 
  # matchdf["endGold"] <- teamstats('gold')
  # matchdf["endDamage"] <- teamstats('damage')
  # matchdf["endCreeps"] <- teamstats('creeps')
  # matchdf["endXp"] <- teamstats('xp')
  
  
  
  gametime <- matchdf2[c("matchteamId", "matchDuration", "winner", "kills", "deaths", "assists", 
                        "endGold", "endDamage", "endCreeps", "endXp")]
  
  gametime <- gametime %>% 
    group_by(matchteamId, matchDuration, winner) %>% 
    summarise(teamGold = sum(endGold, na.rm = TRUE),
              teamKills = sum(kills, na.rm = TRUE),
              teamDeaths = sum(deaths, na.rm = TRUE),
              teamAssists = sum(assists, na.rm = TRUE),
              teamDamage = sum(endDamage, na.rm = TRUE),
              teamCreeps = sum(endCreeps, na.rm = TRUE),
              teamXp = sum(endXp, na.rm = TRUE)) %>%
    as.data.frame()
  
  output$stats <- renderPlotly({
    ggplotly(
    ggplot(gametime, aes_string("matchDuration", input$teamstats, color="winner")) + geom_line() + 
      xlab("Match Duration (s)") + ylab("Team Stats") +
      theme(
        axis.title.x = element_text(),
        axis.title.y = element_text(),
        panel.background = element_blank(),
        panel.grid.major = element_line(colour='grey'),
        panel.border = element_rect(color = 'grey', fill=NA)
      )
    ) %>% layout(margin = list(l=-50, r=0, b=50, t=50, pad=0),
      xaxis = list(title = "Match Duration (s)", anchor="free"),
                 yaxis = list(title = "Team Stats", anchor="free"),
                 legend = list(title = "Winner", orientation = "h", xanchor = "center",
                               yanchor = "top", y = -0.12, x = 0.54)) %>%
      add_annotations( text="Winner", xref="paper", yref="paper",
                       x=0.43, xanchor="center",
                       y=-0.128, yanchor="top", legendtitle=TRUE, showarrow=FALSE)
  })
  
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
  
  # vals <- reactive({
  #   data <- data.frame(rnorm(input$num))})
  # output$hist <- renderPlot({
  #   ggplot(vals(), aes(vals()[1])) + geom_histogram()
  # })

})

