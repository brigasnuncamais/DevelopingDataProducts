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
dataset$Year <-  as.factor(as.numeric(format(as.Date(paste0(dataset[,1],"-01"),"%Y-%m-%d"), "%Y")))
dataset$Region <-  as.factor(dataset[,2])

shinyServer(
  function(input, output) {
    
    #Option to choose sample size
    dataset <- reactive(function() {
      mutate(trainData[sample(nrow(trainData), input$sampleSize),-8],
        Year=as.factor(as.numeric(
          format(as.Date(paste0(trainData[sample(nrow(trainData), input$sampleSize),1],"-01"),"%Y-%m-%d"), "%Y"))),
        Region=as.factor(trainData[sample(nrow(trainData), input$sampleSize),2])
      )
    })
    
    #Option to download the Dataset
    output$downloadData <- downloadHandler(
      filename = function() { paste(input$dataset, '.csv', sep='') },
      content = function(file) {
        write.csv(dataset(), file)
      }
    )
    
    output$mytable1 <- DT::renderDataTable({
      DT::datatable(trainData, options = list(bSortClasses = TRUE))
    })
    
    #Draw ggplot based/reactive on user input
    output$plot <- reactivePlot(function() {
      options(warn = -1)
      x <- input$x
      y <- input$y
      p <- ggplot(dataset(), aes_string(x, y)) + geom_point() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1,colour = "black"))
      if (input$color != 'None') 
        p <- p + aes_string(color=input$color)
      
      facets <- paste(input$facet_row, '~', input$facet_col)
      print(x)
      print(y)
      print(facets)
      if (facets != '. ~ .')
        p <- p + facet_grid(facets)
      
      if (input$jitter)
        p <- p + geom_jitter()
      if (input$smooth)
        p <- p + geom_smooth (group = x)
#       p <- p + geom_smooth(stat="identity", group = x,method =glm)
      print(p)
      options(warn = 1)
    }, height=700)
  }
)