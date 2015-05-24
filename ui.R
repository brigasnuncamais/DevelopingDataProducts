options(shiny.deprecation.messages=F)
if (!require(DT)) devtools::install_github("rstudio/DT")
require(DT)
if (!require(UsingR)) devtools::install("UsingR")
require(UsingR)
if (!require(shiny)) devtools::install("shiny")
require(shiny)
if (!require(ggplot2)) devtools::install("ggplot2")
require(ggplot2)
if (!require(scales)) devtools::install("scales")
require(scales)
if (!require(plyr)) devtools::install("plyr")
require(plyr)

trainData <- read.table("regularite-mensuelle-ter.csv", header=T, quote = "\"\"", row.names = NULL,
                      sep = ";",dec=".",encoding="UTF-8",stringsAsFactors=F)
colnames(trainData)=c("Date","Region","NumberOfScheduledTrains","NumberOfTrainsThatCirculated",
                      "NumberOfCanceledTrains","NumberOfLateTrainsOnArrival",
                      "RegularityRate","Comments")
dataset <- trainData
dataset <- subset(dataset, select=c(-Comments))
dataset$Year <-  as.numeric(format(as.Date(paste0(dataset[,1],"-01"),"%Y-%m-%d"), "%Y"))
dataset$Year <-  as.factor(as.numeric(format(as.Date(paste0(dataset[,1],"-01"),"%Y-%m-%d"), "%Y")))
dataset$Region <-  as.factor(dataset[,2])

shinyUI(
  fluidPage(
  navbarPage("French TER (regional train) monthly regularity"),
#   titlePanel("French TER (regional train) monthly regularity"),
  sidebarLayout(
    sidebarPanel(
      h3('Application parameters'),
      sliderInput('sampleSize', 'Choose Sample Size', min=1, max=nrow(dataset),
                  value=min(500, nrow(dataset)), step=100, round=0),
#       selectInput('x', 'X', names(dataset[,c(1:2,8)]), selected = names(dataset[,c(1:2,8)])[1]),
      selectInput('x', 'X', names(dataset[,c(1:8)]), selected = names(dataset[,c(1:8)])[1]),
      selectInput('y', 'Y', names(dataset[,3:8]), selected = names(dataset[,3:8])[1]),
      selectInput('color', 'Color', selected = "Region" , c('None', names(dataset[,3:8]))),
      
      checkboxInput('jitter', 'Jitter'),
      checkboxInput('smooth', 'Smooth'),
      
      selectInput('facet_row', 'Facet Row', c(None='.', names(dataset[,c(1:2,8)]), selected = names(dataset[,c(1:2,8)])[1])),
      selectInput('facet_col', 'Facet Column', c(None='.', names(dataset[,c(1:2,8)]), selected = names(dataset[,c(1:2,8)])[1])),
      downloadButton('downloadData', 'Download dataset to your computer'),
      tags$br(),
      tags$br(),
      strong('VARIABLE DESCRIPTIONS:'),
      tags$ul(
        tags$li('date - 2013-01 to 2015-03, month accuracy'),
        tags$li('region - French administrative Région'),
        tags$li('Number of scheduled trains - Nombre de trains programmés'),
        tags$li('Number of trains that circulated - Nombre de trains ayant circulé'),
        tags$li('Number of canceled trains - Nombre de trains annulés'),
        tags$li('Number of late trains on arrival - Nombre de trains en retard à l\'arrivée'),
        tags$li('Regularity rate - Taux de régularité'),
        tags$li('Comments - Commentaires')
        )  
    ),    
    mainPanel(
      h2('French TER (regional train) monthly regularity since January 2013'),
      p('On TER, regularity is calculated when the train arrived at the last station of its journey (terminus). This calculation, which does not include the intermediate stations, offers the cumulative delay on an entire trip.'),
      p('The indicator used is of "5 minutes lawfulness": a train is considered late if it arrives 5 minutes after its scheduled time. The proposed data is not detailed but aggregated by all TER lines for a region.'),
      p('In agreement with the Regions which are the transport authorities for TER, trains deleted before 16h the day before its circulation will not be counted.'),
      p('However, if this announcement could not be made on time, the train will still count as a deleted train, may it be total or partial (the train has completed one part of its course).'),
      p("The open data site of the french railways, SNCF, with its various datasets and applications to explore them, can be reached at"),
      img(src ="http://www.sncf.com/theme/images/logo-sncf.png",alt="SNCF Open Data"),
      tags$br(),
      a("SNCF Open Data",href="http://data.sncf.com/",target="_blank"),
      h4('Starting material about this Web App'),
      p('On the side panel you can change the variables that are injected to the plot (from ggplot2 library).'),
      p('You can change which variable go the the X-axis, Y-axis, color by variable, and include jitter, smooth, and row/column facets.'),
      p('Use it to your advantage in order to extract the maximum logic conclusions out of the plot for latter implementation of Machine Learning Algorithms.'),
      strong('About the plot'),
      p('The plot has already some variables choosen by default, to help you interprete the data.'),
      p('From the default settings, the plot is intended to allow the comparison among some variables:'),
      tags$ul(
        tags$li('Compare Number of scheduled trains to Number of trains that circulated. Pretty much correlated?'),
        tags$li('Compare Number of scheduled trains to Number of canceled trains. Do you see some outliers?'),
        tags$li('Compare Number of scheduled trains to Number of late trains on arrival...')
        ),
      plotOutput('plot'),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      tags$br(),
      h4('Training Dataset'),
      p('Finally, you can view the raw training dataset and play with it as well.'),
      tags$br(),
      tabPanel('trainData', DT::dataTableOutput('mytable1'))
      )
    )
  )
)