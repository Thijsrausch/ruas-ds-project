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
