library(jsonlite)

scrape <- fromJSON("airbnb-1.json")
scrape_rotterdam <- scrape[!(scrape$city!="Rotterdam"),]
set.seed(122)

# distance to center correlations
cor(sqrt((51.9225 - scrape_rotterdam$latitude)^2 + (4.47917 - scrape_rotterdam$longitude)^2),scrape_rotterdam$price)

# combined metrics
bedrooms.c = scale(scrape_rotterdam$bedrooms, center = T, scale = F)
bathrooms.c = scale(scrape_rotterdam$bathrooms, center = T, scale = F)
summary(lm(price~bedrooms.c+bathrooms.c, scrape_rotterdam))


# other correlations
bedRoom.c = scale(scrape_rotterdam$bedrooms, center = T, scale = F)
summary(lm(price~bedrooms, scrape_rotterdam))
plot(scrape_rotterdam$bedrooms, scrape_rotterdam$price)
cor(scrape_rotterdam$bedrooms, scrape_rotterdam$price)

bedrooms.c = scale(scrape_rotterdam$bedrooms, center = T, scale = F)
summary(lm(price~bedrooms.c, scrape_rotterdam))

summary(lm(price~person_capacity, scrape_rotterdam))
plot(scrape_rotterdam$person_capacity, scrape_rotterdam$price)
cor(scrape_rotterdam$person_capacity, scrape_rotterdam$price)

summary(lm(price~beds, scrape_rotterdam))
plot(scrape_rotterdam$beds, scrape_rotterdam$price)
cor(scrape_rotterdam$beds, scrape_rotterdam$price)

bathrooms.c = scale(scrape_rotterdam$bathrooms, center = T, scale = F)
summary(lm(price~bathrooms.c, scrape_rotterdam))

summary(lm(price~bathrooms, scrape_rotterdam))
plot(scrape_rotterdam$bathrooms, scrape_rotterdam$price)
cor(scrape_rotterdam$bathrooms, scrape_rotterdam$price, use="complete.obs")

# no correlation..
summary(lm(price~picture_count, scrape_rotterdam))
plot(scrape_rotterdam$picture_count, scrape_rotterdam$price)
summary(lm(price~reviews_count, scrape_rotterdam))
plot(scrape_rotterdam$reviews_count, scrape_rotterdam$price)
