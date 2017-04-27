library(shiny)
library(plotly)
library(ggplot2)
library(GGally)

shinyUI(fluidPage(
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
               sidebarPanel(
                 checkboxGroupInput(inputId = "fitline_teamwork",
                               label = "Add Fitline to:",
                               choices = c('Losing Team','Winning Team'))
                 ),
               mainPanel(
                 includeText('teamwork.txt')
               )
               ),
####### Champ Select #######
      tabPanel('Champ Select: Your Choice Matters',
               sidebarPanel(
                 
                 ),
               mainPanel(
                 includeText('champions.txt')
               )
    ),
####### Gold #######
    tabPanel('Game Time and Gold Generation',
             sidebarPanel(
               textInput(
                 inputId = "num", 
                 label = "Choose a number", value=25)
             ),
             mainPanel(
               includeText('gold.txt')
             )
    ),
####### ADC / Support #######
    tabPanel('Player Differentiation Parallel Coordinates Plot',
             sidebarPanel(
               radioButtons('parcoordInput',label='Select Factor',
                           choices = c('Win/Loss' = 'winner',
                                       'Player Rank' = 'userRank'))
             ),
             mainPanel(
               plotlyOutput("parcoordplot", height='750%', width='100%')
             )
             
             
    )
  )
)
)