library(dplyr)
library(jsonlite)
library(rgdal)
library(rgeos)
library("sp")

r_wijk <- readOGR('POLYGON.shp', layer='POLYGON')

scrape <- fromJSON("airbnb-scrape-1.json")
scrape_rotterdam <- scrape[scrape$city=="Rotterdam",]
scrape_rotterdam_geo <- scrape_rotterdam

kwb <- read.csv("indexcijfers-wijk-rotterdam.csv", TRUE, ";")

coordinates(scrape_rotterdam_geo) <- ~ longitude + latitude
proj4string(scrape_rotterdam_geo) <- CRS("+proj=longlat")
scrape_rotterdam_geo <- spTransform(scrape_rotterdam_geo, proj4string(r_wijk))

plot(r_wijk)
points(scrape_rotterdam_geo)

tomerge <- over(scrape_rotterdam_geo, r_wijk)

scrape_rotterdam$wijknaam <- tomerge$name

bak <- scrape_rotterdam
bak[ncol(bak)] <- lapply(bak[ncol(bak)], as.character)
bak[grepl("Rotterdam", bak$wijknaam),]$wijknaam <- "Rotterdam Centrum"

bak$FI <- kwb$FI[match(unlist(bak$wijknaam), kwb$regio)]
bak$VI <- kwb$VI[match(unlist(bak$wijknaam), kwb$regio)]
bak$SI <- kwb$SI[match(unlist(bak$wijknaam), kwb$regio)]

agrigate <- bak%>% group_by(wijknaam) %>% summarise(mean=mean(price), SI=mean(SI), FI=mean(FI), VI=mean(VI)) %>% as.data.frame
plot(agrigate$mean, agrigate$SI)
summary(lm(price~FI+VI+SI, bak))
plot(bak$FI, bak$price)
points(bak$VI, bak$price, col='red')
points(bak$SI, bak$price, col='blue')
cor(bak$FI, bak$price, use="complete.obs")

summary(lm(price~VI, bak))
plot(bak$VI, bak$price)
cor(bak$VI, bak$price, use="complete.obs")

summary(lm(price~SI, bak))
plot(bak$SI, bak$price)
cor(bak$SI, bak$price, use="complete.obs")

