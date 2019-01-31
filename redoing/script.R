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
#scrape_rotterdam <- scrape

#boxplot(scrape_rotterdam$price)
#quantile(scrape_rotterdam$price)


amenities <- unique(flatten(scrape_rotterdam$amenity_ids))



for (row in 1:nrow(scrape_rotterdam)){
  amenities_list <- unlist(scrape_rotterdam[row,]$amenity_ids, use.names=FALSE)
  for (am in amenities) {
    scrape_rotterdam[row, paste("amenity", am)] <- am %in% amenities_list
  }
  scrape_rotterdam
}

determineClass <- function(price) {
  if (price < 14)
  {1}
  else if (14 <= price && price < 52)
  {2}
  else if (52 <= price && price < 85)
  {3}
  else if (85 <= price && price < 125)
  {4}
  else if (125 <= price && price < 275)
  {5}
  else
  {6}  
}

for(row in 1:nrow(scrape_rotterdam)){
  scrape_rotterdam[row, "priceClass"] <- determineClass(scrape_rotterdam[row, "price"])
}

scrape_rotterdam$host_languages <- NULL
scrape_rotterdam$amenity_ids <- NULL
scrape_rotterdam$city <- NULL
scrape_rotterdam$id <- NULL
scrape_rotterdam$is_business_travel_ready <- NULL
scrape_rotterdam$is_fully_refundable <- NULL
scrape_rotterdam$is_rebookable <- NULL
scrape_rotterdam$tier_id <- NULL
scrape_rotterdam$user_id <- NULL
scrape_rotterdam$name <- NULL
scrape_rotterdam$price <- NULL
scrape_rotterdam$price_with_service_fee <- NULL
scrape_rotterdam$currency <- NULL
scrape_rotterdam$rate_type <- NULL
scrape_rotterdam$room_type_category <- NULL
scrape_rotterdam$room_type <- NULL
scrape_rotterdam$room_and_property_type <- NULL
# no input data available
scrape_rotterdam$reviews_count <- NULL
scrape_rotterdam$picture_count <- NULL
scrape_rotterdam$is_host_highly_rated <- NULL
scrape_rotterdam$is_new_listing <- NULL
scrape_rotterdam$is_superhost <- NULL

scrape_rotterdam$latitude <- NULL
scrape_rotterdam$longitude <- NULL

scrape_rotterdam$bathrooms <- NULL
scrape_rotterdam$bedrooms <- NULL
scrape_rotterdam$beds <- NULL
scrape_rotterdam$person_capacity <- NULL
scrape_rotterdam$property_type_id <- NULL
scrape_rotterdam$space_type <- NULL


dt_rotterdam <- rpart(priceClass~., scrape_rotterdam, method="class")
rpart.plot(dt_rotterdam, extra=101)
#})
