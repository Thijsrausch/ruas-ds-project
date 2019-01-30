library("rpart")
library("rpart.plot")
set.seed(43)

scrape <- fromJSON("airbnb-scrape-1.json")
scrape_rotterdam <- scrape[!(scrape$city!="Rotterdam"),]
# scrape_rotterdam <- scrape

# determine price classes
# get quartiles
boxplot(scrape_rotterdam$price)
quantile(scrape_rotterdam$price)

# remove outliers to adjust quartiles
# outliers <- boxplot(scrape_rotterdam$price, plot=FALSE)$out
# scrape_rotterdam <- scrape_rotterdam[-which(scrape_rotterdam$price %in% outliers),]

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

# clean data
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

scrape_rotterdam$space_type <- NULL

scrape_rotterdam$property_type_id <- NULL

# split dataset
s <- sample(219, 200)
# s <- sample(761, 600)
scrape_rotterdam_train <- scrape_rotterdam[s,]
scrape_rotterdam_test <- scrape_rotterdam[-s,]

##########

# decision tree
  # build tree using person_capacity, bedroomds, bathrooms
dt_rotterdam <- rpart(priceClass~person_capacity+bedrooms+bathrooms, scrape_rotterdam_train, method="class")
  # build tree using all features after cleaning the dataset
dt_rotterdam <- rpart(priceClass~., scrape_rotterdam_train, method="class")

rpart.plot(dt_rotterdam, extra=101)

  # test tree
prediction <- predict(dt_rotterdam, scrape_rotterdam_test, type="class")
    
table(scrape_rotterdam_test[, ncol(scrape_rotterdam_test)], prediction)
