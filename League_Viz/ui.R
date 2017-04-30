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
               sidebarPanel(
                 
                 ),
               mainPanel(
                 includeText('champions.txt')
               )
    ),
####### Gold #######
    tabPanel("Gold's Value",
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





