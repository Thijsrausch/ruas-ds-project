library(jsonlite)

scrape <- fromJSON("airbnb-scrape-1.json")
scrape_rotterdam <- scrape[!(scrape$city!="Rotterdam"),]

summary(lm(price~bedrooms+bathrooms+person_capacity, scrape_rotterdam))

plot(scrape_rotterdam$price ~ scrape_rotterdam$bedrooms)
lines(lowess(scrape_rotterdam$price ~ scrape_rotterdam$bedrooms))

summary(lm(price ~ poly(bedrooms, 3, raw = TRUE), data=scrape_rotterdam))

summary(lm(price ~ poly(beds, 3, raw = TRUE), data=scrape_rotterdam))

summary(lm(price ~ poly(bathrooms, 2, raw = TRUE), data=scrape_rotterdam))

lines(scrape_rotterdam$bedrooms, predict(pm))

summary(pm)
summary(lm(price~bedrooms, scrape_rotterdam))

#########
dtc <- function(x,y) {
  sqrt((51.9225 - x)^2 + (4.47917 - y)^2)
} 

logModel <- lm(
  price ~ I(((dtc(latitude,longitude)/((exp(1)^dtc(latitude,longitude))-1))-log(1-(exp(1)^(-dtc(latitude,longitude)))))),
  data=scrape_rotterdam)

plot(sqrt((51.9225 - scrape_rotterdam$latitude)^2 + (4.47917 - scrape_rotterdam$longitude)^2),scrape_rotterdam$price)
lines(sqrt((51.9225 - scrape_rotterdam$latitude)^2 + (4.47917 - scrape_rotterdam$longitude)^2), 
      predict(logModel, data=scrape_rotterdam))
summary(logModel)

dtcModel <- lm(price ~ dtc(latitude,longitude), data=scrape_rotterdam)
lines(sqrt((51.9225 - scrape_rotterdam$latitude)^2 + (4.47917 - scrape_rotterdam$longitude)^2), 
      predict(dtcModel, data=scrape_rotterdam), col='blue')
summary(dtcModel)

###########
summary(lm(price~bedrooms+bathrooms+person_capacity+dtc(latitude,longitude), scrape_rotterdam))
###########

