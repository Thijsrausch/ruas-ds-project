#install.packages("purrr")
#install.packages("rpart")
#install.packages("rpart.plot")

library(dplyr)
library(jsonlite)
library("dplyr")
library("purrr")

library("rpart")
library("rpart.plot")
#install.packages("profvis")
#library("profvis")
#profvis({
setwd('C:\\Users\\wouter\\Dropbox\\school\\AirBnBStatistics\\redoing')

scrape <- fromJSON("./airbnb-scrape-1.json")
scrape_rotterdam <- scrape[!(scrape$city!="Rotterdam"),]


bedrooms <- 2
bathrooms <- 1
beds <- 2
personCapacity <- 2

for(row in 1:nrow(scrape_rotterdam)){
  data <- scrape_rotterdam[row,]
  
  scrape_rotterdam[row, "distance"] = abs(data$bathrooms - bathrooms + data$bedrooms - bedrooms + data$beds - beds + data$person_capacity - personCapacity)
}


minData <- scrape_rotterdam[scrape_rotterdam$distance == min(scrape_rotterdam$distance, na.rm=T), ]

price <- mean(minData$price, na.rm = T)
#})
