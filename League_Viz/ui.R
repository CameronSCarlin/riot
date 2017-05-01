library(shiny)
library(plotly)
library(ggplot2)
library(GGally)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme('flatly'),
  navbarPage("The Twisted Plotline: League of Legends Data Visualization",
####### Overview #######
             tabPanel('Overview',
                      sidebarPanel(
                        
                      ),
                      mainPanel(
                        includeMarkdown('overview.md'),
                        plotOutput('hist')
                      )
                    ),
####### Teamwork #######
      tabPanel('Teamwork: Kills vs. Assists',
               plotlyOutput('teamwork'),
               sidebarPanel(
                 checkboxGroupInput(inputId = "fitline_teamwork",
                               label = "Add Fitlines?",
                               choices = c('Yes!'='fit'))
                 ),
               mainPanel(
                 includeText('teamwork.txt')
               )
               ),
####### Champ Select #######
      tabPanel('Champion Select',
               fluidPage(
                 fluidRow(column(3,
                                 radioButtons("pickban", label = h3("Team Statistics"),
                                              choices = list("Most Picked" = "pick", 
                                                             "Most Banned" = "ban"
                                                             ), 
                                              selected = "pick"),
                                 includeText('champions.txt')),
                          column(9, plotlyOutput('pickbanplot', height='700'))
                 )
               )
    ),
####### Stats over Time #######
    tabPanel("Stats over Time",
               fluidPage(
               fluidRow(column(3,
               radioButtons("teamstats", label = h3("Team Statistics"),
                            choices = list("Gold Earned" = "teamGold", "Creeps Killed" = "teamCreeps", 
                                           "Damage Dealt" = "teamDamage", "Experience Gained" = "teamXp",
                                           "Kills Total" = "teamKills", "Deaths Total" = "teamDeaths",
                                           "Assists Total" = "teamAssists"), 
                            selected = "teamGold"),
               includeText('gold.txt')),
               column(9, plotlyOutput('stats', height='700'))
               )
             )
    ),
####### ADC / Support #######
    tabPanel('Player Differentiation',
             plotlyOutput("parcoordplot", height='500', width='auto'),
             sidebarPanel(
               radioButtons('parcoordInput',label='Select Factor',
                           choices = c('Win vs. Loss' = 'Winner',
                                       'Player Rank' = 'Rank',
                                       'Champion Role' = 'Role'))
             ),
             mainPanel(
               includeMarkdown('pcp.md')
             )
             
             
    )
  )
)
)





