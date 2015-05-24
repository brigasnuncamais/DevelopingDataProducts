# using parameters from the application to plot dataset

x <- "NumberOfScheduledTrains"
y <- "NumberOfLateTrainsOnArrival"
c <- "Year"
rf <- "Region"
cf <- "Year"
facets <- paste(rf, '~', cf)
ggplot(dataset, aes_string(x, y)) + geom_point() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1,colour = "black")) +
  aes_string(color=c) + facet_grid(facets) + geom_smooth (group = x)
