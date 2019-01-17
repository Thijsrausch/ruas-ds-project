library("jsonlite")
library(dplyr)
scrape <- fromJSON("airbnb-1.json")
scrape_rotterdam <- scrape[scrape$city=="Rotterdam",]

sqrt((51.9225 - scrape_rotterdam$latitude)^2 + (4.47917 - scrape_rotterdam$longitude)^2)


scrape_rotterdam %>% mutate(distance=sqrt((51.9225 - latitude)^2 + (4.47917 - longitude)^2)) -> scrape_rotterdam

dist_no_out<- scrape_rotterdam[!scrape_rotterdam$distance %in% boxplot.stats(scrape_rotterdam$distance)$out, ]
no_out<- dist_no_out[!dist_no_out$price %in% boxplot.stats(dist_no_out$price)$out, ]
price_no_out<- scrape_rotterdam$distance[!scrape_rotterdam$distance %in% boxplot.stats(scrape_rotterdam$distance)$out]

plot(no_out$distance, (no_out$price))
boxplot((scrape_rotterdam$distance))
boxplot((scrape_rotterdam$price))


cor(no_out$distance, no_out$price)
summary(lm(distance~price, no_out))


