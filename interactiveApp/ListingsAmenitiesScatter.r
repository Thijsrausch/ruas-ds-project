calendar <- read.csv(file = "calendarAmsterdam.csv", header = TRUE, sep = ",")
listings <- read.csv(file = "listingsAmsterdam.csv", header = TRUE, sep = ",")
calendar <- calendar[,c(1,4)]
listings <- listings[,c(1,59)]
calendar$price = as.numeric(gsub("\\$", "", calendar$price))
calendar <- na.omit(calendar)
calendar <- aggregate(calendar$price, by=list(calendar$listing_id), FUN=mean)
colnames(calendar) <- c("listing_id", "price")
calendarAndListings <- merge(listings, calendar, by.x="id", by.y="listing_id")
calendarAndListings$amenities <- lengths(regmatches(calendarAndListings$amenities, gregexpr(",", calendarAndListings$amenities)))
calendarAndListings <- calendarAndListings[which(1:9231 %% 30 == 0),]
plot(calendarAndListings$amenities, calendarAndListings$price)
