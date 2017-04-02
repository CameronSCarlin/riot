library(shiny)

shinyUI(fluidPage(
  navbarPage("League of Legends Data Visualization",
      tabPanel('1,000 Sample Game Data',
               sidebarPanel(
                 textInput(inputId = "num", 
                           label = "Input Number", value=25),
                 textInput(inputId = "summonerName", 
                           label = "Input Summoner Name", value='cj6446'),
                 textInput(inputId = "APIkey", 
                           label = "Input API Key", value='secret key goes here')
                 ),
               mainPanel(
                 textOutput('summ')
                 )
               ),
      tabPanel('Summoner Statistics',
               sidebarPanel(
                 textInput(
                   inputId = "num", 
                   label = "Choose a number", value=25)
                 ),
               mainPanel(
                 plotOutput('hist')
                 )
               
      
    )
  )
)
)